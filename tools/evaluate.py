import os
import sys

JAISS_ROOT = r"C:\J.A.I.S.S"
if JAISS_ROOT not in sys.path:
    sys.path.insert(0, JAISS_ROOT)

import torch
from micro_kernel.tokenizer import CharacterTokenizer
from micro_kernel.model import MicroLLM

DATA_DIR = os.path.join(JAISS_ROOT, "data")
WEIGHTS_PATH = os.path.join(JAISS_ROOT, "weights", "micro_llm_core.pt")
VOCAB_PATH = os.path.join(DATA_DIR, "vocab.json")

def generate_sample(prompt="Language", max_new_tokens=100, temperature=0.8):
    if not os.path.exists(VOCAB_PATH) or not os.path.exists(WEIGHTS_PATH):
        print("[SAIHV Eval Error] Missing vocabulary or model weights file.")
        return

    tokenizer = CharacterTokenizer.load(VOCAB_PATH)
    vocab_size = tokenizer.vocab_size

    model = MicroLLM(vocab_size=vocab_size, n_embd=64, n_head=4, n_layer=4, block_size=128)
    
    # Load state dict safely to avoid PyTorch unpickling warnings
    state_dict = torch.load(WEIGHTS_PATH, weights_only=True)
    model.load_state_dict(state_dict)
    model.eval()

    context = torch.tensor(tokenizer.encode(prompt), dtype=torch.long).unsqueeze(0)
    
    with torch.no_grad():
        for _ in range(max_new_tokens):
            cond_context = context[:, -128:]
            logits = model(cond_context)
            logits = logits[:, -1, :] / max(temperature, 1e-5)
            probs = torch.softmax(logits, dim=-1)
            next_token = torch.multinomial(probs, num_samples=1)
            context = torch.cat((context, next_token), dim=1)

    generated_text = tokenizer.decode(context[0].tolist())
    print("\n--- [SAIHV LLM Inference Result] ---")
    print(generated_text)
    print("------------------------------------\n")

if __name__ == "__main__":
    generate_sample()
