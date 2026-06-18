import os
import re
def find_gbuffers_terrain(directory_path: str, shader_root: str = None):
    """Parcourt le dossier directory_path à la recherche des fichiers gbuffers_terrain (.vsh ou .fsh)
      et retourne une liste de tuples :
      (chemin_complet_du_fichier, shader_root, chemin_relatif_du_fichier_par_rapport_au_shader_root)

      PRECONDITION : shader_root doit être un parent de directory_path ou égal à directory_path
      POSTCONDITION : retourne une liste de tuples pour chaque fichier trouvé, ou une liste vide si aucun fichier n'est trouvé ou en cas d'erreur.s
    """
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

            if os.path.isfile(item_path):
                if "gbuffers_terrain" in item.lower() and (item.lower().endswith('.vsh') or item.lower().endswith('.fsh')):
                    relative_to_root = os.path.relpath(shader_root, os.path.dirname(item_path))
                    found_shaders.append((item_path, shader_root, relative_to_root))
            elif os.path.isdir(item_path):
                found_shaders.extend(find_gbuffers_terrain(item_path, shader_root))
        
        return found_shaders
    
    except Exception as e:
        print(f"Error reading directory: {e}")
        return []
    
def hasMain(filepath: str):
    """"
    Retourne True si le fichier contient void main() sinon False.
    PRECONDITION : le fichier doit être un fichier texte lisible.
    POSTCONDITION : retourne True si le fichier contient void main() sinon False
    """
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()
        if re.search(r'(\s*)void\s+main\s*\([^)]*\)\s*\{', content):
            return True
        return False
    
def includesPathList(filepath: str):
    """"
    Retourne la liste des includes présents dans le ficchier passé en entrée
    PRECONDITION : le fichier doit être un fichier texte lisible.
    POSTCONDITION : retourne la liste des includes présents dans le fichier passé en entrée sous forme de liste de chaînes de caractères.
    """
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()
    includes = re.findall(r'#include\s+"([^"]+)"', content)
    return includes

import os

def collecter_macros(content: str, macros: dict = None) -> dict:
    """Accumule les #define du contenu dans macros = {"obj": {...}, "func": {...}}.
    - obj  : macros simples  #define NAME corps
    - func : macros-fonction #define NAME(p1,p2) corps
    PRECONDITION : content est le texte d'un shader.
    POSTCONDITION : retourne le dict macros (créé si None) enrichi des #define trouvés.
    """
    if macros is None:
        macros = {"obj": {}, "func": {}}
    for m in re.finditer(r'^[ \t]*#define[ \t]+([A-Za-z_]\w*)(\([^)]*\))?[ \t]*(.*)$', content, re.M):
        name, params, corps = m.group(1), m.group(2), m.group(3).strip()
        if params is None:
            if corps:                       # ignore les #define sans corps (ex. flags)
                macros["obj"][name] = corps
        else:
            plist = [p.strip() for p in params[1:-1].split(",") if p.strip()]
            macros["func"][name] = (plist, corps)
    return macros

def _split_args_top(s: str) -> list:
    """Découpe les arguments d'un appel sur les virgules de premier niveau (hors parenthèses)."""
    args, prof, cur = [], 0, ""
    for c in s:
        if c == "(":
            prof += 1; cur += c
        elif c == ")":
            prof -= 1; cur += c
        elif c == "," and prof == 0:
            args.append(cur); cur = ""
        else:
            cur += c
    if cur.strip() or args:
        args.append(cur)
    return [a.strip() for a in args]

def resoudre_macros(content: str, macros: dict) -> str:
    """Expanse (de façon best-effort) les macros object-like et function-like dans content.
    Utilisé UNIQUEMENT pour la détection ; le fichier réel n'est jamais réécrit avec ça.
    PRECONDITION : macros provient de collecter_macros.
    POSTCONDITION : retourne content avec les macros substituées (bornage à 6 passes anti-boucle).
    """
    if not macros:
        return content
    obj, func = macros.get("obj", {}), macros.get("func", {})
    for _ in range(6):
        nouveau = content

        for name, (plist, corps) in func.items():
            def _repl(mm, plist=plist, corps=corps):
                appel_args = _split_args_top(mm.group(1))
                if len(appel_args) != len(plist):
                    return mm.group(0)
                res = corps
                for p, a in zip(plist, appel_args):
                    res = re.sub(rf"\b{re.escape(p)}\b", a, res)
                return res
            nouveau = re.sub(rf"\b{re.escape(name)}\b\s*\(([^()]*)\)", _repl, nouveau)

        for name, corps in obj.items():
            nouveau = re.sub(rf"\b{re.escape(name)}\b", corps, nouveau)

        if nouveau == content:
            break
        content = nouveau
    return content

def findMainFunction(filepath: str, shader_root: str, _visited: set = None, _macros: dict = None) -> bool:
    """
    Recherche récursivement la fonction main() dans le fichier donné et ses fichiers inclus.
    PRECONDITION : le fichier doit être un fichier texte lisible.
    POSTCONDITION : retourne une liste [filepath, shader_root, nom_variable_couleur] ou [filepath, shader_root]
                    si le fichier contient void main() et est soit un fichier de fragment,
                    soit un fichier de vertex, sinon retourne False.
    NOTE : _visited protège contre les boucles d'includes (certains packs, ex. DrDestens,
           ont des fichiers world*/gbuffers_terrain.fsh qui incluent /gbuffers_terrain.fsh).
           _macros accumule les #define rencontrés le long du graphe d'includes, afin de
           résoudre les variables couleur masquées par des macros (ex. I Like Vanilla, Photon).
    """
    if _visited is None:
        _visited = set()
    if _macros is None:
        _macros = {"obj": {}, "func": {}}
    real = os.path.normpath(os.path.realpath(filepath))
    if real in _visited:
        return False
    _visited.add(real)

    try:
        with open(filepath, 'r', encoding='utf-8') as _f:
            collecter_macros(_f.read(), _macros)
    except Exception:
        pass

    if hasMain(filepath):
        if not ".vsh" in filepath.lower():
            return [filepath,shader_root ,obtenir_nom_variable_couleur_universel(filepath, _macros)]
        else:
            return [filepath,shader_root]

    shaders_dir = os.path.join(shader_root, "shaders")
    includes = includesPathList(filepath)
    for i in includes:
        i_clean = i.lstrip("/\\")

        if i.startswith("/") or i.startswith("\\"):
            # Include absolu (sémantique Iris) : relatif au dossier shaders/, jamais au fichier courant.
            candidates = [
                os.path.join(shaders_dir, i_clean),
                os.path.join(shader_root, i_clean),
            ]
        else:
            # Include relatif : relatif au fichier courant.
            candidates = [
                os.path.join(os.path.dirname(filepath), i_clean),
                os.path.join(os.path.dirname(filepath), "shaders", i_clean),
                os.path.join(shaders_dir, i_clean),
            ]

        include_path = None
        for cand in candidates:
            cand = os.path.normpath(cand)
            if os.path.isfile(cand):
                include_path = cand
                break

        if include_path is None:
            print(f"[!] Impossible de localiser le fichier inclus : {i}")
            continue

        result = findMainFunction(include_path, shader_root, _visited, _macros)
        if result is not False:
            return result

    return False

import re

def extraire_blocs_main(contenu_fichier):
    """
    Trouve toutes les fonctions void main() et extrait leur contenu exact
    en gérant correctement l'imbrication des accolades {}.
    PRECONDITION : contenu_fichier doit être une chaîne de caractères représentant le contenu d'un fichier.
    POSTCONDITION : retourne une liste de chaînes de caractères, chaque chaîne représentant
                    le contenu d'une fonction main() trouvée dans le fichier.
    """
    blocs_main = []
    for match in re.finditer(r"\bvoid\s+main\s*\(\s*\)", contenu_fichier):
        start_idx = match.end()
        
        open_bracket_idx = contenu_fichier.find("{", start_idx)
        if open_bracket_idx == -1:
            continue
            
        compteur = 1
        current_idx = open_bracket_idx + 1
        
        while compteur > 0 and current_idx < len(contenu_fichier):
            char = contenu_fichier[current_idx]
            if char == "{":
                compteur += 1
            elif char == "}":
                compteur -= 1
            current_idx += 1
            
        contenu_main = contenu_fichier[open_bracket_idx + 1 : current_idx - 1]
        blocs_main.append(contenu_main)
        
    return blocs_main

def obtenir_nom_variable_couleur_universel(chemin_fichier, macros: dict = None):
    """"
    Retourne le nom de la variable de couleur du pixel en cherchant dans les mains du shader passé en entrée.
    Les macros (object-like et function-like) sont d'abord résolues, ce qui permet de détecter
    la variable même quand l'échantillonnage est masqué par une macro 
    PRECONDITION : le fichier doit être un fichier texte lisible. macros provient de collecter_macros.
    POSTCONDITION : retourne le nom de la variable de couleur du pixel si trouvé, sinon retourne False.
    """
    try:
        with open(chemin_fichier, 'r', encoding='utf-8') as f:
            contenu = f.read()

        # Macros locales au fichier + macros accumulées le long des includes.
        macros_local = collecter_macros(contenu, {"obj": dict((macros or {}).get("obj", {})),
                                                  "func": dict((macros or {}).get("func", {}))})
        contenu_resolu = resoudre_macros(contenu, macros_local)

        # Builtins d'échantillonnage acceptés (texture, texture2D, textureLod, textureGrad, texelFetch…)
        # ; premier argument = un sampler de texture principale connu.
        pattern_texture = (r"\b([a-zA-Z_][a-zA-Z0-9_]*)\b(?:\.[a-zA-Z]+)?\s*=\s*"
                           r"(?:\btexture(?!Size\b)[a-zA-Z0-9_]*|\btexelFetch)\b\s*\(\s*"
                           r"(?:g?texture|tex|gcolor)\b")

        for contenu_main in extraire_blocs_main(contenu_resolu):
            match = re.search(pattern_texture, contenu_main)
            if match:
                return match.group(1)

        print("[!] Aucun main() ne correspond aux critères de texture principale.")
        return False

    except Exception as e:
        print(f"[X] Erreur : {e}")
        return False
    
import os

def searchforSDTUniforms(filepath: str):
    """
    Recherche les déclarations d'uniforms dans le fichier donné et retourne une liste de tuples.
    PRECONDITION : le fichier doit être un fichier texte lisible.
    POSTCONDITION : retourne une liste de la forme :
                    [[[declaration1, declaration2], fichierpath], [[declaration1], fichierpath], ...]
                    Les déclarations sont trouvées par NOM d'uniform (regex), 
                    ce qui attrape aussi les déclarations groupées : uniform float viewWidth, viewHeight;
    """
    SdtUniformNames = [
        "gbufferModelViewInverse",
        "gbufferProjectionInverse",
        "viewWidth",
        "viewHeight",
        "cameraPosition",
        "tex",
        "atlasSize",
        "normalMatrix",
        "modelViewMatrix"
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
            if os.path.basename(os.path.dirname(filepath)) == "sdt":
                return []
            if filepath.lower().endswith(('.vsh', '.fsh', '.gsh', '.csh', '.glsl', '.inc')):
                file_uniforms = []
                with open(filepath, 'r', encoding='utf-8') as file:
                    content = file.read()
                for name in SdtUniformNames:
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
    
def special450variables(filepath: str):
    """"
    recherche les déclarations de variables in propre a la version 450
    PRECONDITION : le fichier doit être un fichier texte lisible.
    POSTCONDITION : retourne une liste de la forme :

    """

    inName = [
        "vaPosition",
        "vaNormal",
        "vaUV0"
    ]

    found_in_declarations = []
    try:
        if os.path.isdir(filepath):
            items = os.listdir(filepath)
            for item in items:
                item_path = os.path.join(filepath, item)
                found_in_declarations_rec = special450variables(item_path)
                if found_in_declarations_rec:
                        found_in_declarations.extend(found_in_declarations_rec)
            return found_in_declarations
        else:
            if filepath.lower().endswith(('.vsh', '.fsh', '.gsh', '.csh', '.glsl', '.inc')):
                file_in_declarations = []
                with open(filepath, 'r', encoding='utf-8') as file:
                    content = file.read()
                for name in inName:
                    pattern = rf"^[ \t]*in\s[^;]*\b{name}\b[^;]*;"
                    for m in re.finditer(pattern, content, re.M):
                        declaration = m.group(0).strip()
                        if declaration not in file_in_declarations:
                            file_in_declarations.append(declaration)
                if len(file_in_declarations) > 0:
                    return [[file_in_declarations, filepath]]
                else:
                    return []
            else:
                return []
    except Exception as e:
        print(f"Error reading file: {e}")
        return []

def GetVersion (filepath: str):
    """
    Recherche la version du shader de terrain en fonction du #version déclaré
    PRECONDITION : le fichier doit être un fichier texte lisible ou un dossier contenant des fichiers texte lisibles.
    POSTCONDITION : retourne un entier correspondant à la version GLSL trouvée dans le fichier, ou None si aucune version n'est trouvée ou en cas d'erreur.
    """
    try:
        if os.path.isdir(filepath):
            items = os.listdir(filepath)
            for item in items:
                item_path = os.path.join(filepath, item)
                version_rec = GetVersion(item_path)
                if version_rec is not None:
                    return version_rec
            return None
        else:
            version_number = None
            with open(filepath, 'r', encoding='utf-8') as file:
                content = file.read()
            version_match = re.search(r'^\s*#version\s+(\d+)', content, re.M)
            if version_match:
                version_number = int(version_match.group(1))
            return version_number
    except Exception as e:
        print(f"Error reading file: {e}")
        return None