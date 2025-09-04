#!/bin/bash

echo "Removendo todos os recursos do namespace ia-llm..."
kubectl delete namespace ia-llm --ignore-not-found=true

echo "Removendo persistent volumes..."
kubectl delete pv llm-models-pv --ignore-not-found=true
kubectl delete pv postgres-pv --ignore-not-found=true

echo "Limpando diretórios de dados..."
sudo rm -rf /opt/llm-models/*
sudo rm -rf /opt/postgres-data/*

echo "Limpeza concluída!"
