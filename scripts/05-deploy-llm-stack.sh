#!/bin/bash
# Script: 05-deploy-llm-stack.sh
# Descrição: Deploy completo da stack LLM no K3s

set -e

echo "🚀 Iniciando deploy da stack LLM..."

# Configurar namespace
echo "📁 Criando namespace..."
kubectl apply -f kubernetes/namespace.yaml

# Configurar PVC
echo "💾 Criando volume persistente..."
kubectl apply -f kubernetes/pvc.yaml

# Aguardar PVC estar pronto
echo "⏳ Aguardando PVC..."
sleep 10

# Service principal (porta 8000 fixa)
echo "🔌 Configurando service..."
kubectl apply -f kubernetes/service.yaml

# Deploy dos modelos (todos com replicas: 0 inicialmente)
echo "🤖 Configurando CodeLlama-7B..."
kubectl apply -f kubernetes/codellama-7b.yaml
kubectl scale deployment -n ia-llm --replicas=0 codellama-7b-deployment

echo "🤖 Configurando DeepSeek-V3..."
kubectl apply -f kubernetes/deepseek-v3.yaml
kubectl scale deployment -n ia-llm --replicas=0 deepseek-v3-deployment

echo "🤖 Configurando Mistral-7B..."
kubectl apply -f kubernetes/mistral.yaml
kubectl scale deployment -n ia-llm --replicas=0 mistral-7b-deployment

# Deploy do Chatbot UI
echo "🌐 Deployando Chatbot UI..."
kubectl apply -f kubernetes/chatbot-ui.yaml

echo "✅ Deploy completo realizado!"
echo "💡 Use './switch-model.sh [modelo]' para alternar entre modelos"
echo "📊 Verificando status..."
kubectl get pods -n ia-llm