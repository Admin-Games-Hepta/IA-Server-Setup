#!/bin/bash
# Script: 04-download-models.sh
# Descrição: Baixa modelos LLM conforme o modo

set -e

MODE=${1:-"normal"}
MODELS_DIR="/opt/models"

echo "📥 Baixando modelos para modo: $MODE"

# As permissões já foram configuradas no 01-install-basics.sh (recomendado)
# Se estiver rodando este script isoladamente, use as linhas abaixo:
# sudo mkdir -p $MODELS_DIR
# sudo chown $USER:$USER $MODELS_DIR
# sudo chmod 755 $MODELS_DIR

if [ "$MODE" = "minimal" ]; then
    echo "⬇️  Baixando phi-2 (modo minimal)..."
    wget -c -O $MODELS_DIR/phi-2.Q4_K_M.gguf \
        https://huggingface.co/TheBloke/phi-2-GGUF/resolve/main/phi-2.Q4_K_M.gguf
else
    echo "⬇️  Baixando CodeLlama-7B..."
    wget -c -O $MODELS_DIR/codellama-7b.Q4_K_M.gguf \
        https://huggingface.co/TheBloke/CodeLlama-7B-GGUF/resolve/main/codellama-7b.Q4_K_M.gguf

    echo "⬇️  Baixando Mistral-7B..."
    wget -c -O $MODELS_DIR/mistral-7b.Q4_K_M.gguf \
        https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF/resolve/main/mistral-7b-instruct-v0.2.Q4_K_M.gguf

    echo "⬇️  Baixando DeepSeek-V3..."
    wget -c -O $MODELS_DIR/deepseek-v3.Q5_K_M.gguf \
        https://huggingface.co/TheBloke/deepseek-v3-GGUF/resolve/main/deepseek-v3.Q5_K_M.gguf
fi

echo "✅ Download de modelos concluído!"