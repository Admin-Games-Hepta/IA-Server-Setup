# 📋 Requisitos de Hardware

## 🎯 Visão Geral
Este guia detalha os requisitos mínimos e recomendados para executar LLMs localmente com suporte a GPU e CPU.

## ⚙️ Configuração Mínima (CPU Only)
| Componente | Requisito Mínimo | Observações |
|------------|------------------|-------------|
| **CPU** | 8 núcleos físicos | Intel i7 ou AMD Ryzen 7+ |
| **RAM** | 16GB DDR4 | 32GB para modelos >7B |
| **Armazenamento** | 100GB SSD | Para modelos e sistema |
| **GPU** | Não requerida | Usará apenas CPU |

## 🚀 Configuração Recomendada (Com GPU NVIDIA)
| Componente | Requisito Recomendado | Observações |
|------------|-----------------------|-------------|
| **GPU** | NVIDIA ≥ 8GB VRAM | RTX 3070, 3080, 4060 Ti+ |
| **VRAM** | 12GB+ | Para modelos 13B+ |
| **CPU** | 12+ núcleos | Intel i9 ou AMD Ryzen 9 |
| **RAM** | 32GB DDR4/DDR5 | 64GB para múltiplos modelos |
| **Armazenamento** | 500GB NVMe SSD | Leitura rápida para modelos |

## 📊 Compatibilidade de Modelos
| Modelo | Tamanho | VRAM Mínima | RAM Mínima |
|--------|---------|-------------|------------|
| **CodeLlama-7B** | 7B | 6GB | 16GB |
| **Mistral-7B** | 7B | 6GB | 16GB |
| **DeepSeek-V3** | ?B | 8GB+ | 32GB+ |

## 🔌 Requisitos de Energia
- **GPU NVIDIA**: Fonte ≥ 750W para RTX 3080+
- **Estabilizador**: Recomendado para servidores
- **Resfriamento**: Boa ventilação para hardware

## 🌐 Rede e Conectividade
- **Internet**: ≥ 100Mbps para download de modelos
- **Roteador**: Estável para acesso remoto
- **Firewall**: Portas 22, 80, 443, 30000-32767 (Kubernetes)

## 📝 Checklist de Pré-Instalação
- [ ] Verificar compatibilidade hardware
- [ ] Atualizar BIOS/UEFI
- [ ] Reservar IP estático para servidor
- [ ] Preparar mídia de instalação Ubuntu