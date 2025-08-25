#!/bin/bash
# Script: 02-install-nvidia.sh
# Descrição: Instala drivers NVIDIA e CUDA toolkit

set -e

echo "🔍 Verificando GPU NVIDIA..."
if ! lspci | grep -i nvidia > /dev/null; then
    echo "⚠️  NVIDIA GPU não detectada. Pulando instalação."
    exit 0
fi

echo "📦 Adicionando repositório NVIDIA..."
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

echo "🔄 Atualizando pacotes..."
sudo apt update

echo "🚀 Instalando NVIDIA Container Toolkit..."
sudo apt install -y nvidia-container-toolkit

echo "🔧 Configurando runtime NVIDIA..."
sudo nvidia-ctk runtime configure --runtime=docker

echo "🔄 Reiniciando Docker..."
sudo systemctl restart docker

echo "📊 Instalando NVIDIA Management Library (NVML)..."
sudo apt install -y nvidia-management-library

echo "✅ Drivers NVIDIA instalados com sucesso!"
echo "🔍 Verificando instalação..."
nvidia-smi