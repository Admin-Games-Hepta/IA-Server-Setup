#!/bin/bash
# Script: switch-model.sh
# Descrição: Alterna entre modelos (compatível com modo minimal)

set -e

MODEL=$1
MODE=${2:-"normal"}  # Padrão: modo normal

if [ -z "$MODEL" ]; then
    echo "⚠️  Uso: ./switch-model.sh [modelo] [modo]"
    echo "💡 Modelos: phi-2, codellama, mistral, deepseek"
    echo "💡 Modos: normal, minimal"
    exit 1
fi

echo "🔄 Alternando para modelo: $MODEL (modo: $MODE)"

# Validação para modo minimal
if [ "$MODE" = "minimal" ] && [ "$MODEL" != "phi-2" ]; then
    echo "❌ Modo minimal suporta apenas: phi-2"
    exit 1
fi

# Parar todos os deployments e iniciar o novo.
echo "⏹️  Parando todos os modelos..."
kubectl scale deployment -n ia-llm --replicas=0 --all
sleep 5

# Iniciar modelo selecionado
case $MODEL in
    "phi-2")
        echo "🚀 Iniciando Phi-2..."
        kubectl scale deployment -n ia-llm --replicas=1 phi-2-deployment
        ;;
    "codellama")
        echo "🚀 Iniciando CodeLlama-7B..."
        kubectl scale deployment -n ia-llm --replicas=1 codellama-7b-deployment
        ;;
    "mistral")
        echo "🚀 Iniciando Mistral-7B..."
        kubectl scale deployment -n ia-llm --replicas=1 mistral-7b-deployment
        ;;
    "deepseek")
        echo "🚀 Iniciando DeepSeek-V3..."
        kubectl scale deployment -n ia-llm --replicas=1 deepseek-v3-deployment
        ;;
    *)
        echo "❌ Modelo inválido: $MODEL"
        exit 1
        ;;
esac

echo "✅ Modelo $MODEL iniciado com sucesso!"