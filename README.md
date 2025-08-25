# 🧠 Ubuntu AI Server Setup
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Configuração completa de um servidor Ubuntu para executar modelos de linguagem (LLMs) como **DeepSeek-V3**, **Mistral**, e **CodeLlama**, com suporte a **GPU NVIDIA** e **CPU-only**, utilizando **K3s (Kubernetes)** e **Chatbot UI**.

## ✨ Funcionalidades

- ✅ Suporte a múltiplos LLMs (DeepSeek-V3, Mistral, CodeLlama)
- ✅ Deployment automatizado em Kubernetes (K3s)
- ✅ Suporte a GPU NVIDIA (CUDA) e CPU-only
- ✅ Interface web moderna (Chatbot UI)
- ✅ Scripts modulares e parametrizados
- ✅ Documentação detalhada para diferentes hardwares

## 🛠️ Stack Tecnológica

- **Sistema Operacional**: Ubuntu Server 22.04+ / 25.04+
- **Orquestração**: K3s (Kubernetes leve)
- **LLM Engine**: Ollama & llama.cpp
- **Interface**: Chatbot UI
- **Hardware**: Suporte a GPU NVIDIA e CPU-only

## 📋 Requisitos de Hardware

| Configuração | Mínimo (CPU) | Recomendado (GPU) |
|--------------|--------------|-------------------|
| **GPU**      | -            | NVIDIA ≥ 8GB VRAM |
| **RAM**      | 16GB         | 32GB+             |
| **CPU**      | 8 cores      | 12+ cores         |
| **Armazenamento** | 100GB SSD | 500GB+ NVMe      |

## 🚀 Começando

Consulte a documentação em [docs/hardware-requirements.md](docs/hardware-requirements.md) para instruções detalhadas de instalação.

## 📂 Estrutura do Projeto
    ia-server-setup/

        ├── scripts/ # Scripts de automação

        ├── kubernetes/ # Manifestos K3s

        ├── docs/ # Documentação

        └── README.md # Este arquivo

## 📜 License

Este projeto está licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para detalhes.
