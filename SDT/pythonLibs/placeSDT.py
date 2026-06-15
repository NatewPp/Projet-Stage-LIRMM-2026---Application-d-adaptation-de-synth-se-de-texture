import shutil
import os

def copy_folder_with_overwrite(src: str, dst: str):
    """
    PRECONDITION : src doit être un chemin valide vers un dossier existant, dst doit être un chemin valide vers un dossier (qui peut exister ou non).
    POSTCONDITION : le dossier src est copié vers dst, écrasant le contenu dest dst s'il existe déjà.
    """
    if os.path.exists(dst):
        shutil.rmtree(dst)  # Remove the destination folder if it exists
    shutil.copytree(src, dst)  # Copy the source folder to the destination

def copySdtToShaders(filepath: str):
    """
    Copie le dossier 'sdt' dans le sous-dossier 'lib/sdt' du shaderpack.
    Utilise 'shader_root' pour garantir la bonne destination.
    PRECONDITION : filepath doit être un chemin valide vers la racine d'un shaderpack.
    POSTCONDITION : le dossier 'sdt' est copié dans 'filepath/lib/sdt', écrasant l'ancien s'il existe.
    """
    script_dir = os.path.dirname(os.path.abspath(__file__))
    source_path = os.path.join(script_dir, "sdt")
    
    dest_path = filepath + "/shaders/lib/sdt"
    
    copy_folder_with_overwrite(source_path, dest_path)