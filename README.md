# 🧠 IA Server Setup

Este projeto fornece uma stack completa de IA para execução de modelos de linguagem (LLMs) em Kubernetes, com três perfis de implantação:

## Perfis de Implantação

### 1. CPU Minimal
- **Requisitos:** 4GB RAM, 20GB storage, 2 cores CPU
- **Ideal:** Testes, desenvolvimento, modelos pequenos
- **Modelos:** llama3.2:1b, phi3:mini, gemma:2b

### 2. CPU Recommended  
- **Requisitos:** 16GB RAM, 40GB storage, 8+ cores CPU
- **Ideal:** Produção small-scale, múltiplos usuários
- **Modelos:** llama3.2:3b, mistral:7b, modelos médios

### 3. GPU Recommended
- **Requisitos:** 32GB RAM, 70GB storage, GPU NVIDIA 8GB+
- **Ideal:** Produção high-performance, modelos grandes
- **Modelos:** llama3:8b, mixtral:8x7b, qwen:14b

## Componentes Incluídos

- **Ollama:** Servidor de modelos LLM
- **Open WebUI:** Interface web para chat com modelos
- **PostgreSQL:** Banco de dados para a WebUI
- **Persistent Storage:** Armazenamento para modelos e dados

## Quick Start

```bash
# Clone o repositório
git clone https://github.com/Admin-Games-Hepta/IA-Server-Setup.git
cd IA-Server-Setup

# Prepare diretórios de dados
sudo mkdir -p /opt/llm-models /opt/postgres-data
sudo chmod 777 /opt/llm-models /opt/postgres-data

# Escolha o perfil (ex: CPU Minimal)
./kubernetes/scripts/apply-cpu-minimal.sh

# Acesse a interface
echo "Open WebUI: http://IP-do-seu-servidor:30081"
```

## Documentação Detalhada
📖 **[CPU Minimal Setup](./docs/cpu-minimal-setup.md)**
📖 **[CPU Recommended Setup](./docs/cpu-recommended-setup.md)**
📖 **[GPU Recommended Setup](./docs/gpu-recommended-setup.md)**
📖 **[Troubleshooting](./docs/troubleshooting.md)**

## Estrutura do Projeto
```text
IA-Server-Setup/
├── kubernetes/         # Manifestos Kubernetes
│   ├── cpu-minimal/    # Configuração mínima CPU
│   ├── cpu-recommended/# Configuração recomendada CPU  
│   ├── gpu-recommended/# Configuração com GPU
│   └── scripts/        # Scripts de automação
├── docs/               # Documentação
└── README.md           # Este arquivo
```

## Recursos de API
### Ollama API (Porta 30080)
```bash
# Listar modelos
curl http://localhost:30080/api/tags

# Baixar modelo
curl -X POST http://localhost:30080/api/pull -d '{"name": "llama3.2:1b"}'

# Gerar resposta
curl http://localhost:30080/api/generate -d '{
  "model": "llama3.2:1b",
  "prompt": "Por que o céu é azul?",
  "stream": false
}'
```

### Open WebUI API (Porta 30081)
**Acesso via interface web em http://localhost:30081**

## Licença
***Este projeto está sob a licença MIT. Veja o arquivo LICENSE para detalhes.***

## Suporte
*Para issues e dúvidas, abra uma issue no GitHub ou consulte a documentação de [Troubleshooting](./docs/troubleshooting.md).*
