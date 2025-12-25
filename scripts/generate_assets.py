import os
import json
import docx
import re

ROOT_DIR = r"E:\Catholic-Mezmur\qumsnatat"
OUTPUT_FILE = r"E:\Catholic-Mezmur\assets\lyrics.json"

# Basic Tigrinya to English/Phonetic mapping (Partial/Common chars)
# This helps search function work for English queries
TIGRINYA_MAP = {
    'ሀ': 'he', 'ሁ': 'hu', 'ሂ': 'hi', 'ሃ': 'ha', 'ሄ': 'he', 'ህ': 'h', 'ሆ': 'ho',
    'ለ': 'le', 'ሉ': 'lu', 'ሊ': 'li', 'ላ': 'la', 'ሌ': 'le', 'ል': 'l', 'ሎ': 'lo',
    'ሐ': 'he', 'ሑ': 'hu', 'ሒ': 'hi', 'ሓ': 'ha', 'ሔ': 'he', 'ሕ': 'h', 'ሖ': 'ho',
    'መ': 'me', 'ሙ': 'mu', 'ሚ': 'mi', 'ማ': 'ma', 'ሜ': 'me', 'ም': 'm', 'ሞ': 'mo',
    'ሠ': 'se', 'ሡ': 'su', 'ሢ': 'si', 'ሣ': 'sa', 'ሤ': 'se', 'ሥ': 's', 'ሦ': 'so',
    'ረ': 're', 'ሩ': 'ru', 'ሪ': 'ri', 'ራ': 'ra', 'ሬ': 're', 'ር': 'r', 'ሮ': 'ro',
    'ሰ': 'se', 'ሱ': 'su', 'ሲ': 'si', 'ሳ': 'sa', 'ሴ': 'se', 'ስ': 's', 'ሶ': 'so',
    'ሸ': 'she', 'ሹ': 'shu', 'ሺ': 'shi', 'ሻ': 'sha', 'ሼ': 'she', 'ሽ': 'sh', 'ሾ': 'sho',
    'ቀ': 'qe', 'ቁ': 'qu', 'ቂ': 'qi', 'ቃ': 'qa', 'ቄ': 'qe', 'ቅ': 'q', 'ቆ': 'qo',
    'በ': 'be', 'ቡ': 'bu', 'ቢ': 'bi', 'ባ': 'ba', 'ቤ': 'be', 'ብ': 'b', 'ቦ': 'bo',
    'ተ': 'te', 'ቱ': 'tu', 'ቲ': 'ti', 'ታ': 'ta', 'ቴ': 'te', 'ት': 't', 'ቶ': 'to',
    'ቸ': 'che', 'ቹ': 'chu', 'ቺ': 'chi', 'ቻ': 'cha', 'ቼ': 'che', 'ች': 'ch', 'ቾ': 'cho',
    'ነ': 'ne', 'ኑ': 'nu', 'ኒ': 'ni', 'ና': 'na', 'ኔ': 'ne', 'ን': 'n', 'ኖ': 'no',
    'ኘ': 'gne', 'ኙ': 'gnu', 'ኚ': 'gni', 'ኛ': 'gna', 'ኜ': 'gne', 'ኝ': 'gn', 'ኞ': 'gno',
    'አ': 'a', 'ኡ': 'u', 'ኢ': 'i', 'ኣ': 'a', 'ኤ': 'e', 'እ': 'e', 'ኦ': 'o',
    'ከ': 'ke', 'ኩ': 'ku', 'ኪ': 'ki', 'ካ': 'ka', 'ኬ': 'ke', 'ክ': 'k', 'ኮ': 'ko',
    'ኸ': 'Ke', 'ኹ': 'Ku', 'ኺ': 'Ki', 'ኻ': 'Ka', 'ኼ': 'Ke', 'ኽ': 'K', 'ኾ': 'Ko',
    'ወ': 'we', 'ዉ': 'wu', 'ዊ': 'wi', 'ዋ': 'wa', 'ዌ': 'we', 'ው': 'w', 'ዎ': 'wo',
    'ዐ': 'a', 'ዑ': 'u', 'ዒ': 'i', 'ዓ': 'a', 'ዔ': 'e', 'ዕ': 'e', 'ዖ': 'o',
    'ዘ': 'ze', 'ዙ': 'zu', 'ዚ': 'zi', 'ዛ': 'za', 'ዜ': 'ze', 'ዝ': 'z', 'ዞ': 'zo',
    'ዠ': 'zhe', 'ዡ': 'zhu', 'ዢ': 'zhi', 'ዣ': 'zha', 'ዤ': 'zhe', 'ዥ': 'zh', 'ዦ': 'zho',
    'የ': 'ye', 'ዩ': 'yu', 'ዪ': 'yi', 'ያ': 'ya', 'ዬ': 'ye', 'ይ': 'y', 'ዮ': 'yo',
    'ደ': 'de', 'ዱ': 'du', 'ዲ': 'di', 'ዳ': 'da', 'ዴ': 'de', 'ድ': 'd', 'ዶ': 'do',
    'ጀ': 'je', 'ጁ': 'ju', 'ጂ': 'ji', 'ጃ': 'ja', 'ጄ': 'je', 'ጅ': 'j', 'ጆ': 'jo',
    'ገ': 'ge', 'ጉ': 'gu', 'ጊ': 'gi', 'ጋ': 'ga', 'ጌ': 'ge', 'ግ': 'g', 'ጎ': 'go',
    'ጠ': 'te', 'ጡ': 'tu', 'ጢ': 'ti', 'ጣ': 'ta', 'ጤ': 'te', 'ጥ': 't', 'ጦ': 'to',
    'ጨ': 'che', 'ጩ': 'chu', 'ጪ': 'chi', 'ጫ': 'cha', 'ጬ': 'che', 'ጭ': 'ch', 'ጮ': 'cho',
    'ጰ': 'pe', 'ጱ': 'pu', 'ጲ': 'pi', 'ጳ': 'pa', 'ጴ': 'pe', 'ጵ': 'p', 'ጶ': 'po',
    'ጸ': 'tse', 'ጹ': 'tsu', 'ጺ': 'tsi', 'ጻ': 'tsa', 'ጼ': 'tse', 'ጽ': 'ts', 'ጾ': 'tso',
    'ፈ': 'fe', 'ፉ': 'fu', 'ፊ': 'fi', 'ፋ': 'fa', 'ፌ': 'fe', 'ፍ': 'f', 'ፎ': 'fo',
    'ፐ': 'pe', 'ፑ': 'pu', 'ፒ': 'pi', 'ፓ': 'pa', 'ፔ': 'pe', 'ፕ': 'p', 'ፖ': 'po',
}

def transliterate(text):
    result = []
    for char in text:
        result.append(TIGRINYA_MAP.get(char, char))
    return "".join(result)

def read_docx(file_path):
    try:
        doc = docx.Document(file_path)
        full_text = []
        for para in doc.paragraphs:
            txt = para.text.strip()
            if txt:
                full_text.append(txt)
        return "\n".join(full_text)
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return ""

import win32com.client as win32

def read_doc_via_word(file_path):
    try:
        word = win32.Dispatch("Word.Application")
        word.Visible = False
        # Open the file
        doc = word.Documents.Open(file_path)
        # Read content
        text = doc.Content.Text
        # Close without saving
        doc.Close(False)
        # We try not to quit Word Application here if we want speed, but it's safer to not leave it hanging if we loop
        # For bulk processing, it's better to open Word ONCE. Refactoring below.
        return text.strip()
    except Exception as e:
        print(f"Error reading .doc {file_path}: {e}")
        return ""

def generate_json():
    print(f"Scanning {ROOT_DIR} ...")
    songs_data = []
    song_id = 1

    if not os.path.exists(ROOT_DIR):
        print(f"Directory {ROOT_DIR} does not exist.")
        return

    # Initialize Word once for performance and safety
    word_app = None
    try:
        word_app = win32.Dispatch("Word.Application")
        word_app.Visible = False
    except Exception as e:
        print(f"Could not initialize MS Word: {e}. .doc files will be skipped.")

    try:
        # os.walk yields (dirpath, dirnames, filenames)
        for dirpath, _, filenames in os.walk(ROOT_DIR):
            # Calculate Category based on path relative to ROOT
            rel_path = os.path.relpath(dirpath, ROOT_DIR)
            
            if rel_path == ".":
                category = "Uncategorized"
            else:
                category = rel_path

            for filename in sorted(filenames):
                if filename.startswith("~$"): continue

                file_path = os.path.join(dirpath, filename)
                title = os.path.splitext(filename)[0]
                lyrics = ""

                if filename.lower().endswith(".docx"):
                    lyrics = read_docx(file_path)
                elif filename.lower().endswith(".doc"):
                    if word_app:
                        try:
                            doc = word_app.Documents.Open(file_path)
                            lyrics = doc.Content.Text
                            doc.Close(False)
                        except Exception as e:
                            print(f"Failed to read .doc {filename}: {e}")

                if lyrics and lyrics.strip():
                    # Clean up weird chars sometimes found in Word docs (like \r, \x07, etc)
                    cleaned_lyrics = lyrics.replace('\r', '\n').replace('\x0b', '\n').strip()
                    
                    songs_data.append({
                        "title": title,
                        "category": category,
                        "id": song_id,
                        "lyrics": cleaned_lyrics,
                        "translatedTitle": transliterate(title)
                    })
                    song_id += 1
    finally:
        if word_app:
            word_app.Quit()

    print(f"Found {len(songs_data)} songs.")

    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(songs_data, f, ensure_ascii=False, indent=4)
    
    print(f"Successfully saved to {OUTPUT_FILE}")

if __name__ == "__main__":
    generate_json()
