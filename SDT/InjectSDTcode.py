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

if __name__ == "__main__":
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
    else:
        file_path = input("Enter the shader root directory path: ")
    dir_path = os.path.dirname(os.path.abspath(file_path))
    base_name = os.path.splitext(os.path.basename(file_path))  # ('nomfichier', '.ext')
    
    new_name = base_name[0] + "_SDT" + base_name[1]            # 'nomfichier_SDT.ext'
    shaderSdtPath = os.path.join(dir_path, new_name)
    
    copy_folder_with_overwrite(file_path, shaderSdtPath)

    shaders = find_gbuffers_terrain(shaderSdtPath)
    copySdtToShaders(shaderSdtPath)
    for shader_path, shader_root, relative_to_root in shaders:

        shadersbis = [findMainFunction(shader_path, shader_root)]
        for shader in shadersbis:
            if len(shader) == 2:
                inject_SDTfunctionsinmain(shader[0], shader[1])
            elif len(shader) == 3:
                inject_SDTfunctionsinmain(shader[0], shader[1], shader[2])
    found_uniforms = searchforSDTUniforms(shaderSdtPath)
    inject_DefineChecksForUniforms(found_uniforms)