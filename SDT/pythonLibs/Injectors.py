import re
from .Searchers import extraire_blocs_main

def includeSTDlibs(filepath: str, relative_to_root: str, colorvariable: str):  
    """"
    Injecte les includes de SDT et les #define correspondants avant chaque main() du fichier shader.
    PRECONDITION : le fichier doit être un fichier texte lisible.
    POSTCONDITION : le fichier est modifié avec l'injection de l'include et du #define correspondant,
                    ou reste inchangé si déjà modifié.
    
    """
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()
        
    if "#modified" in content:
        print(f"[!] {filepath} déjà modifié (présence de '#modified').")
        return

    liste_interieurs_mains = extraire_blocs_main(content) 
    
    if not liste_interieurs_mains:
        print(f"[!] Aucun bloc main détecté dans {filepath}")
        return

    regex_fsh = None
    if colorvariable:
        regex_fsh = rf"\b{re.escape(colorvariable)}\b(?:\.[a-zA-Z_]\w*)?\s*=(?!=)"
    
    matches_main = list(re.finditer(r"\bvoid\s+main\s*\(\s*\)", content))
    if len(matches_main) != len(liste_interieurs_mains):
        print(f"[!] Erreur de correspondance des blocs main dans {filepath}")
        return
    
    file_modified = False
    
    for i in reversed(range(len(matches_main))):
        match = matches_main[i]
        interieur_main = liste_interieurs_mains[i]
        
        if regex_fsh and re.search(regex_fsh, interieur_main):
            define_tag = "#define FSHSDT"
        else:
            define_tag = "#define VSHSDT"
            
        start_pos = match.start()
        
        segment_precedent = content[max(0, start_pos-60):start_pos]
        if f"{define_tag}\n#include" in segment_precedent:
            continue
            
        injection = f"{define_tag}\n#include \"/lib/sdt/SDTmain.glsl\"\n"
        content = content[:start_pos] + injection + content[start_pos:]
        file_modified = True
        print(f"[+] Injection préparée avant le main n°{i+1} ({define_tag})")

    if file_modified:
        with open(filepath, 'w', encoding='utf-8') as file:
            file.write(content)
        print(f"[+++] Fichier {filepath} mis à jour avec succès.\n")
    else:
        print(f"[~] Aucune modification nécessaire pour {filepath}\n")

def inject_SDTfunctionsinmain(filepath: str, shader_root: str, colorvariable: str = None):
    """"
    Injecte les fonctions d'injections de SDT en routant selon le CONTENU réel du
    fichier (nombre de main() et présence d'une assignation de texture sur la
    variable couleur), et non selon l'extension : certains packs (E-LITE…) mettent
    le code fragment dans des .glsl inclus, qui seraient sinon mal classés.
    PRECONDITION : le fichier doit être un fichier texte lisible.
    POSTCONDITION : le fichier est modifié avec l'injection de la fonction SDT correspondante,
                    ou reste inchangé si déjà modifié.
    """
    includeSTDlibs(filepath, shader_root, colorvariable)

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    mains = extraire_blocs_main(content)

    def _is_fragment_main(bloc):
        if not colorvariable:
            return False
        return bool(re.search(
            rf"\b{re.escape(colorvariable)}\b(?:\.[a-zA-Z_]\w*)?\s*=(?!=)", bloc))

    if len(mains) >= 2:
        if not colorvariable:
            print(f"[!] Variable couleur introuvable, injection sautée : {filepath}")
            return
        injectBothSDTinmains(filepath, colorvariable)
    elif len(mains) == 1:
        if _is_fragment_main(mains[0]):
            injectFSHSDTinmain(filepath, colorvariable)
        else:
            injectVSHSDTinmain(filepath)
    else:
        print(f"[!] Aucun bloc main détecté dans {filepath}")

def ajouter_tampon_modified(content: str) -> str:
    """Ajoute le marqueur "//#modified" de façon version-aware.
    En GLSL, la directive #version doit rester le tout premier token du fichier ;
    on insère donc le tampon juste APRÈS la ligne #version si elle existe, sinon en tête.
    PRECONDITION : content est le contenu textuel du shader.
    POSTCONDITION : retourne le contenu avec le marqueur ajouté sans casser #version.
    """
    if re.search(r"^\s*#version\b.*$", content, flags=re.MULTILINE):
        return re.sub(r"^(\s*#version\b.*)$", r"\1\n//#modified",
                      content, count=1, flags=re.MULTILINE)
    return "//#modified\n" + content

def injectFSHSDTinmain(filepath: str, colorvariable: str) -> bool:
    """
    Injecte la fonction ApplyTextureSynthesis(colorvariable);
    juste après l'assignation de la texture principale en gérant les fichiers.
    PRECONDITION : le fichier doit être un fichier texte lisible.
    POSTCONDITION : le fichier est modifié avec l'injection de la fonction SDT du FSH 
                    ou reste inchangé si déjà modifié.
    """
    try:
        with open(filepath, 'r', encoding='utf-8') as file:
            content = file.read()

        if "//#modified" in content:
            print("already modified")
            return False

        blocs = extraire_blocs_main(content)
        if not blocs:
            print(f"[!] Aucun bloc main trouvé par extraire_blocs_main dans {filepath}")
            return False

        contenu_main_original = blocs[0]
        contenu_main_modifie = inserer_applyFSH_dans_bloc_main(contenu_main_original, colorvariable)
        if contenu_main_modifie is None:
            print(f"[!] Impossible de trouver l'assignation de texture pour '{colorvariable}' dans le main de {filepath}")
            return False

        content_modifie = content.replace(contenu_main_original, contenu_main_modifie, 1)
        content_modifie = ajouter_tampon_modified(content_modifie)  # tampon version-aware, après succès

        with open(filepath, 'w', encoding='utf-8') as file:
            file.write(content_modifie)
        return True

    except Exception as e:
        print(f"[X] Erreur lors de l'injection dans {filepath} : {e}")
        return False
        

def injectVSHSDTinmain(filepath: str):
    """
    injecte la fonction PrepareTextureSynthesisVSH() dans le main d'un vsh
    PRECONDITION : le fichier doit être un fichier texte lisible servant de shader vertex 
                   avec une fonction main().
    POSTCONDITION : le fichier est modifié avec l'injection de la fonction SDT du VSH, 
                    ou reste inchangé si déjà modifié.
    """
    try:
        with open(filepath, 'r', encoding='utf-8') as file:
            content = file.read()

        if "//#modified" in content:
            return False

        blocs = extraire_blocs_main(content)
        if not blocs:
            print(f"[!] Aucun bloc main trouvé par extraire_blocs_main dans {filepath}")
            return False

        contenu_main_original = blocs[0]
        contenu_main_modifie = inserer_prepareVSH_dans_bloc_main(contenu_main_original)
        if contenu_main_modifie is None:
            print(f"[!] Impossible d'injecter PrepareTextureSynthesisVSH() dans le main de {filepath}")
            return False

        content_modifie = content.replace(contenu_main_original, contenu_main_modifie, 1)
        content_modifie = ajouter_tampon_modified(content_modifie)  # tampon version-aware, après succès
        with open(filepath, 'w', encoding='utf-8') as file:
            file.write(content_modifie)
        return True
    except Exception as e:
        print(f"[X] Erreur lors de l'injection dans {filepath} : {e}")
        return False

def injectBothSDTinmains(filepath: str,colorvariable: str):
    """
    injecte les fonctions ApplyTextureSynthesis(inout vec4 color, in vec3 fragPos) et PrepareTextureSynthesisVSH() 
    dans les mains d'un shader contenant à la fois le fragment et le vertex
    PRECONDITION : le fichier doit être un fichier texte lisible servant de shader avec deux fonction main().
                    une pour le vertex et une pour le fragment, 
                    et la variable couleur doit être présente dans le main du fragment.
    POSTCONDITION : le fichier est modifié avec l'injection des fonctions SDT dans les mains correspondants,
    """
    try:
        with open(filepath, 'r', encoding='utf-8') as file:
            content = file.read()

        if "//#modified" in content:
            return False

        mains = extraire_blocs_main(content)
        if len(mains) < 2:
            print(f"[!] Moins de 2 blocs main trouvés dans {filepath}, impossible d'injecter les fonctions SDT.")
            return False
        for main in mains:
            if re.search(rf"\b{re.escape(colorvariable)}\b(?:\.[a-zA-Z_]\w*)?\s*=(?!=)", main):
                contenu_main_modifie = inserer_applyFSH_dans_bloc_main(main, colorvariable)
                if contenu_main_modifie is None:
                    print(f"[!] Impossible de trouver l'assignation de texture pour '{colorvariable}' dans le main de {filepath}")
                    return False
                content = content.replace(main, contenu_main_modifie, 1)
            else:
                contenu_main_modifie = inserer_prepareVSH_dans_bloc_main(main)
                if contenu_main_modifie is None:
                    print(f"[!] Impossible d'injecter PrepareTextureSynthesisVSH() dans le main de {filepath}")
                    return False
                content = content.replace(main, contenu_main_modifie, 1)

        content = ajouter_tampon_modified(content) 
        with open(filepath, 'w', encoding='utf-8') as file:
            file.write(content)
        return True
    except Exception as e:
        print(f"[X] Erreur lors de l'injection dans {filepath} : {e}")
        return False


import re

def inserer_applyFSH_dans_bloc_main(contenu_main: str, colorvariable: str) -> str | None:
    """Insère ApplyTextureSynthesis après CHAQUE assignation de texture de la
    variable couleur (les branches #ifdef exclusives en contiennent souvent plusieurs).
    PRECONDITION : contenu_main doit être une chaîne de caractères représentant le contenu d'un bloc main d'un Fragment Shader.
    POSTCONDITION : retourne le bloc main modifié avec ApplyTextureSynthesis() injecté après
                    chaque assignation de texture de la variable couleur,
                    ou None si aucune assignation n'a été trouvée.
    """
    color_esc = re.escape(colorvariable)
    pattern = rf"(\b{color_esc}\b(?:\.[a-zA-Z]+)?\s*=\s*\btexture(?!Size\b)[a-zA-Z0-9_]*\b\s*\([^;]*?\))(.*?);"

    if re.search(pattern, contenu_main):
        def _injecter(m):
            assignation = m.group(1)
            extra = m.group(2).strip()
            seq = f"{assignation};\n    ApplyTextureSynthesis({colorvariable});"
            if extra:
                seq += f"\n    {colorvariable} = {colorvariable} {extra};"
            return seq
        return re.sub(pattern, _injecter, contenu_main)
    fallback = rf"(\b{color_esc}\b(?:\.[a-zA-Z_]\w*)?\s*=(?!=)[^;]*;)"
    m = re.search(fallback, contenu_main)
    if m:
        seq = f"{m.group(1)}\n    ApplyTextureSynthesis({colorvariable});"
        return contenu_main[:m.start()] + seq + contenu_main[m.end():]

    return None
    

def inserer_prepareVSH_dans_bloc_main(contenu_main: str) -> str:
    """
    Prend en entrée le contenu textuel d'un bloc main de vertex shader (déjà extrait sans ses accolades).
    Retourne le bloc main modifié avec PrepareTextureSynthesisVSH() injecté au tout début.
    PRECONDITION : contenu_main doit être une chaîne de caractères représentant le contenu d'un bloc main d'un vertex shader.
    POSTCONDITION : retourne le bloc main modifié avec PrepareTextureSynthesisVSH() injecté au tout début.
    """
    ligne_injection = "\nPrepareTextureSynthesisVSH();\n"
    
    return ligne_injection + contenu_main

def inject_DefineChecksForUniforms(found_uniforms):
    """
    Remplace chaque déclaration par son bloc de vérification #ifndef, à son emplacement d'origine.
    PRECONDITION : found_uniforms doit être une liste de tuples contenant des déclarations d'uniforms et leurs chemins de fichiers respectifs.
    """
    SDT_UNIFORM_MACROS = {
        "gbufferModelViewInverse": "GBUFFERMODELVIEWINVERSE",
        "gbufferProjectionInverse": "GBUFFERPROJECTIONINVERSE",
        "viewWidth": "VIEWWIDTH",
        "viewHeight": "VIEWHEIGHT",
        "cameraPosition": "CAMERAPOSITION",
        "tex": "TEX",
        "atlasSize": "ATLASSIZE",
        "normalMatrix": "NORMALMATRIX",
        "modelViewMatrix": "MODELVIEWMATRIX"
    }
    
    for uniform_filepath in found_uniforms:
        filepath = uniform_filepath[1]
        uniforms_list = uniform_filepath[0]
        try:
            with open(filepath, 'r', encoding='utf-8') as file:
                content = file.read()
        except Exception as e:
            print(f"Erreur de lecture sur {filepath} : {e}")
            continue

        file_modified = False

        for declaration in uniforms_list:
            if declaration.strip().startswith("//") or declaration.strip().startswith("/*"):
                continue
            macros = [macro for name, macro in SDT_UNIFORM_MACROS.items()
                      if re.search(rf"\b{name}\b", declaration)]       
            if not macros:
                continue
                
            defines = "\n".join(f"#define {macro}" for macro in macros)
            clean_declaration = declaration.strip()
            injection = f"#ifndef {macros[0]}\n{clean_declaration}\n{defines}\n#endif"
            if injection in content:
                continue
            pattern = rf"(?m)^([ \t]*){re.escape(declaration)}"
            new_content, n = re.subn(pattern, lambda m: m.group(1) + injection, content)
            if n:
                content = new_content
                file_modified = True

        if file_modified:
            try:
                with open(filepath, 'w', encoding='utf-8') as file_write:
                    file_write.write(content)
            except Exception as e:
                print(f"Erreur d'écriture sur {filepath} : {e}")

def upgrade_glsl_version(filepath: str):
    """Si le fichier déclare un #version < 130, le remplace par
    '#version 330 compatibility' (requis par la lib SDT).
    Renvoie True si le fichier a été modifié.
    PRECONDITION : le fichier doit être un fichier texte lisible.
    POSTCONDITION : le fichier est modifié avec la version GLSL mise à jour,
                    ou reste inchangé si déjà à jour.
    """
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    m = re.search(r"#version\s+(\d+)[^\n]*", content)
    if m is None:
        return False
    if int(m.group(1)) >= 130:
        return False                       # déjà assez récent, rien à faire
    content = content[:m.start()] + "#version 330 compatibility" + content[m.end():]

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    return True

def inject_in450_defines(found_ins):
    """"
    Comme pour le inject_DefineChecksForUniforms, mais pour les #define spécifiques à GLSL 450.
    PRECONDITION : found_ins doit être une liste de tuples contenant des déclarations d'uniforms et leurs chemins de fichiers respectifs.
    POSTCONDITION : les fichiers sont modifiés avec l'injection des #define spécifiques à GLSL 450,
                    ou restent inchangés si déjà présents.
    """
    SDT450_MACROS = {
        "vaPosition" : "VAPOSITION",
        "vaNormal" : "VANORMAL",
        "vaUV0" : "VAUV0"
    }
    for ins_filepath in found_ins:
        filepath = ins_filepath[1]
        ins_list = ins_filepath[0]
        try:
            with open(filepath, 'r', encoding='utf-8') as file:
                content = file.read()
        except Exception as e:
            print(f"Erreur de lecture sur {filepath} : {e}")
            continue

        file_modified = False

        for declaration in ins_list:
            if declaration.strip().startswith("//") or declaration.strip().startswith("/*"):
                continue
            macros = [macro for name, macro in SDT450_MACROS.items()
                      if re.search(rf"\b{name}\b", declaration)]
            if not macros:
                continue
            defines = "\n".join(f"#define {macro}" for macro in macros)
            clean_declaration = declaration.strip()
            injection = f"#ifndef {macros[0]}\n{clean_declaration}\n{defines}\n#endif"

            if injection in content:
                continue
            pattern = rf"(?m)^([ \t]*){re.escape(declaration)}"
            new_content, n = re.subn(pattern, lambda m: m.group(1) + injection, content)
            if n:
                content = new_content
                file_modified = True
        if file_modified:
            try:
                with open(filepath, 'w', encoding='utf-8') as file_write:
                    file_write.write(content)
            except Exception as e:
                print(f"Erreur d'écriture sur {filepath} : {e}")

           