#!/usr/bin/env bash
# medir-logstash.sh — mede tempo de indexação via Logstash (10k docs)
# Requer: bash, curl, date, docker compose
set -euo pipefail

ES_URL="${ES_URL:-http://localhost:9200}"
INDEX="${INDEX:-infra-hosts-logstash}"

# ⚠️ Caminho DENTRO do container (precisa bater com o volume do compose)
DATA_FILE_IN_CONTAINER="${DATA_FILE_IN_CONTAINER:-/data/dados-10000-ago-2025-logstash.ndjson}"

echo "→ Logstash | ES_URL=$ES_URL INDEX=$INDEX DATA_FILE_IN_CONTAINER=$DATA_FILE_IN_CONTAINER"

# 1) Cria índice alvo "limpo" (1 shard, 0 réplicas)
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

# 2) Sobe Logstash no diretório do compose
pushd ../01-instalacao >/dev/null

# Exporta variáveis que o compose repassa ao container
export ES_HOST="$ES_URL"
export INDEX
export DATA_FILE="$DATA_FILE_IN_CONTAINER"

start=$(date +%s)
docker compose up -d logstash

# Diagnóstico rápido: arquivo montado?
docker exec logstash sh -c 'ls -lh /data || true' || true

# 3) Faz polling até contar 10k docs OU timeout
target=10000
timeout_secs="${TIMEOUT_SECS:-600}"
echo "⏱  Medindo... alvo=$target docs, timeout=${timeout_secs}s"
for ((i=0; i<timeout_secs; i++)); do
  count=$(curl -sS "$ES_URL/$INDEX/_count" | grep -o '"count":[0-9]*' | cut -d: -f2)
  count=${count:-0}
  if [[ "$count" -ge "$target" ]]; then
    end=$(date +%s); break
  fi
  # Se nos primeiros segundos continuar 0, mostra um ping do container para diagnosticar
  if [[ $i -eq 5 ]]; then
    echo "… checando dentro do container"
    docker exec logstash sh -c 'echo "INDEX=$INDEX DATA_FILE=$DATA_FILE"; test -f "$DATA_FILE" && head -n 1 "$DATA_FILE" | cut -c1-120 || echo "ARQUIVO NÃO ENCONTRADO"'
  fi
  sleep 1
done

# 4) Encerra Logstash (opcional para nova rodada limpa)
docker compose rm -sf logstash >/dev/null 2>&1 || true
popd >/dev/null

if [[ -z "${end:-}" ]]; then
  echo "❌ Timeout sem atingir $target docs. Última contagem: ${count:-0}"
  echo "Sugestões: verifique o volume mapeado e se o DATA_FILE aponta para /data/... dentro do container."
  exit 1
fi

secs=$((end-start))
echo "✅ Tempo Logstash: ${secs}s  | docs no índice: $count"
echo "📈 Throughput: $(awk -v t=$secs 'BEGIN{ if(t>0) printf "%.1f", 10000/t; else print "∞"; }') docs/s"
