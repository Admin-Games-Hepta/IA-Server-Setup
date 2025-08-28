#!/bin/bash
# Script: 05-deploy-llm-stack.sh
# Descrição: Deploy completo da stack LLM no K3s com suporte a modo minimal

set -e

MODE=${1:-"normal"}  # Padrão: modo normal

echo "🚀 Iniciando deploy da stack LLM em modo: $MODE"

# Configurar namespace
echo "📁 Criando namespace..."
kubectl apply -f kubernetes/namespace.yaml

# Configurar PVC
echo "💾 Criando volume persistente..."
kubectl apply -f kubernetes/pvc.yaml

# Aguardar PVC estar pronto
echo "⏳ Aguardando PVC..."
sleep 10

# Service principal
echo "🔌 Configurando service..."
kubectl apply -f kubernetes/service.yaml

# Aplicar todos os manifestos de modelos, mas sem réplicas
# para evitar múltiplas instâncias
echo "📦 Configurando todos os modelos (replicas=0)..."
kubectl apply -f kubernetes/phi-2.yaml
kubectl apply -f kubernetes/codellama-7b.yaml
kubectl apply -f kubernetes/deepseek-v3.yaml
kubectl apply -f kubernetes/mistral.yaml
kubectl scale deployment -n ia-llm --replicas=0 --all

# Iniciar o modelo padrão para o modo minimal
if [ "$MODE" = "minimal" ]; then
    echo "🐢 Modo MINIMAL selecionado. Iniciando phi-2 como padrão..."
    kubectl scale deployment -n ia-llm --replicas=1 phi-2-deployment
fi

# Deploy do Chatbot UI
echo "🌐 Deployando Chatbot UI..."
kubectl apply -f kubernetes/chatbot-ui.yaml

echo "✅ Deploy completo realizado!"
echo "💡 Use './switch-model.sh [modelo]' para alternar entre modelos"