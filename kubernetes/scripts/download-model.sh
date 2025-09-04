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
