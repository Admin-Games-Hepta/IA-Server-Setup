#!/bin/bash
# Script: switch-model.sh
# Descrição: Alterna entre modelos LLM (apenas um ativo por vez)

set -e

MODEL=$1

if [ -z "$MODEL" ]; then
    echo "⚠️  Uso: ./switch-model.sh [codellama|deepseek|mistral]"
    exit 1
fi

echo "🔄 Alternando para modelo: $MODEL"

# Parar todos os deployments
echo "⏹️  Parando todos os modelos..."
kubectl scale deployment -n ia-llm --replicas=0 --all

# Aguardar parada completa
sleep 10

# Iniciar o modelo selecionado
case $MODEL in
    "codellama")
        echo "🚀 Iniciando CodeLlama-7B..."
        kubectl scale deployment -n ia-llm --replicas=1 codellama-7b-deployment
        ;;
    "deepseek")
        echo "🚀 Iniciando DeepSeek-V3..."
        kubectl scale deployment -n ia-llm --replicas=1 deepseek-v3-deployment
        ;;
    "mistral")
        echo "🚀 Iniciando Mistral-7B..."
        kubectl scale deployment -n ia-llm --replicas=1 mistral-7b-deployment
        ;;
    *)
        echo "❌ Modelo inválido: $MODEL"
        echo "💡 Opções: codellama, deepseek, mistral"
        exit 1
        ;;
esac

echo "⏳ Aguardando inicialização..."
sleep 15

echo "✅ Modelo $MODEL ativo na porta 8000!"
echo "🌐 Chatbot UI: http://$(hostname -I | awk '{print $1}'):30080"