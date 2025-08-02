#!/bin/bash
INDEX="infra-hosts"

# Criação do índice (com mapping básico)
curl -X PUT "http://localhost:9200/$INDEX" -H 'Content-Type: application/json' -d '{
  "mappings": {
    "properties": {
      "host": { "type": "keyword" },
      "servico": { "type": "keyword" },
      "status": { "type": "keyword" },
      "cpu": { "type": "integer" },
      "memoria": { "type": "integer" },
      "@timestamp": { "type": "date" }
    }
  }
}'

# Ingestão dos dados
while IFS= read -r line; do
  curl -X POST "http://localhost:9200/$INDEX/_doc" -H 'Content-Type: application/json' -d "$line"
done < dados-hosts.json

echo -e "\nIngestão concluída!"
