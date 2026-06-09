import os
import sys
import re

from pythonLibs.Searchers import find_gbuffers_terrain, hasMain, includesPathList,findMainFunction
from pythonLibs.Injectors import includeSTDlibs, inject_SDTfunctionsinmain,injectModified, injectFSHSDTinmain, injectVSHSDTinmain, injectBothSDTinmains,injecter_debut_main

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
    for shader_path, shader_root, relative_to_root in shaders:
        print(findMainFunction(shader_path, shader_root))