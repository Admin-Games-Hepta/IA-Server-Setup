# 🎮 Configuração para GPU NVIDIA

## Pré-requisitos
- GPU NVIDIA com pelo menos 8GB VRAM
- Driver NVIDIA instalado (versão 525+)
- CUDA Toolkit 12.0+

## Passos de Instalação

### 1. Instalar Drivers NVIDIA
```bash
# Verificar GPU detectada
lspci | grep -i nvidia

# Adicionar repositório oficial NVIDIA
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update

# Instalar driver recomendado
sudo ubuntu-drivers autoinstall

# Reiniciar sistema
sudo reboot