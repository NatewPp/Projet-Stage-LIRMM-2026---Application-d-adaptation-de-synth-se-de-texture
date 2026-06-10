import sys

from pythonLibs.Searchers import find_gbuffers_terrain, findMainFunction
from pythonLibs.Injectors import inject_SDTfunctionsinmain
from pythonLibs.placeSDT import copySdtToShaders
"""
if __name__ == "__main__":
    if len(sys.argv) > 1:
        dir_path = sys.argv[1]
    else:
        dir_path = input("Enter the shader root directory path: ")
    
    shaders = find_gbuffers_terrain(dir_path)
    obtenir_nom_variable_couleur()
"""

if __name__ == "__main__":
    if len(sys.argv) > 1:
        dir_path = sys.argv[1]
    else:
        dir_path = input("Enter the shader root directory path: ")
    shaders = find_gbuffers_terrain(dir_path)
    copySdtToShaders(dir_path)
    for shader_path, shader_root, relative_to_root in shaders:

        shadersbis = [findMainFunction(shader_path, shader_root)]
        for shader in shadersbis:
            if len(shader) == 2:
                inject_SDTfunctionsinmain(shader[0], shader[1])
            elif len(shader) == 3:
                inject_SDTfunctionsinmain(shader[0], shader[1], shader[2])