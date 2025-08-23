#!/usr/bin/env bash
# medir-logstash.sh — mede tempo de indexação via Logstash (10k docs)
# Requer: bash, curl, date, docker compose
set -euo pipefail

ES_URL="${ES_URL:-http://localhost:9200}"
INDEX="${INDEX:-infra-hosts-logstash}"
DATA_FILE="${DATA_FILE:-../02-indexacao-basica/dados-10000-ago-2025-logstash.ndjson}"

echo "→ Logstash | ES_URL=$ES_URL INDEX=$INDEX DATA_FILE=$DATA_FILE"

# 1) Garante que o índice alvo está limpo
curl -sS -o /dev/null -X DELETE "$ES_URL/$INDEX" || true
curl -sS -o /dev/null -X PUT "$ES_URL/$INDEX" -H 'Content-Type: application/json' -d '{
  "settings": { "number_of_shards": 1, "number_of_replicas": 0, "refresh_interval": "1s" },
  "mappings": {
    "properties": {
      "host": { "type": "keyword" },
      "servico": { "type": "keyword" },
      "status": { "type": "keyword" },
      "cpu": { "type": "integer" },
      "memoria": { "type": "integer" },
      "@timestamp": { "type": "date" },
      "ingest": { "type": "keyword" }
    }
  }
}'

# 2) Sobe Logstash com variáveis ajustadas para apontar para o novo índice
pushd ../01-instalacao >/dev/null
export ES_HOST="$ES_URL"
export INDEX
export DATA_FILE

start=$(date +%s)
docker compose up -d logstash

# 3) Faz polling até contar 10k docs OU timeout
target=10000
timeout_secs="${TIMEOUT_SECS:-300}"
echo "⏱  Medindo... alvo=$target docs, timeout=${timeout_secs}s"
for ((i=0; i<timeout_secs; i++)); do
  count=$(curl -sS "$ES_URL/$INDEX/_count" | grep -o '"count":[0-9]*' | cut -d: -f2)
  count=${count:-0}
  if [[ "$count" -ge "$target" ]]; then
    end=$(date +%s)
    break
  fi
  sleep 1
done

# 4) Encerra Logstash (opcional para nova rodada limpa)
docker compose rm -sf logstash >/dev/null 2>&1 || true
popd >/dev/null

if [[ -z "${end:-}" ]]; then
  echo "❌ Timeout sem atingir $target docs. Última contagem: ${count:-0}"
  exit 1
fi

secs=$((end-start))
echo "✅ Tempo Logstash: ${secs}s  | docs no índice: $count"
echo "📈 Throughput: $(awk -v t=$secs 'BEGIN{ if(t>0) printf "%.1f", 10000/t; else print "∞"; }') docs/s"
