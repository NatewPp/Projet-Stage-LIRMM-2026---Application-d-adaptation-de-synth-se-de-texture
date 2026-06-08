import os
import sys

def find_gbuffers_terrain(directory_path: str, shader_root: str = None):
    if shader_root is None:
        shader_root = directory_path
    
    if not os.path.isdir(directory_path):
        print(f"Error: '{directory_path}' is not a valid directory")
        return []
    
    found_shaders = []
    
    try:
        items = os.listdir(directory_path)
        
        for item in items:
            item_path = os.path.join(directory_path, item)
            
            # Check if it's a gbuffers_terrain file
            if os.path.isfile(item_path):
                if "gbuffers_terrain" in item.lower() and (item.lower().endswith('.vsh') or item.lower().endswith('.fsh')):
                    # Calculate relative path FROM file TO shader root
                    relative_to_root = os.path.relpath(shader_root, os.path.dirname(item_path))
                    found_shaders.append((item_path, shader_root, relative_to_root))
            elif os.path.isdir(item_path):
                found_shaders.extend(find_gbuffers_terrain(item_path, shader_root))
        
        return found_shaders
    
    except Exception as e:
        print(f"Error reading directory: {e}")
        return []

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


if __name__ == "__main__":
    if len(sys.argv) > 1:
        dir_path = sys.argv[1]
    else:
        dir_path = input("Enter the shader root directory path: ")
    
    shaders = find_gbuffers_terrain(dir_path)
    for i in shaders:
        includeSTDlibs(i[0], i[1])
    


