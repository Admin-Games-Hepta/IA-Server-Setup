#!/bin/bash
# Script: 04-download-models.sh
# Descrição: Baixa modelos LLM conforme o modo

set -e

MODE=${1:-"normal"}
MODELS_DIR="/opt/models"

echo "📥 Baixando modelos para modo: $MODE"

sudo mkdir -p $MODELS_DIR
sudo chown $USER:$USER $MODELS_DIR
sudo chmod 755 $MODELS_DIR

if [ "$MODE" = "minimal" ]; then
    echo "⬇️  Baixando TinyLlama-1B (modo minimal)..."
    wget -c -O $MODELS_DIR/tinyllama-1b.Q4_K_M.gguf \
        https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf
else
    echo "⬇️  Baixando CodeLlama-7B..."
    wget -c -O $MODELS_DIR/codellama-7b.Q4_K_M.gguf \
        https://huggingface.co/TheBloke/CodeLlama-7B-GGUF/resolve/main/codellama-7b.Q4_K_M.gguf

    echo "⬇️  Baixando Mistral-7B..."
    wget -c -O $MODELS_DIR/mistral-7b.Q4_K_M.gguf \
        https://huggingface.co/TheBloke/Mistral-7B-v0.1-GGUF/resolve/main/mistral-7b-v0.1.Q4_K_M.gguf

    echo "⬇️  Baixando TinyLlama-1B..."
    wget -c -O $MODELS_DIR/tinyllama-1b.Q4_K_M.gguf \
        https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf
fi

echo "✅ Download concluído!"
ls -lh $MODELS_DIR