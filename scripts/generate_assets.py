import os
import json
import docx

ROOT_DIR = r"E:\Catholic-Mezmur\qumsnatat"
OUTPUT_FILE = r"E:\Catholic-Mezmur\assets\mezmur.json"

def read_docx(file_path):
    try:
        doc = docx.Document(file_path)
        full_text = []
        for para in doc.paragraphs:
            if para.text.strip():
                full_text.append(para.text.strip())
        return "\n".join(full_text)
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return ""

def generate_json():
    data = []
    
    if not os.path.exists(ROOT_DIR):
        print(f"Directory {ROOT_DIR} does not exist.")
        return

    # Iterate over directories in ROOT_DIR
    for folder_name in os.listdir(ROOT_DIR):
        folder_path = os.path.join(ROOT_DIR, folder_name)
        
        if os.path.isdir(folder_path):
            print(f"Processing {folder_name}...")
            
            songs = []
            
            # Iterate over files in the folder
            for filename in os.listdir(folder_path):
                if filename.endswith(".docx") and not filename.startswith("~$"):
                    file_path = os.path.join(folder_path, filename)
                    title = os.path.splitext(filename)[0]
                    lyrics = read_docx(file_path)
                    
                    if lyrics:
                        songs.append({
                            "title": title,
                            "lyrics": lyrics
                        })
            
            if songs:
                # Structure matching our App's needs
                # ContainerCard (Category) -> List<Album> -> List<Song>
                # For now, we create one Album per Category containing all found songs
                data.append({
                    "category": folder_name,
                    "image": "assets/icon.jpg", # Default placeholder
                    "albums": [
                        {
                            "title": "General",
                            "songs": songs
                        }
                    ]
                })

    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"Successfully generated {OUTPUT_FILE} with {len(data)} categories.")

if __name__ == "__main__":
    generate_json()
