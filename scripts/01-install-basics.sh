#!/bin/bash
# Script: 01-install-basics.sh
# Descrição: Prepara sistema com diretórios no /opt

set -e

echo "🔄 Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

echo "📦 Instalando dependências básicas..."
sudo apt install -y \
    curl \
    wget \
    git \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

echo "📁 Criando estrutura de diretórios no /opt..."
sudo mkdir -p /opt/k3s-data /opt/k3s-storage /opt/models /opt/IA-Server-Setup
sudo chown -R $USER:$USER /opt/k3s-storage /opt/models /opt/IA-Server-Setup
sudo chmod 755 /opt/k3s-data /opt/k3s-storage /opt/models

echo "✅ Dependências básicas instaladas!"