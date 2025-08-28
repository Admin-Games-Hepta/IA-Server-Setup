## 📁 Estrutura de Diretórios no /opt
    /opt/
        ├── k3s-data/ # Dados do K3s (∼5GB)
        ├── k3s-storage/ # Armazenamento persistente (PVCs)
        ├── models/ # Modelos LLM (∼20GB)
        └── IA-Server-Setup/ # Repositório e scripts

## 🎯 **Vantagens desta Estrutura:**

1. **✅ Não estoura `/` ou `/var`** - Tudo concentrado no `/opt`
2. **✅ Fácil backup** - Apenas `/opt` precisa ser backupado
3. **✅ Organização clara** - Cada tipo de dado em sua pasta
4. **✅ Permissões corretas** - Usuário tem acesso a tudo
5. **✅ Escalabilidade** - `/opt` pode estar em partição separada

-------------------------------

Este guia explica como instalar e configurar LLMs para execução **apenas com CPU** no Ubuntu Server 25.04 usando os scripts deste repositório.

## 📋 Pré-requisitos
- Ubuntu Server 25.04 instalado
- **Mínimo 16GB RAM** (32GB recomendado para modelos 7B+)
- **CPU com 8+ núcleos físicos**
- **SSD com 150GB+** de espaço livre
- Conexão internet estável

## 🚀 Instalação Passo a Passo

### 1. 🖥️ Preparar o Sistema Base

## ⚙️ Modo Basico

### Requisitos:
- **CPU:** 8 núcleos
- **RAM:** 32GB
- **Armazenamento:** 150GB

```bash
# Clonar repositório no /opt
cd /opt
sudo git clone https://github.com/Admin-Games-Hepta/IA-Server-Setup.git
sudo chown -R $USER:$USER IA-Server-Setup
cd IA-Server-Setup
chmod +x scripts/*.sh

# Instalar dependências
./scripts/01-install-basics.sh

# Instalar K3s (dados em /opt/k3s-data)
./scripts/03-install-k3s.sh cpu

# Baixar modelos (em /opt/models)
./scripts/04-download-models.sh

# Deploy da stack
./scripts/05-deploy-llm-stack.sh
```

## 🐢 Modo Minimal (Hardware Limitado)

### Requisitos Mínimos:
- **CPU:** 2 núcleos
- **RAM:** 4GB
- **Armazenamento:** 10GB

```bash
cd /opt
sudo git clone https://github.com/Admin-Games-Hepta/IA-Server-Setup.git
sudo chown -R $USER:$USER IA-Server-Setup
cd IA-Server-Setup
chmod +x scripts/*.sh

# Instalar K3s minimal
./scripts/03-install-k3s.sh minimal

# Baixar apenas phi-2
./scripts/04-download-models.sh minimal

# Deploy minimal
./scripts/05-deploy-llm-stack.sh minimal

# Usar apenas phi-2
./scripts/switch-model.sh phi-2 minimal
```