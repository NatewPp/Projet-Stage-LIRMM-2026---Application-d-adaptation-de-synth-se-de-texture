import os
import sys

def list_files_in_directory(directory_path: str) -> list:
    """
    List all files in a given directory.
    
    Args:
        directory_path: Path to the directory
        
    Returns:
        List of filenames in the directory
    """
    if not os.path.isdir(directory_path):
        print(f"Error: '{directory_path}' is not a valid directory")
        return []
    
    try:
        lsresult = os.listdir(directory_path)
        # Filter only files (not directories)
        files = []
        directories = []
        for item in lsresult:
            item_path = os.path.join(directory_path, item)
            if os.path.isfile(item_path):
                files.append(item)
            elif os.path.isdir(item_path):
                directories.append(item)
        found = False
        for f in files:
            if "gbuffers_terrain" in f.lower():
                if not found:
                    print(f"Found files containing 'gbuffers_terrain' in '{directory_path}':")
                    found = True
                if ".fsh" in f.lower():
                    search_for_includes(os.path.join(directory_path, f))
        for d in directories:
            list_files_in_directory(os.path.join(directory_path, d))
        return files
    except Exception as e:
        print(f"Error reading directory: {e}")
        return []

def search_for_includes(file_path: str) -> list:

    try:
        with open(file_path, 'r') as f:
            for line in f:
                line = line.strip()
                if line.startswith("#include"):
                    included = remove_prefix(line, "#include ").strip()
                    included.lstrip('"')
                    print(f"Found include in '{file_path}': {included}")
    except Exception as e:
        print(f"Error reading file '{file_path}': {e}")

def remove_prefix(text: str, prefix: str):
    if text.startswith(prefix):
        return text[len(prefix):]
    return text

# Main program
if __name__ == "__main__":
    # Get directory path from command line argument or user input
    if len(sys.argv) > 1:
        dir_path = sys.argv[1]
    else:
        dir_path = input("Enter the directory path: ")
    
    # List files
    files = list_files_in_directory(dir_path)
    
    