import sys
import os

from pythonLibs.Searchers import find_gbuffers_terrain, findMainFunction,searchforSDTUniforms
from pythonLibs.Injectors import inject_SDTfunctionsinmain, inject_DefineChecksForUniforms
from pythonLibs.placeSDT import copySdtToShaders, copy_folder_with_overwrite
"""
if __name__ == "__main__":
    if len(sys.argv) > 1:
        dir_path = sys.argv[1]
    else:
        dir_path = input("Enter the shader root directory path: ")
    
    shaders = find_gbuffers_terrain(dir_path)
    obtenir_nom_variable_couleur()
"""

def inject_sdt(pack_path, dest=None):
    """Copie le shaderpack vers dest (ou <pack>_SDT à côté), y injecte le code SDT.
    Renvoie le chemin du pack créé."""
    if dest is None:
        dir_path = os.path.dirname(os.path.abspath(pack_path))
        base_name = os.path.splitext(os.path.basename(pack_path))
        dest = os.path.join(dir_path, base_name[0] + "_SDT" + base_name[1])

    copy_folder_with_overwrite(pack_path, dest)
    shaders = find_gbuffers_terrain(dest)
    copySdtToShaders(dest)
    for shader_path, shader_root, relative_to_root in shaders:
        shader = findMainFunction(shader_path, shader_root)
        if len(shader) == 2:
            inject_SDTfunctionsinmain(shader[0], shader[1])
        elif len(shader) == 3:
            inject_SDTfunctionsinmain(shader[0], shader[1], shader[2])
    inject_DefineChecksForUniforms(searchforSDTUniforms(dest))
    return dest


if __name__ == "__main__":
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
    else:
        file_path = input("Enter the shader root directory path: ")
    inject_sdt(file_path)