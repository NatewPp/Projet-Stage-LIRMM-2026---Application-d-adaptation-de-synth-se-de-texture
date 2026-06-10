import os
import re
from .Searchers import extraire_blocs_main
def includeSTDlibs(filepath: str, relative_to_root: str):  

    ext = ".fsh" if ".fsh" in filepath.lower() else ".vsh"
    define_tag = "#define FSHSDT" if ext == ".fsh" else "#define VSHSDT"

    #lignes à include
    lignes_a_verifier = [
        f"{define_tag}\n",
        f'#include "/lib/sdt/textureSynthesis.glsl"\n',
        f'#include "/lib/sdt/textureSunthesisUVHints.glsl"\n',
        f'#include "/lib/sdt/SDTmain.glsl"\n'
    ]

    with open(filepath, 'r', encoding='utf-8') as file:
        lignes_fichier = file.readlines()
    index_insertion = 0
    
    # si version on injecte juste apres
    for i, ligne in enumerate(lignes_fichier):
        if "#version" in ligne:
            index_insertion = i + 1
            break

    #verifie si des lignes ne sont pas deja ecrites
    fichiers_modifie = False 
    for ligne_sdt in reversed(lignes_a_verifier):
        if ligne_sdt not in lignes_fichier:
            lignes_fichier.insert(index_insertion, ligne_sdt)
            fichiers_modifie = True

    if fichiers_modifie:
        with open(filepath, 'w', encoding='utf-8') as file:
            file.writelines(lignes_fichier)
        print(f"[Success] Lignes SDT insérées au début de {os.path.basename(filepath)}")
    else:
        print(f"[Skipped] {os.path.basename(filepath)} (Toutes les lignes sont déjà présentes)")

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






