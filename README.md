# 🧠 Ubuntu AI Server Setup
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Configuração completa de um servidor Ubuntu para executar modelos de linguagem (LLMs) como **DeepSeek-V3**, **Mistral**, **CodeLlama** e **TinyLlama**, com suporte a **GPU NVIDIA**, **CPU-only** e **modo minimal**, utilizando **K3s (Kubernetes)** e **Chatbot UI**.

## 🚀 Guias de Instalação

### 🔧 Para Instalação em CPU: 
📖 **Consulte nossa documentação completa:** [Instalação CPU Guide](./docs/cpu-setup.md)

### 🎮 Para Instalação com GPU NVIDIA:
📖 **Documentação GPU:** [Instalação GPU Guide](./docs/gpu-setup.md) 

### 🐢 Para Hardware Limitado (Modo Minimal):
📖 **Guia Minimal:** [Modo Minimal Guide](./docs/cpu-setup.md#-modo-minimal-hardware-limitado)

## ✨ Funcionalidades

- ✅ Suporte a múltiplos LLMs (DeepSeek-V3, Mistral, CodeLlama, TinyLlama)
- ✅ Deployment automatizado em Kubernetes (K3s)
- ✅ Suporte a GPU NVIDIA (CUDA) e CPU-only
- ✅ Interface web moderna (Chatbot UI)
- ✅ Scripts modulares e parametrizados
- ✅ Documentação detalhada para diferentes hardwares

## 🛠️ Stack Tecnológica

- **Sistema Operacional**: Ubuntu Server 22.04+ / 24.04+ / 25.04
- **Orquestração**: K3s (Kubernetes leve)
- **LLM Engine**: Ollama & llama.cpp
- **Interface**: Chatbot UI
- **Hardware**: Suporte a GPU NVIDIA, CPU-only e modo minimal

## 📋 Requisitos de Hardware

| Configuração | Minimal (CPU) | CPU Only | GPU NVIDIA |
|--------------|---------------|----------|------------|
| **GPU**      | -             | -        | ≥ 8GB VRAM |
| **RAM**      | 4GB           | 16GB     | 32GB+      |
| **CPU**      | 2 núcleos     | 8 núcleos| 12+ núcleos|
| **Armazenamento** | 10GB SSD  | 100GB SSD | 500GB+ NVMe |

Consulte a documentação em [docs/hardware-requirements.md](docs/hardware-requirements.md) para instruções detalhadas de instalação.

## 📂 Estrutura do Projeto
    ia-server-setup/

        ├── scripts/ # Scripts de automação

        ├── kubernetes/ # Manifestos K3s

        ├── docs/ # Documentação

        └── README.md # Este arquivo

## 📜 License

Este projeto está licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para detalhes.
