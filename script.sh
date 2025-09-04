#!/bin/bash
# Script de criação completa do projeto IA-Server-Setup
# Execute: chmod +x setup-ia-server.sh && ./setup-ia-server.sh

echo "================================================"
echo "    CRIANDO ESTRUTURA COMPLETA DO PROJETO"
echo "         IA-SERVER-SETUP KUBERNETES"
echo "================================================"

    echo "Criando estrutura de diretórios..."
    mkdir -p kubernetes/cpu-minimal
    mkdir -p kubernetes/cpu-recommended
    mkdir -p kubernetes/gpu-recommended
    mkdir -p kubernetes/scripts
    mkdir -p docs
    echo "Estrutura de diretórios criada!"

# namespace-ia-llm.yaml (comum a todos)
cat > kubernetes/cpu-minimal/namespace-ia-llm.yaml << 'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: ia-llm
  labels:
    name: ia-llm
    app: llm-stack
EOF

# ollama-pvc.yaml
cat > kubernetes/cpu-minimal/ollama-pvc.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: llm-models-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-path
  hostPath:
    path: /opt/llm-models
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: llm-models-pvc
  namespace: ia-llm
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: local-path
EOF

# ollama-service.yaml
cat > kubernetes/cpu-minimal/ollama-service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: ollama-service
  namespace: ia-llm
spec:
  selector:
    app: ollama
  type: NodePort
  ports:
    - port: 11434
      targetPort: 11434
      nodePort: 30080
EOF

# ollama.yaml (CPU Minimal)
cat > kubernetes/cpu-minimal/ollama.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ollama-deployment
  namespace: ia-llm
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ollama
  template:
    metadata:
      labels:
        app: ollama
    spec:
      containers:
        - name: ollama
          image: ollama/ollama:latest
          args: ["serve"]
          ports:
            - containerPort: 11434
          env:
            - name: OLLAMA_MODELS
              value: "/root/.ollama"
            - name: OLLAMA_NUM_PARALLEL
              value: "1"
            - name: OLLAMA_MAX_LOADED_MODELS
              value: "1"
            - name: OLLAMA_KEEP_ALIVE
              value: "2m"
          volumeMounts:
            - name: pvc
              mountPath: /root/.ollama
          resources:
            requests:
              memory: "2Gi"
              cpu: "1000m"
            limits:
              memory: "4Gi"
              cpu: "2000m"
      volumes:
        - name: pvc
          persistentVolumeClaim:
            claimName: llm-models-pvc
EOF

# open-webui-service.yaml
cat > kubernetes/cpu-minimal/open-webui-service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: open-webui-service
  namespace: ia-llm
spec:
  selector:
    app: open-webui
  type: NodePort
  ports:
    - name: http
      protocol: TCP
      port: 8080
      targetPort: 8080
      nodePort: 30081
EOF

# open-webui.yaml (CPU Minimal)
cat > kubernetes/cpu-minimal/open-webui.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: open-webui-deployment
  namespace: ia-llm
spec:
  replicas: 1
  selector:
    matchLabels:
      app: open-webui
  template:
    metadata:
      labels:
        app: open-webui
    spec:
      containers:
        - name: open-webui
          image: ghcr.io/open-webui/open-webui:main
          ports:
            - containerPort: 8080
              name: http
          env:
            - name: OLLAMA_API_BASE_URL
              value: "http://ollama-service:11434"
            - name: OLLAMA_BASE_URL
              value: "http://ollama-service:11434"
            - name: DATABASE_URL
              value: "postgresql://ollamawebui:ollamawebuipass123@postgres-service:5432/ollamawebui"
            - name: DEFAULT_LOCALE
              value: "pt-BR"
          resources:
            limits:
              memory: "512Mi"
              cpu: "500m"
            requests:
              memory: "256Mi"
              cpu: "250m"
EOF

# postgres-pvc.yaml
cat > kubernetes/cpu-minimal/postgres-pvc.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgres-pv
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-path
  hostPath:
    path: /opt/postgres-data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  namespace: ia-llm
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: local-path
EOF

# postgres-service.yaml
cat > kubernetes/cpu-minimal/postgres-service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: postgres-service
  namespace: ia-llm
spec:
  selector:
    app: postgres
  ports:
    - port: 5432
      targetPort: 5432
EOF

# postgres.yaml (CPU Minimal)
cat > kubernetes/cpu-minimal/postgres.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-deployment
  namespace: ia-llm
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:15
          ports:
            - containerPort: 5432
          env:
            - name: POSTGRES_DB
              value: ollamawebui
            - name: POSTGRES_USER
              value: ollamawebui
            - name: POSTGRES_PASSWORD
              value: ollamawebuipass123
          volumeMounts:
            - name: postgres-storage
              mountPath: /var/lib/postgresql/data
          resources:
            requests:
              memory: "256Mi"
              cpu: "250m"
            limits:
              memory: "512Mi"
              cpu: "500m"
      volumes:
        - name: postgres-storage
          persistentVolumeClaim:
            claimName: postgres-pvc
EOF

# apply-cpu-minimal.sh
cat > kubernetes/scripts/apply-cpu-minimal.sh << 'EOF'
#!/bin/bash

echo "Aplicando configurações CPU Minimal..."
cd "$(dirname "$0")/../cpu-minimal"

echo "Criando namespace..."
kubectl apply -f namespace-ia-llm.yaml

echo "Criando volumes persistentes..."
kubectl apply -f postgres-pvc.yaml
kubectl apply -f ollama-pvc.yaml

echo "Criando PostgreSQL..."
kubectl apply -f postgres-service.yaml
kubectl apply -f postgres.yaml

echo "Aguardando PostgreSQL iniciar..."
sleep 10

echo "Criando Ollama..."
kubectl apply -f ollama-service.yaml
kubectl apply -f ollama.yaml

echo "Criando Open WebUI..."
kubectl apply -f open-webui-service.yaml
kubectl apply -f open-webui.yaml

echo "Implantação CPU Minimal concluída!"
echo "Open WebUI disponível em: http://seu-servidor:30081"
echo "Ollama API disponível em: http://seu-servidor:30080"
EOF

chmod +x kubernetes/scripts/apply-cpu-minimal.sh

# cpu-minimal-setup.md
cat > docs/cpu-minimal-setup.md << 'EOF'
# Instalação CPU Minimal

## Requisitos Mínimos
- Kubernetes cluster
- 4GB RAM disponível
- 20GB de armazenamento
- CPU com suporte a instruções AVX

## Passo a Passo

1. **Clone o repositório:**
```bash
   git clone https://github.com/Admin-Games-Hepta/IA-Server-Setup.git
   cd IA-Server-Setup
   
2. **Execute o script de instalação:**
   ./kubernetes/scripts/apply-cpu-minimal.sh

3. **Verifique o status:**
   kubectl get pods -n ia-llm
   kubectl get services -n ia-llm
   
4. **Acesse a interface:**
   Open WebUI: http://IP-do-seu-servidor:30081

### Modelos Recomendados
 🔸 llama3.2:1b
 🔸 phi3:mini
 🔸 gemma:2b
 
## Troubleshooting
Verifique a documentação de troubleshooting para problemas comuns.
EOF

# apply-cpu-recommended.sh
cat > kubernetes/scripts/apply-cpu-recommended.sh << 'EOF'
#!/bin/bash

echo "Aplicando configurações CPU Recommended..."
cd "$(dirname "$0")/../cpu-recommended"

echo "Criando namespace..."
kubectl apply -f namespace-ia-llm.yaml

echo "Criando volumes persistentes..."
kubectl apply -f postgres-pvc.yaml
kubectl apply -f ollama-pvc.yaml

echo "Criando PostgreSQL..."
kubectl apply -f postgres-service.yaml
kubectl apply -f postgres.yaml

echo "Aguardando PostgreSQL iniciar..."
sleep 15

echo "Criando Ollama..."
kubectl apply -f ollama-service.yaml
kubectl apply -f ollama.yaml

echo "Criando Open WebUI..."
kubectl apply -f open-webui-service.yaml
kubectl apply -f open-webui.yaml

echo "Implantação CPU Recommended concluída!"
echo "Open WebUI disponível em: http://seu-servidor:30081"
echo "Ollama API disponível em: http://seu-servidor:30080"
EOF

chmod +x kubernetes/scripts/apply-cpu-recommended.sh

# delete-all.sh
cat > kubernetes/scripts/delete-all.sh << 'EOF'
#!/bin/bash

echo "Removendo todos os recursos do namespace ia-llm..."
kubectl delete namespace ia-llm --ignore-not-found=true

echo "Removendo persistent volumes..."
kubectl delete pv llm-models-pv --ignore-not-found=true
kubectl delete pv postgres-pv --ignore-not-found=true

echo "Limpando diretórios de dados..."
sudo rm -rf /opt/llm-models/*
sudo rm -rf /opt/postgres-data/*

echo "Limpeza concluída!"
EOF

chmod +x kubernetes/scripts/delete-all.sh

# download-model.sh
cat > kubernetes/scripts/download-model.sh << 'EOF'
#!/bin/bash

MODEL=${1:-"llama3.2:1b"}
echo "Baixando modelo $MODEL via Ollama API..."

# Aguardar o Ollama estar pronto
until curl -s http://localhost:30080/api/tags > /dev/null; do
    echo "Aguardando Ollama iniciar..."
    sleep 5
done

# Baixar o modelo
curl -X POST http://localhost:30080/api/pull -d "{\"name\": \"$MODEL\"}"

echo "Modelo $MODEL baixado com sucesso!"
echo "Para verificar: curl http://localhost:30080/api/tags"
EOF

chmod +x kubernetes/scripts/download-model.sh

mkdir -p kubernetes/cpu-recommended

# namespace-ia-llm.yaml (igual para todos)
cp kubernetes/cpu-minimal/namespace-ia-llm.yaml kubernetes/cpu-recommended/

# ollama-pvc.yaml (CPU Recommended)
cat > kubernetes/cpu-recommended/ollama-pvc.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: llm-models-pv
spec:
  capacity:
    storage: 30Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-path
  hostPath:
    path: /opt/llm-models
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: llm-models-pvc
  namespace: ia-llm
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 30Gi
  storageClassName: local-path
EOF

# ollama-service.yaml (igual)
cp kubernetes/cpu-minimal/ollama-service.yaml kubernetes/cpu-recommended/

# ollama.yaml (CPU Recommended)
cat > kubernetes/cpu-recommended/ollama.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ollama-deployment
  namespace: ia-llm
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ollama
  template:
    metadata:
      labels:
        app: ollama
    spec:
      containers:
        - name: ollama
          image: ollama/ollama:latest
          args: ["serve"]
          ports:
            - containerPort: 11434
          env:
            - name: OLLAMA_MODELS
              value: "/root/.ollama"
            - name: OLLAMA_NUM_PARALLEL
              value: "2"
            - name: OLLAMA_MAX_LOADED_MODELS
              value: "2"
            - name: OLLAMA_KEEP_ALIVE
              value: "10m"
          volumeMounts:
            - name: pvc
              mountPath: /root/.ollama
          resources:
            requests:
              memory: "8Gi"
              cpu: "4000m"
            limits:
              memory: "16Gi"
              cpu: "8000m"
      volumes:
        - name: pvc
          persistentVolumeClaim:
            claimName: llm-models-pvc
EOF

# open-webui-service.yaml (igual)
cp kubernetes/cpu-minimal/open-webui-service.yaml kubernetes/cpu-recommended/

# open-webui.yaml (CPU Recommended)
cat > kubernetes/cpu-recommended/open-webui.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: open-webui-deployment
  namespace: ia-llm
spec:
  replicas: 1
  selector:
    matchLabels:
      app: open-webui
  template:
    metadata:
      labels:
        app: open-webui
    spec:
      containers:
        - name: open-webui
          image: ghcr.io/open-webui/open-webui:main
          ports:
            - containerPort: 8080
              name: http
          env:
            - name: OLLAMA_API_BASE_URL
              value: "http://ollama-service:11434"
            - name: OLLAMA_BASE_URL
              value: "http://ollama-service:11434"
            - name: DATABASE_URL
              value: "postgresql://ollamawebui:ollamawebuipass123@postgres-service:5432/ollamawebui"
            - name: DEFAULT_LOCALE
              value: "pt-BR"
          resources:
            limits:
              memory: "2Gi"
              cpu: "1000m"
            requests:
              memory: "1Gi"
              cpu: "500m"
EOF

# postgres-pvc.yaml (CPU Recommended)
cat > kubernetes/cpu-recommended/postgres-pvc.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgres-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-path
  hostPath:
    path: /opt/postgres-data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  namespace: ia-llm
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: local-path
EOF

# postgres-service.yaml (igual)
cp kubernetes/cpu-minimal/postgres-service.yaml kubernetes/cpu-recommended/

# postgres.yaml (CPU Recommended)
cat > kubernetes/cpu-recommended/postgres.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-deployment
  namespace: ia-llm
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:15
          ports:
            - containerPort: 5432
          env:
            - name: POSTGRES_DB
              value: ollamawebui
            - name: POSTGRES_USER
              value: ollamawebui
            - name: POSTGRES_PASSWORD
              value: ollamawebuipass123
          volumeMounts:
            - name: postgres-storage
              mountPath: /var/lib/postgresql/data
          resources:
            requests:
              memory: "1Gi"
              cpu: "500m"
            limits:
              memory: "2Gi"
              cpu: "1000m"
      volumes:
        - name: postgres-storage
          persistentVolumeClaim:
            claimName: postgres-pvc
EOF

mkdir -p kubernetes/gpu-recommended

# namespace-ia-llm.yaml (igual para todos)
cp kubernetes/cpu-minimal/namespace-ia-llm.yaml kubernetes/gpu-recommended/

# ollama-pvc.yaml (GPU Recommended)
cat > kubernetes/gpu-recommended/ollama-pvc.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: llm-models-pv
spec:
  capacity:
    storage: 50Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-path
  hostPath:
    path: /opt/llm-models
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: llm-models-pvc
  namespace: ia-llm
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 50Gi
  storageClassName: local-path
EOF

# ollama-service.yaml (igual)
cp kubernetes/cpu-minimal/ollama-service.yaml kubernetes/gpu-recommended/

# ollama.yaml (GPU Recommended)
cat > kubernetes/gpu-recommended/ollama.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ollama-deployment
  namespace: ia-llm
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ollama
  template:
    metadata:
      labels:
        app: ollama
    spec:
      containers:
        - name: ollama
          image: ollama/ollama:latest
          args: ["serve"]
          ports:
            - containerPort: 11434
          env:
            - name: OLLAMA_MODELS
              value: "/root/.ollama"
            - name: OLLAMA_NUM_PARALLEL
              value: "4"
            - name: OLLAMA_MAX_LOADED_MODELS
              value: "3"
            - name: OLLAMA_KEEP_ALIVE
              value: "30m"
          volumeMounts:
            - name: pvc
              mountPath: /root/.ollama
          resources:
            requests:
              memory: "16Gi"
              cpu: "4000m"
              nvidia.com/gpu: 1
            limits:
              memory: "32Gi"
              cpu: "8000m"
              nvidia.com/gpu: 1
      volumes:
        - name: pvc
          persistentVolumeClaim:
            claimName: llm-models-pvc
EOF

# open-webui-service.yaml (igual)
cp kubernetes/cpu-minimal/open-webui-service.yaml kubernetes/gpu-recommended/

# open-webui.yaml (GPU Recommended)
cat > kubernetes/gpu-recommended/open-webui.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: open-webui-deployment
  namespace: ia-llm
spec:
  replicas: 1
  selector:
    matchLabels:
      app: open-webui
  template:
    metadata:
      labels:
        app: open-webui
    spec:
      containers:
        - name: open-webui
          image: ghcr.io/open-webui/open-webui:main
          ports:
            - containerPort: 8080
              name: http
          env:
            - name: OLLAMA_API_BASE_URL
              value: "http://ollama-service:11434"
            - name: OLLAMA_BASE_URL
              value: "http://ollama-service:11434"
            - name: DATABASE_URL
              value: "postgresql://ollamawebui:ollamawebuipass123@postgres-service:5432/ollamawebui"
            - name: DEFAULT_LOCALE
              value: "pt-BR"
          resources:
            limits:
              memory: "4Gi"
              cpu: "2000m"
            requests:
              memory: "2Gi"
              cpu: "1000m"
EOF

# postgres-pvc.yaml (GPU Recommended)
cat > kubernetes/gpu-recommended/postgres-pvc.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgres-pv
spec:
  capacity:
    storage: 20Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-path
  hostPath:
    path: /opt/postgres-data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  namespace: ia-llm
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
  storageClassName: local-path
EOF

# postgres-service.yaml (igual)
cp kubernetes/cpu-minimal/postgres-service.yaml kubernetes/gpu-recommended/

# postgres.yaml (GPU Recommended)
cat > kubernetes/gpu-recommended/postgres.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-deployment
  namespace: ia-llm
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:15
          ports:
            - containerPort: 5432
          env:
            - name: POSTGRES_DB
              value: ollamawebui
            - name: POSTGRES_USER
              value: ollamawebui
            - name: POSTGRES_PASSWORD
              value: ollamawebuipass123
          volumeMounts:
            - name: postgres-storage
              mountPath: /var/lib/postgresql/data
          resources:
            requests:
              memory: "2Gi"
              cpu: "1000m"
            limits:
              memory: "4Gi"
              cpu: "2000m"
      volumes:
        - name: postgres-storage
          persistentVolumeClaim:
            claimName: postgres-pvc
EOF

mkdir -p docs

# cpu-minimal-setup.md
cat > docs/cpu-minimal-setup.md << 'EOF'
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
**1.** Acesse http://seu-servidor:30081
**2.** Crie uma conta de administrador
**3.** Configure a conexão com Ollama em Settings → Connection
**4.** Adicione modelos através da interface ou via API

## Modelos Recomendados para CPU Minimal
 🔸 **llama3.2:1b** - 1.1GB (ideal para CPUs modestas)
 🔸 **phi3:mini** - 1.8GB (bom equilíbrio qualidade/desempenho)
 🔸 **gemma:2b** - 2.5GB (multilingual)
 
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
EOF

# cpu-recommended-setup.md
cat > docs/cpu-recommended-setup.md << 'EOF'
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
**1.** Acesse http://seu-servidor:30081
**2.** Crie uma conta de administrador
**3.** Configure a conexão com Ollama em Settings → Connection
**4.** Adicione modelos através da interface ou via API

## Modelos Recomendados para CPU Recommended
 🔸 **llama3.2:3b** - 2.5GB (bom desempenho em CPU)
 🔸 **llama3.2:1b** - 1.1GB (rápido para tarefas simples)
 🔸 **phi3:mini** - 1.8GB (excelente qualidade)
 🔸 **gemma:2b** - 2.5GB (multilingual)
 🔸 **mistral:7b** - 4.1GB (requer boa CPU)

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

Aumente o OLLAMA_NUM_PARALLEL para 4-8
Considere aumentar os limites de memória para 32GB
Adicione mais réplicas do Ollama se necessário

## Troubleshooting
 📖 **Consulte a documentação de [troubleshooting](./docs/troubleshooting.md) para problemas comuns.*
 
**Próximos Passos**
 - 1️⃣ Configure um modelo inicial
 - 2️⃣ Ajuste as configurações conforme necessidade
EOF

# gpu-recommended-setup.md
cat > docs/gpu-recommended-setup.md << 'EOF'
# 🔧 Instalação GPU Recommended

## Requisitos com GPU
- Kubernetes cluster com nós GPU
- NVIDIA GPU com pelo menos 8GB VRAM
- 32GB RAM disponível
- 70GB de armazenamento
- NVIDIA drivers instalados nos nós
- NVIDIA container toolkit

## Pré-requisitos Essenciais

1. **Instalar NVIDIA Drivers:**
```bash
   # Ubuntu/Debian
   sudo apt-get install nvidia-driver-535

   # CentOS/RHEL
   sudo dnf install nvidia-driver
```

2. **Instalar NVIDIA Container Toolkit:**
```bash
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

3. **Configurar Kubernetes para GPUs:**
```bash
# Instalar NVIDIA device plugin
kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.14.5/nvidia-device-plugin.yml
```

4. **Verificar disponibilidade de GPUs:**
```bash
kubectl get nodes -o json | jq '.items[].status.capacity'
```bash

## 🚀 Passo a Passo da Instalação

1. **Clone o repositório:**
```bash
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
   ./kubernetes/scripts/apply-gpu-recommended.sh
```
4. **Verifique o status da implantação:**
```bash
   kubectl get pods -n ia-llm -w
```

5. **Verifique se a GPU está sendo detectada:**
```bash
kubectl describe pod -l app=ollama -n ia-llm | grep -i gpu
```

6. **Acesse a interface:**
   ***Open WebUI: http://IP-do-seu-servidor:30081***

## Modelos Recomendados para GPU 8GB VRAM:
 🔸 **llama3.2:3b** - 2.5GB (excelente performance)
 🔸 **llama3:8b** - 4.7GB (bom equilíbrio)
 🔸 **mistral:7b** - 4.1GB (ótimas capacidades)

## Modelos Recomendados para GPU 12GB+ VRAM:
 🔸 **llama3:70b** - 39GB (requer quantização)
 🔸 **mixtral:8x7b** - 23GB (MoE eficiente)
 🔸 **qwen:14b** - 7.8GB (multilingual)

## Otimizações para GPU
**Ajustes de performance:**
```bash
yaml
env:
  - name: OLLAMA_NUM_GPU
    value: "1"    # Número de GPUs para uso
  - name: OLLAMA_GPU_LAYERS
    value: "9999" # Máximo de camadas na GPU
```

## Monitoramento de GPU:
```bash
# Instalar NVIDIA DCGM exporter para monitoring
helm install prometheus-gpu prometheus-community/prometheus
helm install dcgm-exporter nvidia/dcgm-exporter

# Verificar uso de GPU
kubectl exec -it deployment/ollama-deployment -n ia-llm -- nvidia-smi
Troubleshooting GPU
```

## Problemas comuns:

**GPU não detectada:** Verifique NVIDIA device plugin
**Out of Memory:** Reduza OLLAMA_GPU_LAYERS
**Driver issues:** Atualize drivers NVIDIA

## Solução de problemas:
```bash
# Verificar logs da GPU
kubectl logs deployment/ollama-deployment -n ia-llm | grep -i cuda

# Testar CUDA no container
kubectl exec -it deployment/ollama-deployment -n ia-llm -- nvcc --version
```

## Performance Tips
 - Use quantização 4-bit para modelos grandes
 - Ajuste batch_size conforme a VRAM disponível
 - Monitor temperatura da GPU durante carga prolongada
EOF

# troubleshooting.md
cat > docs/troubleshooting.md << 'EOF'
# 🎯 Troubleshooting e Solução de Problemas

## Problemas Comuns e Soluções

### 1. Pods não iniciam (Pending status)

**Sintoma:**
```bash
kubectl get pods -n ia-llm
# STATUS: *Pending* em algum pod
```

*Soluções:*
```bash
# Verificar eventos do pod
kubectl describe pod <pod-name> -n ia-llm

# Verificar recursos disponíveis
kubectl describe nodes | grep -A 10 -B 5 "Capacity"

# Liberar recursos
kubectl delete pods --all -n ia-llm --grace-period=0 --force
```

### 2. Erro de ImagePullBackOff
*Solução:*

```bash
# Verificar credenciais do registry
kubectl get secrets --all-namespaces

# Tentar pull manualmente
docker pull ollama/ollama:latest
docker pull ghcr.io/open-webui/open-webui:main
```

### 3. Persistent Volume Claims não vinculam
**Solução:**

```bash
# Verificar StorageClass
kubectl get storageclass

# Verificar Persistent Volumes
kubectl get pv

# Criar manualmente se necessário
sudo mkdir -p /opt/llm-models /opt/postgres-data
sudo chmod 777 /opt/llm-models /opt/postgres-data
```

### 4. Ollama não consegue baixar modelos
*Solução:*

```bash
# Verificar conectividade
kubectl exec -it deployment/ollama-deployment -n ia-llm -- curl -I https://ollama.com

# Baixar manualmente via script
./kubernetes/scripts/download-model.sh llama3.2:1b
```

### 5. Open WebUI não conecta com Ollama
*Solução:*

```bash
# Verificar se Ollama está respondendo
kubectl exec -it deployment/ollama-deployment -n ia-llm -- curl http://localhost:11434/api/tags

# Verificar variáveis de ambiente
kubectl describe deployment/open-webui-deployment -n ia-llm | grep -A 10 -B 5 "Environment"
```

### 6. Problemas de GPU
*Sintoma:* GPU não detectada ou não utilizada

*Solução:*

```bash
# Verificar device plugin
kubectl get pods -n kube-system | grep nvidia

# Reiniciar device plugin
kubectl delete pod -n kube-system -l name=nvidia-device-plugin-ds

# Verificar drivers nos nodes
kubectl get nodes -o json | jq '.items[].status.allocatable'
```

### 7. PostgreSQL não inicia
**Solução:**

```bash
# Verificar logs
kubectl logs -f deployment/postgres-deployment -n ia-llm

# Verificar permissoes do volume
kubectl exec -it deployment/postgres-deployment -n ia-llm -- ls -la /var/lib/postgresql/data
```

### 8. Limites de recursos excedidos
**Solução:**

```bash
# Ajustar limites no YAML
# Aumentar memory limits e requests

# Verificar consumo atual
kubectl top pods -n ia-llm
```

### 9. Problemas de rede entre pods
*Solução:*

```bash
# Testar conectividade entre pods
kubectl exec -it deployment/open-webui-deployment -n ia-llm -- curl http://ollama-service:11434

# Verificar serviços
kubectl get services -n ia-llm
```

### 10. Reinicialização completa
**Para recomeçar do zero:**

```bash
./kubernetes/scripts/delete-all.sh
# Aguardar alguns segundos
./kubernetes/scripts/apply-<ambiente>.sh
```

### Logs Detalhados
*Para debugging detalhado:*

```bash
# Logs do Ollama com verbose
kubectl logs deployment/ollama-deployment -n ia-llm --previous

# Logs do Kubernetes events
kubectl get events -n ia-llm --sort-by='.lastTimestamp'

# Logs do container runtime
sudo journalctl -u kubelet -f
```

### Performance Tuning
*Otimizações comuns:*

Aumentar OLLAMA_NUM_PARALLEL para CPUs multicore
Ajustar OLLAMA_MAX_LOADED_MODELS conforme memória
Configurar OLLAMA_GPU_LAYERS para GPUs
Ajustar limites de recursos no YAML

### Monitoramento:

```bash
# Monitor contínuo
watch -n 2 'kubectl top pods -n ia-llm'

# Grafana/Prometheus para monitoring avançado
helm install prometheus prometheus-community/prometheus (Não tem explicação de como usar, configurar o prometheus)
```
EOF

## 5. Arquivos de Configuração Principais

# README.md
cat > README.md << 'EOF'
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
├── kubernetes/          # Manifestos Kubernetes
│   ├── cpu-minimal/    # Configuração mínima CPU
│   ├── cpu-recommended/# Configuração recomendada CPU  
│   ├── gpu-recommended/# Configuração com GPU
│   └── scripts/        # Scripts de automação
├── docs/               # Documentação
└── README.md          # Este arquivo
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


### Open WebUI API (Porta 30081)
**Acesso via interface web em http://localhost:30081**

## Licença
***Este projeto está sob a licença MIT. Veja o arquivo LICENSE para detalhes.***

## Suporte
*Para issues e dúvidas, abra uma issue no GitHub ou consulte a documentação de [Troubleshooting](./docs/troubleshooting.md).*
EOF

# requirements.txt
cat > requirements.txt << 'EOF'
# IA Server Setup - Dependencies
# Este arquivo lista dependências Python para scripts auxiliares

kubernetes>=28.1.0
requests>=2.31.0
docker>=6.1.3
pyyaml>=6.0.1
tqdm>=4.66.2
EOF
