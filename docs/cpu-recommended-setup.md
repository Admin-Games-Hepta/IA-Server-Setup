# 🔧 Instalação CPU Recommended

## Requisitos Recomendados do Sistema
- Kubernetes cluster
- 16GB RAM disponível
- 40GB de armazenamento
- CPU moderna com múltiplos núcleos (8+ cores)
- Suporte a instruções AVX2

## Pré-requisitos
- ✅Kubernetes instalado e configurado
- ✅kubectl configurado para acesso ao cluster
- ✅StorageClass "local-path" disponível

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
   ./kubernetes/scripts/apply-cpu-recommended.sh
```
4. **Verifique o status da implantação:**
```bash
   kubectl get pods -n ia-llm -w
```
5. **Aguarde todos os pods estarem com STATUS "Running":**
```bash
kubectl wait --for=condition=ready pod -l app=postgres -n ia-llm --timeout=180s
kubectl wait --for=condition=ready pod -l app=ollama -n ia-llm --timeout=180s
kubectl wait --for=condition=ready pod -l app=open-webui -n ia-llm --timeout=180s
```
6. **Acesse a interface:**
   ***Open WebUI: http://IP-do-seu-servidor:30081***

## Configuração Inicial do Open WebUI
- **1.** Acesse http://IP-seu-servidor:30081
- **2.** Crie uma conta de administrador
- **3.** Configure a conexão com Ollama em Settings → Connection
- **4.** Adicione modelos através da interface ou via API

## Modelos Recomendados para CPU Recommended
- 🔸 **llama3.2:3b** - 2.5GB (bom desempenho em CPU)
- 🔸 **llama3.2:1b** - 1.1GB (rápido para tarefas simples)
- 🔸 **phi3:mini** - 1.8GB (excelente qualidade)
- 🔸 **gemma:2b** - 2.5GB (multilingual)
- 🔸 **mistral:7b** - 4.1GB (requer boa CPU)

## Otimizações para CPU
**Ajuste de variáveis de ambiente para melhor performance:**
```bash
yaml
env:
  - name: OLLAMA_NUM_PARALLEL
    value: "2"  # Número de núcleos para processamento paralelo
  - name: OLLAMA_MAX_LOADED_MODELS
    value: "2"  # Modelos mantidos em memória
```
	
## Monitoramento de Performance:

```bash
# Monitorar uso de CPU
kubectl top pods -n ia-llm

# Verificar logs de performance
kubectl logs deployment/ollama-deployment -n ia-llm | grep -i "eval"
```

## Escalabilidade
**Para ambientes com múltiplos usuários:**

- Aumente o OLLAMA_NUM_PARALLEL para 4-8
- Considere aumentar os limites de memória para 32GB
- Adicione mais réplicas do Ollama se necessário

## Troubleshooting
 📖 **Consulte a documentação de [troubleshooting](./docs/troubleshooting.md) para problemas comuns.*
 
**Próximos Passos**
 - 1️⃣ Configure um modelo inicial
 - 2️⃣ Ajuste as configurações conforme necessidade
