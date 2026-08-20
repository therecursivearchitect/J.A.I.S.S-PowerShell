import torch
import torch.nn.functional as F
import sys
import os

# Include micro_kernel in path
sys.path.append(r"C:\J.A.I.S.S\micro_kernel")
from tokenizer import MicroTokenizer
from model import MicroLLMCore

def start_interactive():
    tokenizer = MicroTokenizer()
    model = MicroLLMCore(vocab_size=tokenizer.vocab_size)
    weight_path = r"C:\J.A.I.S.S\weights\micro_llm_core.pt"
    
    if not os.path.exists(weight_path):
        print("[J.A.I.S.S Error] Model weights not found. Please run training first.")
        return

    model.load_state_dict(torch.load(weight_path, weights_only=True))
    model.eval()
    
    print("==================================================")
    print("  J.A.I.S.S Micro-Kernel Interactive Console")
    print("==================================================")
    print("Type 'exit' or 'quit' to exit console.\n")
    
    while True:
        try:
            prompt = input("J.A.I.S.S > ")
            if prompt.lower().strip() in ['exit', 'quit']:
                break
            if not prompt.strip():
                continue
                
            input_ids = torch.tensor(tokenizer.encode(prompt), dtype=torch.long).unsqueeze(0)
            with torch.no_grad():
                for _ in range(80):
                    logits = model(input_ids)
                    probs = F.softmax(logits[:, -1, :], dim=-1)
                    next_token = torch.argmax(probs, dim=-1, keepdim=True)
                    input_ids = torch.cat([input_ids, next_token], dim=1)
                    
                    if next_token.item() == tokenizer.encode(".")[-1] and input_ids.shape[1] > len(prompt) + 15:
                        break
            
            output_text = tokenizer.decode(input_ids[0].tolist())
            print(f"\n[Response]: {output_text}\n")
        except KeyboardInterrupt:
            print("\nExiting console...")
            break

if __name__ == "__main__":
    start_interactive()
