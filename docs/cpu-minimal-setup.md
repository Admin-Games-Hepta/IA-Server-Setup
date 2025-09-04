# 🐢 Instalação CPU Minimal

## Requisitos Mínimos do Sistema
- Kubernetes cluster (minikube, k3s, ou distribuído)
- 4GB RAM disponível
- 20GB de armazenamento
- CPU com suporte a instruções AVX
- 2 núcleos de CPU

### 📋 Pré-requisitos
- ✅Kubernetes instalado e configurado
- ✅kubectl configurado para acesso ao cluster
- ✅StorageClass "local-path" disponível (padrão no k3s)

## 🚀 Passo a Passo da Instalação

1. **Clone o repositório:**
```bash
   cd /opt
   git clone https://github.com/Admin-Games-Hepta/IA-Server-Setup.git
   cd IA-Server-Setup
```
2. **Prepare os diretórios de dados:**
```bash
   sudo mkdir -p /opt/llm-models /opt/postgres-data
   sudo chmod 777 /opt/llm-models /opt/postgres-data
```
3. **Execute o script de instalação:**
```bash
   ./kubernetes/scripts/apply-cpu-minimal.sh
```
4. **Verifique o status da implantação:**
```bash
   kubectl get pods -n ia-llm -w
```
5. **Aguarde todos os pods estarem com STATUS "Running":**
```bash
   kubectl wait --for=condition=ready pod -l app=postgres -n ia-llm --timeout=120s
   kubectl wait --for=condition=ready pod -l app=ollama -n ia-llm --timeout=120s
   kubectl wait --for=condition=ready pod -l app=open-webui -n ia-llm --timeout=120s
```
6. **Acesse a interface:**
   ***Open WebUI: http://IP-do-seu-servidor:30081***
   
## Configuração Inicial do Open WebUI
- **1.** Acesse http://IP-seu-servidor:30081
- **2.** Crie uma conta de administrador
- **3.** Configure a conexão com Ollama em Settings → Connection
- **4.** Adicione modelos através da interface ou via API

## Modelos Recomendados para CPU Minimal
- 🔸 **llama3.2:1b** - 1.1GB (ideal para CPUs modestas)
- 🔸 **phi3:mini** - 1.8GB (bom equilíbrio qualidade/desempenho)
- 🔸 **gemma:2b** - 2.5GB (multilingual)
 
**Comandos Úteis**
*Ver logs dos containers:*
```bash
   kubectl logs -f deployment/ollama-deployment -n ia-llm
   kubectl logs -f deployment/open-webui-deployment -n ia-llm
```
*Ver consumo de recursos:*
```bash
   kubectl top pods -n ia-llm
```
**Reiniciar a implantação:**
```bash
   ./kubernetes/scripts/delete-all.sh
   ./kubernetes/scripts/apply-cpu-minimal.sh
```

## Troubleshooting
 📖 **Consulte a documentação de [troubleshooting](./docs/troubleshooting.md) para problemas comuns.**

**Próximos Passos**
 - 1️⃣ Configure um modelo inicial
 - 2️⃣ Ajuste as configurações conforme necessidade
