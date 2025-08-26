#!/bin/bash
# Script: 03-install-k3s.sh
# Descrição: Instala K3s com suporte a GPU, CPU ou Minimal

set -e

MODE=${1:-"gpu"}  # Padrão: GPU
K3S_DATA_DIR="/opt/k3s-data"
K3S_STORAGE_DIR="/opt/k3s-storage"

echo "📦 Instalando K3s em modo: $MODE"

# Criar diretório de dados no /opt
sudo mkdir -p $K3S_DATA_DIR $K3S_STORAGE_DIR
sudo chmod 755 $K3S_DATA_DIR $K3S_STORAGE_DIR

case $MODE in
    "minimal")
        echo "🔧 Configurando K3s para modo MINIMAL..."
        curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.33.3+k3s1" sh -s - \
            --write-kubeconfig-mode 644 \
            --disable traefik \
            --disable servicelb \
            --disable-cloud-controller \
            --disable-network-policy \
            --data-dir $K3S_DATA_DIR \
            --node-ip 127.0.0.1
        ;;
    "cpu")
        echo "🔧 Configurando K3s para CPU only..."
        curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.33.3+k3s1" sh -s - \
            --write-kubeconfig-mode 644 \
            --disable traefik \
            --disable servicelb \
            --data-dir $K3S_DATA_DIR
        ;;
    *)
        echo "🎮 Configurando K3s com suporte a GPU..."
        curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.33.3+k3s1" sh -s - \
            --write-kubeconfig-mode 644 \
            --disable traefik \
            --disable servicelb \
            --data-dir $K3S_DATA_DIR
        ;;
esac

echo "🔄 Configurando kubectl..."
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config

echo "✅ K3s instalado com sucesso em modo $MODE!"
echo "📁 Dados em: $K3S_DATA_DIR"
kubectl get nodes