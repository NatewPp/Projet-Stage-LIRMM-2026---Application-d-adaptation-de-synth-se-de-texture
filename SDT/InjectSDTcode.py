import sys
import os

from pythonLibs.Searchers import find_gbuffers_terrain, findMainFunction,searchforSDTUniforms,special450variables,GetVersion
from pythonLibs.Injectors import inject_SDTfunctionsinmain, inject_DefineChecksForUniforms, upgrade_glsl_version,inject_in450_defines
from pythonLibs.placeSDT import copySdtToShaders, copy_folder_with_overwrite

def inject_sdt(pack_path, dest=None):
    
    """Copie le shaderpack vers dest (ou <pack>_SDT à côté), y injecte le code SDT.
    PRECONDITION : pack_path doit être un chemin valide vers un shaderpack.
    POSTCONDITION : le shaderpack est copié vers dest (ou <pack>_SDT à côté), avec le code SDT injecté dans les shaders.
    """
    if dest is None:
        dir_path = os.path.dirname(os.path.abspath(pack_path))
        base_name = os.path.splitext(os.path.basename(pack_path))
        dest = os.path.join(dir_path, base_name[0] + "_SDT" + base_name[1])

    copy_folder_with_overwrite(pack_path, dest)
    version = GetVersion(dest)
    print(version)
    shaders = find_gbuffers_terrain(dest)
    if version >= 450:
        copySdtToShaders(dest,True)
    else:
        copySdtToShaders(dest)
    for shader_path, shader_root, relative_to_root in shaders:
        upgrade_glsl_version(shader_path) 
        shader = findMainFunction(shader_path, shader_root)
        if len(shader) == 2:
            inject_SDTfunctionsinmain(shader[0], shader[1])
        elif len(shader) == 3:
            inject_SDTfunctionsinmain(shader[0], shader[1], shader[2])
    inject_DefineChecksForUniforms(searchforSDTUniforms(dest))
    if version is not None and version >= 450:
        inject_in450_defines(special450variables(dest))
    return dest


if __name__ == "__main__":
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
    else:
        file_path = input("Enter the shader root directory path: ")
    inject_sdt(file_path)