import os
import re
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
    
def hasMain(filepath: str):
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()
        if re.search(r'(\s*)void\s+main\s*\([^)]*\)\s*\{', content):
            return True
        return False
    
def includesPathList(filepath: str):
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()
    includes = re.findall(r'#include\s+"([^"]+)"', content)
    return includes

import os

def findMainFunction(filepath: str, shader_root: str) -> bool:
    if hasMain(filepath):
        if not ".vsh" in filepath.lower():
            return [filepath,shader_root ,obtenir_nom_variable_couleur_universel(filepath)]
        else:
            return [filepath,shader_root]
        
    includes = includesPathList(filepath)
    for i in includes:
        i_clean = i.lstrip("/\\")
        
        # 1. Gestion de l'include ABSOLU (ex: /program/gbuffers_terrain.fsh)
        # La racine GLSL est TOUJOURS le dossier 'shaders' du shaderpack.
        # On s'assure que shader_root pointe bien vers 'MellowShaderv3/shaders'
        
        shaders_dir = os.path.join(shader_root, "shaders")
            
        path_relative_to_root = os.path.join(shader_root, i_clean)
        path_relative_to_rootBIS = os.path.join(shaders_dir, i_clean)

        path_relative_to_file = os.path.join(os.path.dirname(filepath), i_clean)
        path_relative_to_fileBIS = os.path.join(os.path.dirname(filepath), "shaders", i_clean)
        # Normalisation des chemins (résout les /../ et les // magiques)
        path_relative_to_root = os.path.normpath(path_relative_to_root)
        path_relative_to_file = os.path.normpath(path_relative_to_file)
        path_relative_to_fileBIS = os.path.normpath(path_relative_to_fileBIS)
        path_relative_to_rootBIS = os.path.normpath(path_relative_to_rootBIS)
        
        if os.path.isfile(path_relative_to_root):
            include_path = path_relative_to_root
        elif os.path.isfile(path_relative_to_file):
            include_path = path_relative_to_file
        elif os.path.isfile(path_relative_to_fileBIS):
            include_path = path_relative_to_fileBIS
        elif os.path.isfile(path_relative_to_rootBIS):
            include_path = path_relative_to_rootBIS
        else:
            print(f"[Warning] Impossible de localiser le fichier inclus : {i}")
            continue
            
        result = findMainFunction(include_path, shader_root)
        if result is not False:
            return result

    return False

import re

def extraire_blocs_main(contenu_fichier):
    """
    Trouve toutes les fonctions void main() et extrait leur contenu exact
    en gérant correctement l'imbrication des accolades {}.
    """
    blocs_main = []
    # Trouve l'index de départ de chaque "void main()"
    for match in re.finditer(r"\bvoid\s+main\s*\(\s*\)", contenu_fichier):
        start_idx = match.end()
        
        # On cherche la première accolade ouvrante après "void main()"
        open_bracket_idx = contenu_fichier.find("{", start_idx)
        if open_bracket_idx == -1:
            continue
            
        # Compteur d'accolades pour trouver la fin réelle du main
        compteur = 1
        current_idx = open_bracket_idx + 1
        
        while compteur > 0 and current_idx < len(contenu_fichier):
            char = contenu_fichier[current_idx]
            if char == "{":
                compteur += 1
            elif char == "}":
                compteur -= 1
            current_idx += 1
            
        # On extrait ce qu'il y a strictement entre les accolades du main
        contenu_main = contenu_fichier[open_bracket_idx + 1 : current_idx - 1]
        blocs_main.append(contenu_main)
        
    return blocs_main

def obtenir_nom_variable_couleur_universel(chemin_fichier):
    try:
        with open(chemin_fichier, 'r', encoding='utf-8') as f:
            contenu = f.read()
            
        # 1. On extrait proprement tous les corps de main()
        les_main = extraire_blocs_main(contenu)
        # meme regex que dans obtenir_nom_variable_couleur mais appliquée à chaque main() trouvé
        pattern_texture = r"\b([a-zA-Z_][a-zA-Z0-9_]*)\b(?:\.[a-zA-Z]+)?\s*=\s*\btexture(?!Size\b)[a-zA-Z0-9_]*\b\s*\(\s*(?:g?texture|tex)\b"
        
        for index, contenu_main in enumerate(les_main):
            match = re.search(pattern_texture, contenu_main)
            if match:
                nom_variable = match.group(1)
                return nom_variable
                
        print("[!] Aucun main() ne correspond aux critères de texture principale.")
        return False
        
    except Exception as e:
        print(f"[X] Erreur : {e}")
        return False
    
import os

def searchforSDTUniforms(filepath: str):
    """
    Renvoie une liste de la forme :
    [[[declaration1, declaration2], fichierpath], [[declaration1], fichierpath], ...]
    Les déclarations sont trouvées par NOM d'uniform (regex), ce qui attrape
    aussi les déclarations groupées : uniform float viewWidth, viewHeight;
    """
    SdtUniformNames = [
        "gbufferModelViewInverse",
        "gbufferProjectionInverse",
        "viewWidth",
        "viewHeight",
        "cameraPosition",
        "tex",
        "atlasSize",
    ]

    found_uniforms = []

    try:
        if os.path.isdir(filepath):
            items = os.listdir(filepath)
            for item in items:
                item_path = os.path.join(filepath, item)
                found_uniforms_rec = searchforSDTUniforms(item_path)

                if found_uniforms_rec:
                        found_uniforms.extend(found_uniforms_rec)

            return found_uniforms

        else:
            # la lib SDT (lib/sdt/) gère déjà ses propres gardes #ifndef : on ne la touche pas
            if os.path.basename(os.path.dirname(filepath)) == "sdt":
                return []
            if filepath.lower().endswith(('.vsh', '.fsh', '.gsh', '.csh', '.glsl', '.inc')):
                file_uniforms = []
                with open(filepath, 'r', encoding='utf-8') as file:
                    content = file.read()
                for name in SdtUniformNames:
                    # une déclaration complète (jusqu'au ;) contenant ce nom d'uniform
                    pattern = rf"^[ \t]*uniform\s[^;]*\b{name}\b[^;]*;"
                    for m in re.finditer(pattern, content, re.M):
                        declaration = m.group(0).strip()
                        if declaration not in file_uniforms:
                            file_uniforms.append(declaration)
                if len(file_uniforms) > 0:
                    return [[file_uniforms, filepath]]
                else:
                    return []
            else:
                return []

    except Exception as e:
        print(f"Error reading file: {e}")
        return []