import os
import re
from .Searchers import extraire_blocs_main
def includeSTDlibs(filepath: str, relative_to_root: str):  
    ext = ".fsh" if ".fsh" in filepath.lower() else ".vsh"
    define_tag = "#define FSHSDT" if ext == ".fsh" else "#define VSHSDT"

    # Lignes à inclure
    lignes_a_verifier = [
        f"{define_tag}\n",
        f'#include "/lib/sdt/textureSynthesis.glsl"\n',
        f'#include "/lib/sdt/textureSunthesisUVHints.glsl"\n',
        f'#include "/lib/sdt/SDTmain.glsl"\n'
    ]

    with open(filepath, 'r', encoding='utf-8') as file:
        lignes_fichier = file.readlines()
        if "#modified\n" in lignes_fichier:
            print(f"[!] {filepath} semble déjà modifié, vérifiez la présence de '#modified' au début du fichier.")
            return
    
    # Par défaut, si pas de main(), on écrit au début
    index_insertion = 0
    
    # On cherche l'indice du "void main"
    for i, ligne in enumerate(lignes_fichier):
        if "void main" in ligne:
            index_insertion = i
            break

    # On insère les lignes juste avant l'index trouvé
    # (Utiliser un slice évite les boucles d'insertion complexes)
    lignes_fichier[index_insertion:index_insertion] = lignes_a_verifier

    # Réécriture du fichier avec les modifications
    with open(filepath, 'w', encoding='utf-8') as file:
        file.writelines(lignes_fichier)

def inject_SDTfunctionsinmain(filepath: str, shader_root: str, colorvariable: str = None):
    includeSTDlibs(filepath, shader_root)
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


def inserer_applyFSH_dans_bloc_main(contenu_main: str, colorvariable: str) -> str | None:
    """
    Prend en entrée le contenu textuel d'un bloc main et le nom de la variable couleur.
    Retourne le bloc main modifié, ou None si l'assignation de texture n'a pas été trouvée.
    """
    # Regex pour cibler "colorvariable = {fonctiontexture}(texture/gtexture/tex...)""
    pattern_assignation = rf"\b{re.escape(colorvariable)}\b(?:\.[a-zA-Z]+)?\s*=\s*\btexture[a-zA-Z0-9_]*\b\s*\(\s*(?:g?texture|tex)\b[^;]*;"
    
    match_ligne = re.search(pattern_assignation, contenu_main)
    if not match_ligne:
        return None
        
    ligne_originale = match_ligne.group(0)
    ligne_modifiee = f"{ligne_originale}\n    ApplyTextureSynthesis({colorvariable});"

    return contenu_main.replace(ligne_originale, ligne_modifiee, 1)

def inserer_prepareVSH_dans_bloc_main(contenu_main: str) -> str:
    """
    Prend en entrée le contenu textuel d'un bloc main de vertex shader (déjà extrait sans ses accolades).
    Retourne le bloc main modifié avec PrepareTextureSynthesisVSH() injecté au tout début.
    """
    ligne_injection = "\n   PrepareTextureSynthesisVSH();\n"
    
    return ligne_injection + contenu_main






