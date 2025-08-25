#!/bin/bash
# Script: 04-download-models.sh
# Descrição: Baixa modelos LLM para o volume persistente

set -e

MODELS_DIR="/opt/K3s/models"
mkdir -p $MODELS_DIR

echo "📥 Baixando modelos LLM..."

# CodeLlama 7B
echo "⬇️  Baixando CodeLlama-7B..."
wget -O $MODELS_DIR/codellama-7b.Q4_K_M.gguf https://huggingface.co/TheBloke/CodeLlama-7B-GGUF/resolve/main/codellama-7b.Q4_K_M.gguf

# Mistral 7B
echo "⬇️  Baixando Mistral-7B..."
wget -O $MODELS_DIR/mistral-7b.Q4_K_M.gguf https://huggingface.co/TheBloke/Mistral-7B-v0.1-GGUF/resolve/main/mistral-7b-v0.1.Q4_K_M.gguf

# DeepSeek-V3 (exemplo - verificar URL atual)
echo "⬇️  Baixando DeepSeek-V3..."
wget -O $MODELS_DIR/deepseek-v3.Q5_K_M.gguf https://huggingface.co/TheBloke/deepseek-v3-GGUF/resolve/main/deepseek-v3.Q5_K_M.gguf

echo "✅ Modelos baixados com sucesso!"
echo "📊 Conteúdo do diretório:"
ls -lh $MODELS_DIR