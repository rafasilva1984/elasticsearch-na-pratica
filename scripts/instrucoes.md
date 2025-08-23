# ⏱️ Medir e comparar tempos de indexação (Bulk vs Logstash)

Este guia mostra como **medir** o tempo para indexar **10.000 documentos** usando os dois caminhos do projeto:
- **Bulk cURL** (mais rápido)
- **Logstash** (mais flexível; com `_id` determinístico e `ingest: "logstash"`)

> Cada método usa um **índice diferente** para comparação justa: `infra-hosts-bulk` e `infra-hosts-logstash`.

---

## 1) Pré‑requisitos
- Stack rodando (ES + Kibana).  
- Scripts executáveis: `dos2unix scripts/*.sh && chmod +x scripts/*.sh`

---

## 2) Medir Bulk
```bash
cd scripts
./medir-bulk.sh
```
Saída esperada (exemplo):
```
→ Bulk | ES_URL=http://localhost:9200 INDEX=infra-hosts-bulk FILE=../02-indexacao-basica/dados-10000-ago-2025.ndjson
✅ Tempo Bulk: 7s  | docs no índice: 10000
📈 Throughput: 1428.6 docs/s
```

---

## 3) Medir Logstash
```bash
cd scripts
./medir-logstash.sh
```
Saída esperada (exemplo):
```
→ Logstash | ES_URL=http://localhost:9200 INDEX=infra-hosts-logstash DATA_FILE=../02-indexacao-basica/dados-10000-ago-2025-logstash.ndjson
⏱  Medindo... alvo=10000 docs, timeout=300s
✅ Tempo Logstash: 28s  | docs no índice: 10000
📈 Throughput: 357.1 docs/s
```

> O script sobe o `logstash`, faz **polling** do `_count` até atingir 10k ou **timeout**, mede o tempo e derruba o serviço para a próxima rodada.

---

## 4) Dicas de comparação justa
- Teste com a máquina “quieta” (sem outras cargas).  
- Use **um shard e 0 réplicas** durante ingestão (já configurado nos scripts).  
- Execute **2–3 rodadas** e use a **média**.  
- Após o bulk, o tempo tende a ser menor que o do Logstash, pois não há pipeline Ruby e backpressure de output.

---

## 5) Consultas rápidas (Dev Tools)

### A) Contagem e amostra
```json
GET infra-hosts-bulk/_count
GET infra-hosts-logstash/_count

GET infra-hosts-bulk/_search
{
  "size": 1, "sort": [{ "@timestamp": "desc" }]
}
GET infra-hosts-logstash/_search
{
  "size": 1, "sort": [{ "@timestamp": "desc" }]
}
```

### B) Verificar `_id` determinístico (Logstash)
```json
GET infra-hosts-logstash/_search
{
  "size": 1,
  "_source": ["host","@timestamp","ingest"]
}
```
Você verá `_id` no formato `srv-...@2025-08-...` (host + timestamp).

---

Pronto! Agora você consegue **comparar tempos e throughput** de Bulk vs Logstash no seu ambiente.
