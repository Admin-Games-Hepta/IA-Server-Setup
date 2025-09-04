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
