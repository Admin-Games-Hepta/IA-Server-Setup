#!/bin/bash
# Script: 06-deploy-chatbot-ui.sh
# Descrição: Deploy específico do Chatbot UI

set -e

echo "🌐 Deployando Chatbot UI..."

# Aplicar deployment do Chatbot UI
kubectl apply -f kubernetes/chatbot-ui.yaml

echo "⏳ Aguardando inicialização..."
sleep 15

# Verificar status
kubectl get pods -n ia-llm -l app=chatbot-ui

echo "✅ Chatbot UI deployado!"
echo "🔗 Acesso: http://$(hostname -I | awk '{print $1}'):3000"