#!/bin/bash

echo "Aplicando configurações CPU Minimal..."
cd "$(dirname "$0")/../cpu-minimal"

echo "Criando namespace..."
kubectl apply -f namespace-ia-llm.yaml

echo "Criando volumes persistentes..."
kubectl apply -f postgres-pvc.yaml
kubectl apply -f ollama-pvc.yaml

echo "Criando PostgreSQL..."
kubectl apply -f postgres-service.yaml
kubectl apply -f postgres.yaml

echo "Aguardando PostgreSQL iniciar..."
sleep 10

echo "Criando Ollama..."
kubectl apply -f ollama-service.yaml
kubectl apply -f ollama.yaml

echo "Criando Open WebUI..."
kubectl apply -f open-webui-service.yaml
kubectl apply -f open-webui.yaml

echo "Implantação CPU Minimal concluída!"
echo "Open WebUI disponível em: http://seu-servidor:30081"
echo "Ollama API disponível em: http://seu-servidor:30080"
