import os
import re
from .Searchers import extraire_blocs_main
import re

import re

def includeSTDlibs(filepath: str, relative_to_root: str, colorvariable: str):  
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()
        
    if "#modified" in content:
        print(f"[!] {filepath} déjà modifié (présence de '#modified').")
        return

    liste_interieurs_mains = extraire_blocs_main(content) 
    
    if not liste_interieurs_mains:
        print(f"[!] Aucun bloc main détecté dans {filepath}")
        return

    regex_fsh = rf"\b{re.escape(colorvariable)}\b(?:\.[a-zA-Z]+)?\s*=\s*\btexture[a-zA-Z0-9_]*\b\s*\(\s*(?:g?texture|tex)\b"
    
    matches_main = list(re.finditer(r"\bvoid\s+main\s*\(\s*\)", content))
    if len(matches_main) != len(liste_interieurs_mains):
        print(f"[!] Erreur de correspondance des blocs main dans {filepath}")
        return
    
    file_modified = False
    
    for i in reversed(range(len(matches_main))):
        match = matches_main[i]
        interieur_main = liste_interieurs_mains[i]
        
        if re.search(regex_fsh, interieur_main):
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
    includeSTDlibs(filepath, shader_root,colorvariable)
    if ".fsh" in filepath.lower():
        injectFSHSDTinmain(filepath, colorvariable)
    elif ".vsh" in filepath.lower():
        injectVSHSDTinmain(filepath)
    else:
        injectBothSDTinmains(filepath, colorvariable)

def injectModified(filepath: str):
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()
        if not content.startswith("#modified\n"):
            content = "#modified\n" + content
        else:
            return False
    with open(filepath, 'w', encoding='utf-8') as file:
        file.write(content)

def injectFSHSDTinmain(filepath: str, colorvariable: str) -> bool:
    """
    Injecte la fonction ApplyTextureSynthesis(colorvariable);
    juste après l'assignation de la texture principale en gérant les fichiers.
    """
    isNotModified = injectModified(filepath)
    if isNotModified is False:
        print("already modified")
        return False
    try:
        with open(filepath, 'r', encoding='utf-8') as file:
            content = file.read()

        blocs = extraire_blocs_main(content)
        if not blocs:
            print(f"[!] Aucun bloc main trouvé par extraire_blocs_main dans {filepath}")
            return False
            
        contenu_main_original = blocs[0]
        contenu_main_modifie = inserer_applyFSH_dans_bloc_main(contenu_main_original, colorvariable)     
        if contenu_main_modifie is None:
            print(f"[!] Impossible de trouver l'assignation de texture pour '{colorvariable}' dans le main de {filepath}")
            return False
        
        # On reinjecte le main modifie a la place du main original
        content_modifie = content.replace(contenu_main_original, contenu_main_modifie, 1)
        
        with open(filepath, 'w', encoding='utf-8') as file:
            file.write(content_modifie)
            
        print(f"[Succès] Synthèse de texture injectée après '{colorvariable}' dans {filepath}")
        return True

    except Exception as e:
        print(f"[X] Erreur lors de l'injection dans {filepath} : {e}")
        return False
        

def injectVSHSDTinmain(filepath: str):
    """
    injecte la fonction PrepareTextureSynthesisVSH() dans le main d'un vsh
    """
    isNotModified = injectModified(filepath)
    if isNotModified is False:
        return False
    try:
        with open(filepath, 'r', encoding='utf-8') as file:
            content = file.read()

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
        with open(filepath, 'w', encoding='utf-8') as file:
            file.write(content_modifie)
        
        print(f"[Succès] PrepareTextureSynthesisVSH() injectée dans le main de {filepath}")
        return True
    except Exception as e:
        print(f"[X] Erreur lors de l'injection dans {filepath} : {e}")
        return False

def injectBothSDTinmains(filepath: str,colorvariable: str):
    """
    injecte les fonctions ApplyTextureSynthesis(inout vec4 color, in vec3 fragPos) et PrepareTextureSynthesisVSH() dans les mains d'un shader contenant a la fois le fragment et le vertex
    """
    isNotModified = injectModified(filepath)
    if isNotModified is False:
        return False
    try:
        with open(filepath, 'r', encoding='utf-8') as file:
            content = file.read()
            mains = extraire_blocs_main(content)
            if len(mains) < 2:
                print(f"[!] Moins de 2 blocs main trouvés dans {filepath}, impossible d'injecter les fonctions SDT.")
                return False
            for main in mains:
                if re.search(rf"\b{re.escape(colorvariable)}\b(?:\.[a-zA-Z]+)?\s*=\s*\btexture[a-zA-Z0-9_]*\b\s*\(\s*(?:g?texture|tex)\b", main):
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
        with open(filepath, 'w', encoding='utf-8') as file:
            file.write(content)
        print(f"[Succès] Fonctions SDT injectées dans les mains de {filepath}")
        return True
    except Exception as e:
        print(f"[X] Erreur lors de l'injection dans {filepath} : {e}")
        return False


import re

def inserer_applyFSH_dans_bloc_main(contenu_main: str, colorvariable: str) -> str | None:
    """
    Prend en entrée le contenu textuel d'un bloc main et le nom de la variable couleur.
    Modifie la ligne d'assignation pour appliquer ApplyTextureSynthesis, et déporte 
    les opérations subséquentes (ex: * glcolor) après l'appel.
    """
    # Échappement pour la regex
    color_esc = re.escape(colorvariable)
    
    # Explication de la regex :
    # Group 1 : L'assignation de base de la texture -> color = texture(...stuff...)
    # Group 2 : Le "reste" optionnel de l'opération avant le point-virgule -> * glcolor
    pattern = rf"(\b{color_esc}\b(?:\.[a-zA-Z]+)?\s*=\s*\btexture[a-zA-Z0-9_]*\b\s*\([^;]*?\))(.*?);"
    
    match = re.search(pattern, contenu_main)
    if not match:
        return None
        
    ligne_originale = match.group(0) # La ligne entière trouvée
    assignation_texture = match.group(1) # color = texture(...)
    operations_extra = match.group(2).strip() # ex: * glcolor
    
    # Construction du nouveau bloc de code
    nouvelle_sequence = f"{assignation_texture};"
    nouvelle_sequence += f"\n    ApplyTextureSynthesis({colorvariable});"
    
   
    if operations_extra:
        nouvelle_sequence += f"\n    {colorvariable} = {colorvariable} {operations_extra};"
        
    return contenu_main.replace(ligne_originale, nouvelle_sequence, 1)

def inserer_prepareVSH_dans_bloc_main(contenu_main: str) -> str:
    """
    Prend en entrée le contenu textuel d'un bloc main de vertex shader (déjà extrait sans ses accolades).
    Retourne le bloc main modifié avec PrepareTextureSynthesisVSH() injecté au tout début.
    """
    ligne_injection = "\nPrepareTextureSynthesisVSH();\n"
    
    return ligne_injection + contenu_main

def inject_DefineChecksForUniforms(found_uniforms):
    """
    found_uniforms de la forme [[[uniform1, uniforme2], fichierpath], ...]
    Remplace chaque uniforme par son bloc de vérification #ifndef à son emplacement d'origine.
    """
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

        for uniform in uniforms_list:
            define_name = uniform.strip().replace(";", "").split()[-1].upper()
            injection = f"#ifndef {define_name}\n{uniform}\n#define {define_name}\n#endif"

            if injection in content:
                continue
            if uniform in content:
                content = content.replace(uniform, injection)
                file_modified = True

        if file_modified:
            try:
                with open(filepath, 'w', encoding='utf-8') as file_write:
                    file_write.write(content)
            except Exception as e:
                print(f"Erreur d'écriture sur {filepath} : {e}")