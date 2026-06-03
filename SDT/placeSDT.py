import shutil
import os

def copy_folder_with_overwrite(src: str, dst: str):
    if os.path.exists(dst):
        shutil.rmtree(dst)  # Remove the destination folder if it exists
    shutil.copytree(src, dst)  # Copy the source folder to the destination

if __name__ == "__main__":
    source_path = "./sdt"
    dest_path = input("Enter destination folder path: ")
    dest_path += "/lib/sdt"
    copy_folder_with_overwrite(source_path, dest_path)