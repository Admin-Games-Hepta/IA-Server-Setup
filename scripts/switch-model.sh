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

# Parar todos os deployments
echo "⏹️  Parando todos os modelos..."
kubectl scale deployment -n ia-llm --replicas=0 --all
sleep 5

# Modo minimal só oferece Phi-2
if [ "$MODE" = "minimal" ] && [ "$MODEL" != "phi-2" ]; then
    echo "❌ Modo minimal suporta apenas: phi-2"
    exit 1
fi

# Iniciar modelo selecionado
case $MODEL in
    "phi-2")
        echo "🚀 Iniciando Phi-2-1B..."
        kubectl scale deployment -n ia-llm --replicas=1 phi-2-deployment
        ;;
    "codellama")
        if [ "$MODE" = "minimal" ]; then
            echo "❌ CodeLlama não disponível em modo minimal"
            exit 1
        fi
        echo "🚀 Iniciando CodeLlama-7B..."
        kubectl scale deployment -n ia-llm --replicas=1 codellama-7b-deployment
        ;;
    "mistral")
        if [ "$MODE" = "minimal" ]; then
            echo "❌ Mistral não disponível em modo minimal"
            exit 1
        fi
        echo "🚀 Iniciando Mistral-7B..."
        kubectl scale deployment -n ia-llm --replicas=1 mistral-7b-deployment
        ;;
    "deepseek")
        if [ "$MODE" = "minimal" ]; then
            echo "❌ DeepSeek não disponível em modo minimal"
            exit 1
        fi
        echo "🚀 Iniciando DeepSeek-V3..."
        kubectl scale deployment -n ia-llm --replicas=1 deepseek-v3-deployment
        ;;
    *)
        echo "❌ Modelo inválido: $MODEL"
        echo "💡 Opções: phi-2, codellama, mistral, deepseek"
        exit 1
        ;;
esac

echo "⏳ Aguardando inicialização..."
sleep 10
echo "✅ Modelo $MODEL ativo na porta 8000!"