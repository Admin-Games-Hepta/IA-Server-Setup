# 📋 Requisitos de Hardware

Este guia detalha os requisitos mínimos e recomendados para executar LLMs localmente em diferentes configurações de hardware.

## 🎯 Visão Geral das Configurações

| Configuração | CPU Only | GPU NVIDIA | Modo Minimal |
|--------------|----------|------------|--------------|
| **Uso Indicado** | Servidores enterprise | Workstations gamers | Testes/Desenvolvimento |
| **Custo** | Moderado | Alto | Baixo |
| **Performance** | Boa | Excelente | Básica |
| **Complexidade** | Média | Alta | Baixa |

## ⚙️ Configuração Minimal (CPU Only - Testes/Dev)
| Componente | Requisito Mínimo | Observações |
|------------|------------------|-------------|
| **CPU** | 4 núcleos físicos | Intel i5 ou AMD Ryzen 5 |
| **RAM** | 8GB DDR4 | 12GB para modelos 7B |
| **Armazenamento** | 50GB SSD | Para sistema + 1-2 modelos |
| **GPU** | Não requerida | Uso exclusivo de CPU |
| **Rede** | 100Mbps | Download de modelos |

## 🐢 Configuração CPU Only (Production)
| Componente | Requisito Mínimo | Recomendado | Observações |
|------------|------------------|-------------|-------------|
| **CPU** | 8 núcleos | 16+ núcleos | Intel i7/i9 ou AMD Ryzen 7/9 |
| **RAM** | 16GB | 32GB+ | DDR4/DDR5, 3200MHz+ |
| **Armazenamento** | 100GB NVMe | 500GB+ NVMe | Leitura: 2000+ MB/s |
| **GPU** | Não requerida | Não requerida | - |
| **PSU** | 500W | 750W+ 80+ Gold | Estável para CPU high-end |

## 🎮 Configuração com GPU NVIDIA
| Componente | Requisito Mínimo | Recomendado | High-End |
|------------|------------------|-------------|----------|
| **GPU** | RTX 3060 12GB | RTX 4080 16GB | RTX 4090 24GB |
| **VRAM** | 12GB | 16GB+ | 24GB |
| **CPU** | 8 núcleos | 12+ núcleos | 16+ núcleos |
| **RAM** | 32GB | 64GB | 128GB+ |
| **Armazenamento** | 250GB NVMe | 1TB NVMe | 2TB+ NVMe |
| **PSU** | 650W | 850W 80+ Gold | 1000W+ 80+ Platinum |

## 📊 Compatibilidade de Modelos por Hardware

### 🐢 Modo Minimal (TinyLlama-1B)
| Hardware | Tokens/sec | Latência | VRAM | RAM |
|----------|------------|----------|------|-----|
| CPU 4c/8GB | 10-15 t/s | 3-5s | 0GB | 2GB |
| CPU 8c/16GB | 20-30 t/s | 1-2s | 0GB | 3GB |

### ⚡ CPU Only (Modelos 7B)
| Hardware | Tokens/sec | Latência | VRAM | RAM |
|----------|------------|----------|------|-----|
| CPU 8c/16GB | 4-8 t/s | 2-4s | 0GB | 8GB |
| CPU 16c/32GB | 8-15 t/s | 1-2s | 0GB | 10GB |
| CPU 32c/64GB | 15-25 t/s | 0.5-1s | 0GB | 12GB |

### 🎮 GPU NVIDIA (Modelos 7B)
| GPU | Tokens/sec | Latência | VRAM | RAM |
|-----|------------|----------|------|-----|
| RTX 3060 12GB | 25-40 t/s | 0.3-0.6s | 10GB | 4GB |
| RTX 4080 16GB | 60-90 t/s | 0.1-0.3s | 14GB | 4GB |
| RTX 4090 24GB | 80-120 t/s | 0.1-0.2s | 18GB | 4GB |

## 🔌 Requisitos de Energia e Resfriamento

### ⚡ Alimentação Elétrica
| Configuração | Wattagem Mínima | Recomendada | Notas |
|--------------|-----------------|-------------|-------|
| **CPU Only** | 450W | 650W | 80+ Bronze |
| **GPU Mid** | 650W | 850W | 80+ Gold |
| **GPU High** | 850W | 1000W+ | 80+ Platinum |

### ❄️ Resfriamento
| Configuração | Cooler CPU | Ventoinhas | Fluxo de Ar |
|--------------|------------|------------|-------------|
| **CPU Only** | Air Cooler | 2-3 | Moderado |
| **GPU Mid** | AIO 240mm | 3-4 | Bom |
| **GPU High** | AIO 360mm | 4-6+ | Excelente |

## 🌐 Rede e Conectividade

### 📡 Requisitos de Rede
| Componente | Mínimo | Recomendado | Notas |
|------------|--------|-------------|-------|
| **Internet** | 100Mbps | 500Mbps+ | Download modelos |
| **LAN** | 1Gbps | 2.5Gbps+ | Acesso local |
| **Wi-Fi** | WiFi 5 | WiFi 6E | Opcional |

### 🔒 Portas de Rede
| Porta | Protocolo | Uso | Necessidade |
|-------|-----------|-----|-------------|
| **22** | TCP | SSH | Opcional |
| **80** | TCP | HTTP | Opcional |
| **443** | TCP | HTTPS | Opcional |
| **30080** | TCP | Chatbot UI | Necessário |
| **6443** | TCP | K3s API | Necessário |

## 📝 Checklist de Pré-Instalação

### ✅ Verificação de Hardware
- [ ] CPU compatível com AVX2 instructions
- [ ] RAM suficiente para o modelo escolhido
- [ ] Armazenamento rápido (NVMe recomendado)
- [ ] Fonte com wattagem adequada
- [ ] Resfriamento suficiente

### ✅ Preparação do Sistema
- [ ] Ubuntu Server 22.04+ instalado
- [ ] BIOS/UEFI atualizado
- [ ] IP estático configurado
- [ ] SSH configurado (opcional)
- [ ] Firewall ajustado

### ✅ Verificação Pós-Instalação
- [ ] Sistema atualizado (`sudo apt update && upgrade`)
- [ ] Drivers instalados (se GPU NVIDIA)
- [ ] Temperaturas estáveis
- [ ] Rede funcionando

## 🚨 Solução de Problemas Comuns

### 🔥 Superaquecimento
```bash
# Monitorar temperaturas
sudo apt install lm-sensors
sensors

# Verificar carga CPU
htop

# Verificar uso GPU
nvidia-smi