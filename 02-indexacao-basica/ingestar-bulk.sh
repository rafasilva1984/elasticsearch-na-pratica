#!/usr/bin/env bash
# Ingestão rápida via Bulk API para 10k docs (NDJSON -> Bulk)
# Requer: bash, curl, awk
# Windows: se aparecer ^M -> dos2unix ingestar-bulk.sh

set -euo pipefail

ES_URL="${ES_URL:-http://localhost:9200}"
INDEX="${INDEX:-infra-hosts}"
FILE="${FILE:-dados-10000-ago-2025.ndjson}"

echo "→ ES_URL=$ES_URL  INDEX=$INDEX  FILE=$FILE"
[[ -f "$FILE" ]] || { echo "❌ Arquivo não encontrado: $FILE"; exit 1; }

# Apaga o índice se existir (ignora erro 404)
curl -sS -o /dev/null -X DELETE "$ES_URL/$INDEX" || true

echo "→ Criando índice $INDEX (settings + mappings básicos)"
curl -sS -o /dev/null -X PUT "$ES_URL/$INDEX" -H 'Content-Type: application/json' -d '{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0,
    "refresh_interval": "1s"
  },
  "mappings": {
    "properties": {
      "host":      { "type": "keyword" },
      "servico":   { "type": "keyword" },
      "status":    { "type": "keyword" },
      "cpu":       { "type": "integer" },
      "memoria":   { "type": "integer" },
      "@timestamp":{ "type": "date" }
    }
  }
}'

echo "→ Desligando refresh durante o bulk"
curl -sS -o /dev/null -X PUT "$ES_URL/$INDEX/_settings" -H 'Content-Type: application/json' \
  -d '{"index":{"refresh_interval":"-1"}}'

echo "→ Ingerindo em BULK (convertendo NDJSON normal → formato Bulk em stream)"
start=$(date +%s)

# Envie o bulk para /{INDEX}/_bulk (assim não precisamos de _index na action)
# Também capturamos a resposta para checar se houve errors:true
awk '{print "{\"index\":{}}"; print $0}' "$FILE" \
| curl -sS -H 'Content-Type: application/x-ndjson' -X POST "$ES_URL/$INDEX/_bulk" --data-binary @- \
  -o .bulk-result.json

# Reativa refresh e força refresh final
curl -sS -o /dev/null -X PUT "$ES_URL/$INDEX/_settings" -H 'Content-Type: application/json' \
  -d '{"index":{"refresh_interval":"1s"}}'
curl -sS -o /dev/null -X POST "$ES_URL/$INDEX/_refresh"

end=$(date +%s); secs=$((end - start))

# Verifica errors no resultado do bulk
if grep -q '"errors":true' .bulk-result.json; then
  echo "⚠️  Bulk retornou errors=true. Amostra dos erros:"
  # Mostra as 10 primeiras linhas com status >= 300
  grep -n '"status":' .bulk-result.json | grep -E '3[0-9]{2}|4[0-9]{2}|5[0-9]{2}' | head -n 10 || true
else
  echo "✅ Bulk sem erros (errors=false)"
fi

count=$(curl -sS "$ES_URL/$INDEX/_count" | grep -o '"count":[0-9]*' | cut -d: -f2)
echo "✅ Ingestão concluída em ${secs}s — documentos no índice: $count"
