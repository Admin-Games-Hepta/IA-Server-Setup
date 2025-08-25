#!/bin/bash
# Script: 03-install-k3s.sh
# Descrição: Instala K3s com suporte a GPU

set -e

echo "📦 Instalando K3s..."
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.33.3+k3s1" sh -s - \
    --write-kubeconfig-mode 644 \
    --disable traefik \
    --disable servicelb

echo "🔄 Configurando kubectl..."
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config

echo "🔧 Configurando NVIDIA Device Plugin..."
sudo k3s kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.14.5/nvidia-device-plugin.yml

echo "✅ K3s instalado com sucesso!"
echo "🔍 Verificando nodes..."
sudo k3s kubectl get nodes
echo "🔍 Verificando GPUs..."
sudo k3s kubectl get nodes -o json | jq '.items[0].status.capacity'