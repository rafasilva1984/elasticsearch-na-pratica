#!/usr/bin/env bash
# medir-bulk.sh — mede tempo de indexação via Bulk (10k docs)
# Requer: bash, curl, awk, date
set -euo pipefail

ES_URL="${ES_URL:-http://localhost:9200}"
INDEX="${INDEX:-infra-hosts-bulk}"
FILE="${FILE:-../02-indexacao-basica/dados-10000-ago-2025.ndjson}"

echo "→ Bulk | ES_URL=$ES_URL INDEX=$INDEX FILE=$FILE"

# Usa o ingestar-bulk.sh já existente, mas sobrescrevendo INDEX/FILE
pushd ../02-indexacao-basica >/dev/null

start=$(date +%s)
INDEX="$INDEX" FILE="$FILE" ES_URL="$ES_URL" ./ingestar-bulk.sh | tee /tmp/_bulk_out.txt
end=$(date +%s)

secs=$((end-start))
count=$(curl -sS "$ES_URL/$INDEX/_count" | grep -o '"count":[0-9]*' | cut -d: -f2)

echo "✅ Tempo Bulk: ${secs}s  | docs no índice: $count"
echo "📈 Throughput: $(awk -v t=$secs 'BEGIN{ if(t>0) printf "%.1f", 10000/t; else print "∞"; }') docs/s"
