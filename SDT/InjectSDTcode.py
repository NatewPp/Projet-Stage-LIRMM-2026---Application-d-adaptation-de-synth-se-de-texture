import sys
import os, re

from pythonLibs.Searchers import find_gbuffers_terrain, findMainFunction,searchforSDTUniforms,special450variables,GetVersion
from pythonLibs.Injectors import inject_SDTfunctionsinmain, inject_DefineChecksForUniforms, upgrade_glsl_version,inject_in450_defines
from pythonLibs.placeSDT import copySdtToShaders, copy_folder_with_overwrite
import zipfile, tempfile, shutil

def inject_sdt(pack_path, dest=None):
    """Copie le shaderpack vers dest (ou <pack>_SDT à côté), y injecte le code SDT.
    L'entrée peut être un DOSSIER de shaderpack ou un fichier .ZIP.
    PRECONDITION : pack_path doit être un chemin valide vers un dossier ou un .zip de shaderpack.
    POSTCONDITION : le shaderpack est copié vers dest (ou <pack>_SDT à côté), avec le code SDT injecté.
    """
    tmp_extract = None
    try:
        # 1) Source : dossier direct, ou extraction temporaire si .zip
        if pack_path.lower().endswith(".zip"):
            tmp_extract = tempfile.mkdtemp()
            with zipfile.ZipFile(pack_path) as z:
                z.extractall(tmp_extract)
            source = tmp_extract
            # certains zips ont shaders/ à la racine, d'autres dans un sous-dossier unique
            if not os.path.isdir(os.path.join(source, "shaders")):
                subs = [d for d in os.listdir(source)
                        if os.path.isdir(os.path.join(source, d))]
                if len(subs) == 1 and os.path.isdir(os.path.join(source, subs[0], "shaders")):
                    source = os.path.join(source, subs[0])
        else:
            source = pack_path

        # 2) Destination : on enlève l'extension .zip pour ne pas avoir "X.zip_SDT"
        if dest is None:
            dir_path = os.path.dirname(os.path.abspath(pack_path))
            base = os.path.basename(os.path.normpath(pack_path))
            if base.lower().endswith(".zip"):
                base = base[:-4]
            dest = os.path.join(dir_path, base + "_SDT")

        # 3) Copie + injection (logique inchangée)
        copy_folder_with_overwrite(source, dest)
        add_sdt_screen_option(dest)
        shaders = find_gbuffers_terrain(dest)
        # Determine version from the terrain VSH itself, not from any file in the pack.
        # Some packs mix versions (e.g. terrain at 430, composites at 450), so scanning
        # the whole directory returns the wrong version.
        version = None
        for shader_path, shader_root, relative_to_root in shaders:
            v = GetVersion(shader_path)
            if v is not None:
                version = v
                break
        if version is None:
            # Terrain file has no #version: scan only the program/ folder (avoids
            # compute/composite shaders that may declare a different version).
            program_dir = os.path.join(dest, "shaders", "program")
            version = GetVersion(program_dir) if os.path.isdir(program_dir) else GetVersion(dest)
        print(version)
        if version is not None and version >= 450:
            copySdtToShaders(dest, True)
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

    finally:
        # nettoyage du dossier temporaire d'extraction, même en cas d'erreur
        if tmp_extract:
            shutil.rmtree(tmp_extract, ignore_errors=True)
def add_sdt_screen_option(pack_dir):
    """Ajoute TEXTURE_SYNTHESIS à l'écran principal de shaders.properties.
    Si le pack n'a pas de shaders.properties, ne fait rien (option auto-affichée)."""
    sp = os.path.join(pack_dir, "shaders", "shaders.properties")
    if not os.path.isfile(sp):
        return                                   # pas d'écrans curés -> rien à faire
    with open(sp, encoding="utf-8") as f:
        content = f.read()
    if "TEXTURE_SYNTHESIS" in content:
        return                                   # déjà ajouté
    # ajoute l'option à la fin de la 1re ligne "screen=" (l'écran principal)
    new, n = re.subn(r"(?m)^(\s*screen\s*=.*)$",
                    r"\1 TEXTURE_SYNTHESIS", content, count=1)
    if n:
        with open(sp, "w", encoding="utf-8") as f:
            f.write(new)


if __name__ == "__main__":
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
    else:
        file_path = input("Enter the shader root directory path: ")
    inject_sdt(file_path)