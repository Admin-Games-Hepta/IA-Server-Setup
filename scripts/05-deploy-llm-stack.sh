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

# Deploy dos modelos conforme o modo
if [ "$MODE" = "minimal" ]; then
    echo "🐢 Modo MINIMAL selecionado"
    echo "🤖 Configurando phi-2..."
    kubectl apply -f kubernetes/phi-2.yaml
    kubectl scale deployment -n ia-llm --replicas=0 phi-2-deployment
else
    echo "⚡ Modo NORMAL selecionado"
    echo "🤖 Configurando CodeLlama-7B..."
    kubectl apply -f kubernetes/codellama-7b.yaml
    kubectl scale deployment -n ia-llm --replicas=0 codellama-7b-deployment

    echo "🤖 Configurando DeepSeek-V3..."
    kubectl apply -f kubernetes/deepseek-v3.yaml
    kubectl scale deployment -n ia-llm --replicas=0 deepseek-v3-deployment

    echo "🤖 Configurando Mistral-7B..."
    kubectl apply -f kubernetes/mistral.yaml
    kubectl scale deployment -n ia-llm --replicas=0 mistral-7b-deployment

    echo "🤖 Configurando phi-2..."
    kubectl apply -f kubernetes/phi-2.yaml
    kubectl scale deployment -n ia-llm --replicas=0 phi-2-deployment
fi

# Deploy do Chatbot UI
echo "🌐 Deployando Chatbot UI..."
kubectl apply -f kubernetes/chatbot-ui.yaml

echo "✅ Deploy completo realizado!"
echo "💡 Use './switch-model.sh [modelo] [modo]' para alternar entre modelos"

if [ "$MODE" = "minimal" ]; then
    echo "🐢 Modo MINIMAL: Apenas phi-2 disponível"
    echo "🚀 Para ativar: ./switch-model.sh phi-2 minimal"
else
    echo "⚡ Modo NORMAL: Todos os modelos disponíveis"
    echo "🚀 Para ativar: ./switch-model.sh [phi-2|codellama|mistral|deepseek]"
fi

echo "📊 Verificando status..."
kubectl get pods -n ia-llm