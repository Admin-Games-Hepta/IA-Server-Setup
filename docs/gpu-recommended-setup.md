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
