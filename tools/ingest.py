import os
import sys
import glob

# Enforce SAIHV root in Python module resolution path
JAISS_ROOT = r"C:\J.A.I.S.S"
if JAISS_ROOT not in sys.path:
    sys.path.insert(0, JAISS_ROOT)

import torch
import torch.nn as nn
import torch.optim as optim
from micro_kernel.tokenizer import CharacterTokenizer
from micro_kernel.model import MicroLLM

DATA_DIR = os.path.join(JAISS_ROOT, "data")
WEIGHTS_PATH = os.path.join(JAISS_ROOT, "weights", "micro_llm_core.pt")

def process_data_and_train():
    files = glob.glob(os.path.join(DATA_DIR, "*.txt"))
    raw_text = ""
    for fpath in files:
        with open(fpath, "r", encoding="utf-8") as f:
            raw_text += f.read() + "\n"

    print(f"[SAIHV Ingest] Loaded {len(raw_text)} total characters from {len(files)} corpus files.")
    
    # Dynamically build vocabulary from combined corpus + standard ASCII
    all_chars = set(raw_text).union(set([chr(i) for i in range(128)]))
    tokenizer = CharacterTokenizer(chars=list(all_chars))
    tokenizer.save(os.path.join(DATA_DIR, "vocab.json"))
    
    encoded = torch.tensor(tokenizer.encode(raw_text), dtype=torch.long)
    vocab_size = tokenizer.vocab_size
    print(f"[SAIHV Ingest] Dynamic Vocabulary Size: {vocab_size}")

    # Re-instantiate model with exact vocab_size
    model = MicroLLM(vocab_size=vocab_size, n_embd=64, n_head=4, n_layer=4, block_size=128)
    optimizer = optim.AdamW(model.parameters(), lr=1e-3)
    criterion = nn.CrossEntropyLoss()

    model.train()
    epochs = 150
    block_size = 128

    if len(encoded) <= block_size:
        print("[SAIHV Ingest Error] Corpus text too short for block size.")
        return

    for epoch in range(1, epochs + 1):
        ix = torch.randint(len(encoded) - block_size - 1, (16,))
        x = torch.stack([encoded[i:i+block_size] for i in ix])
        y = torch.stack([encoded[i+1:i+block_size+1] for i in ix])

        optimizer.zero_grad()
        logits = model(x)
        loss = criterion(logits.view(-1, vocab_size), y.view(-1))
        loss.backward()
        optimizer.step()

        if epoch % 30 == 0 or epoch == epochs:
            print(f"[Epoch {epoch}/{epochs}] Ingest Training Loss: {loss.item():.4f}")

    os.makedirs(os.path.dirname(WEIGHTS_PATH), exist_ok=True)
    torch.save(model.state_dict(), WEIGHTS_PATH)
    print(f"[SAIHV Ingest] Retrained weights saved successfully to {WEIGHTS_PATH}")

if __name__ == "__main__":
    process_data_and_train()
