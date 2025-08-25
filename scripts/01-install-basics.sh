#!/bin/bash
# Script: 01-install-basics.sh
# Descrição: Instala dependências básicas do sistema

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

echo "✅ Dependências básicas instaladas!"