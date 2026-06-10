import shutil
import os

def copy_folder_with_overwrite(src: str, dst: str):
    if os.path.exists(dst):
        shutil.rmtree(dst)  # Remove the destination folder if it exists
    shutil.copytree(src, dst)  # Copy the source folder to the destination

def copySdtToShaders(filepath: str):
    """
    Copie le dossier 'sdt' dans le sous-dossier 'lib/sdt' du shaderpack.
    Utilise 'shader_root' pour garantir la bonne destination.
    """
    script_dir = os.path.dirname(os.path.abspath(__file__))
    source_path = os.path.join(script_dir, "sdt")
    
    dest_path = filepath + "/shaders/lib/sdt"
    
    copy_folder_with_overwrite(source_path, dest_path)