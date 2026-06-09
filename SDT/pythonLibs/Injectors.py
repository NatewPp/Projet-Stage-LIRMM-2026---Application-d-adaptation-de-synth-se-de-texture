import os

def includeSTDlibs(filepath: str, relative_to_root: str):  

    ext = ".fsh" if ".fsh" in filepath.lower() else ".vsh"
    define_tag = "#define FSHSDT" if ext == ".fsh" else "#define VSHSDT"

    rel_path = relative_to_root.replace("\\", "/")
    prefix = "" if rel_path == "." else f"{rel_path}/"

    #lignes à include
    lignes_a_verifier = [
        f"{define_tag}\n",
        f'#include "{prefix}lib/sdt/textureSynthesis.glsl"\n',
        f'#include "{prefix}lib/sdt/textureSunthesisUVHints.glsl"\n',
        f'#include "{prefix}lib/sdt/mainSDT.glsl"\n'
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

def inject_SDTfunctionsinmain(filepath: str, relative_to_root: str):
    if ".fsh" in filepath.lower():
        inject_SDTfunctionsinmain(filepath, relative_to_root)
    elif ".vsh" in filepath.lower():
        inject_SDTfunctionsinmain(filepath, relative_to_root)
    else:
        injectBothSDTinmains(filepath, relative_to_root)

def injectModified(filepath: str):
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()
        if not content.startswith("#modified\n"):
            content = "#modified\n" + content
        else:
            return
    with open(filepath, 'w', encoding='utf-8') as file:
        file.write(content)

def injectFSHSDTinmain(filepath: str):
    """
    injecte la fonction ApplyTextureSynthesis(inout vec4 color, in vec3 fragPos) au début du main du fsh passer en entrée
    """
    injectModified(filepath)
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()
        
    with open(filepath, 'w', encoding='utf-8') as file:
        file.write(content)

def injectVSHSDTinmain(filepath: str):
    """
    injecte la fonction PrepareTextureSynthesisVSH() dans le main d'un vsh
    """

def injectBothSDTinmains(filepath: str):
    """
    injecte les fonctions ApplyTextureSynthesis(inout vec4 color, in vec3 fragPos) et PrepareTextureSynthesisVSH() dans les mains d'un shader contenant a la fois le fragment et le vertex
    """

def injecter_debut_main(filepath: str, code_a_injecter: str):
    """
    template d'injection simple
    """
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as file:
        content = file.read()

    if "#modified" in content:
        return

    match_main = re.search(r'void\s+main\s*\([^)]*\)\s*\{', content)
    if not match_main:
        print(f"Impossible de trouver le main() dans {os.path.basename(filepath)}")
        return
    index_insertion = match_main.end()
    "ApplyTextureSynthesis(inout vec4 color, in vec3 fragPos); for fsh and PrepareTextureSynthesisVSH() for vsh"
    bloc_injection = f"\n    // Début d'injection\n {code_a_injecter.strip()}\n"

    # 4. Insertion dans la chaîne de caractères
    contenu_modifie = content[:index_insertion] + bloc_injection + content[index_insertion:]

    # 6. Écriture du fichier
    with open(filepath, 'w', encoding='utf-8') as file:
        file.write(contenu_modifie)

    print(f"✅ [Success] Code injecté au début du main() dans : {os.path.basename(filepath)}")
    return True

