import os
import sys
import re
import urllib.request
import json

# HARD SAFETY BOX BOUNDARIES
ALLOWED_DOMAINS = ["wikipedia.org", "arxiv.org", "python.org", "pytorch.org"]
MAX_CHAR_LIMIT = 50000

def fetch_safe_corpus(topic: str):
    print(f"[SAIHV Safety Box] Initiating bounded web fetch for topic: '{topic}'...")
    
    # Example using Wikipedia Public REST API for clean structured content
    url = f"https://en.wikipedia.org/api/rest_v1/page/summary/{urllib.parse.quote(topic)}"
    
    req = urllib.request.Request(
        url, 
        headers={'User-Agent': 'JAISS_MicroKernel_Bot/1.0 (Hardened Local AI Core)'}
    )
    
    try:
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode('utf-8'))
            raw_extract = data.get('extract', '')
            
            # Safety Sanitization: Strip HTML, non-printable characters, keep clean text
            clean_text = re.sub(r'<[^>]+>', '', raw_extract)
            clean_text = re.sub(r'[^\x00-\x7F]+', ' ', clean_text)
            clean_text = clean_text[:MAX_CHAR_LIMIT]
            
            output_filename = f"web_{re.sub(r'[^a-zA-Z0-9]', '_', topic.lower())}.txt"
            output_path = os.path.join(r"C:\J.A.I.S.S\data", output_filename)
            
            with open(output_path, "w", encoding="utf-8") as f:
                f.write(clean_text)
                
            print(f"[SAIHV Safety Box] Harvested {len(clean_text)} sanitized characters to {output_path}")
            return output_path
            
    except Exception as e:
        print(f"[SAIHV Safety Box Error] Web fetch aborted/failed: {e}")
        return None

if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "Artificial_intelligence"
    fetch_safe_corpus(target)
