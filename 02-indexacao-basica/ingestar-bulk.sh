#!/usr/bin/env bash
# Ingestão rápida via Bulk API para 10k docs
# Requer: bash, curl, awk (ou gawk)
# Dica Windows: se der erro com ^M -> dos2unix ingestar-bulk.sh

set -euo pipefail

ES_URL="${ES_URL:-http://localhost:9200}"
INDEX="${INDEX:-infra-hosts}"
FILE="${FILE:-dados-10000-ago-2025.ndjson}"

echo "→ ES_URL=$ES_URL  INDEX=$INDEX  FILE=$FILE"
[[ -f "$FILE" ]] || { echo "❌ Arquivo não encontrado: $FILE"; exit 1; }

# (opcional) recriar índice do zero
# comente a linha abaixo se não quiser apagar
curl -fsS -X DELETE "$ES_URL/$INDEX" >/dev/null || true

echo "→ Criando índice $INDEX (settings + mappings básicos)"
curl -fsS -X PUT "$ES_URL/$INDEX" -H 'Content-Type: application/json' -d '{
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
}' >/dev/null

echo "→ Desligando refresh durante o bulk"
curl -fsS -X PUT "$ES_URL/$INDEX/_settings" -H 'Content-Type: application/json' \
  -d '{"index":{"refresh_interval":"-1"}}' >/dev/null

echo "→ Ingerindo em BULK (convertendo NDJSON normal → formato Bulk em stream)"
start=$(date +%s)

# O arquivo tem 1 JSON por linha. Para Bulk, intercalamos linhas de ação {"index":{}}
# awk imprime a linha de ação e em seguida a linha original do arquivo.
awk '{print "{\"index\":{}}"; print $0}' "$FILE" \
| curl -fsS -H 'Content-Type: application/x-ndjson' -X POST "$ES_URL/_bulk" --data-binary @- >/dev/null

# Reativa refresh e força refresh final
curl -fsS -X PUT "$ES_URL/$INDEX/_settings" -H 'Content-Type: application/json' \
  -d '{"index":{"refresh_interval":"1s"}}' >/dev/null
curl -fsS -X POST "$ES_URL/$INDEX/_refresh" >/dev/null

end=$(date +%s)
secs=$((end - start))

count=$(curl -fsS "$ES_URL/$INDEX/_count" | grep -o '"count":[0-9]*' | cut -d: -f2)
echo "✅ Ingestão concluída em ${secs}s — documentos no índice: $count"
