# 📥 Etapa 02 – Indexação de 10.000 Hosts de Infraestrutura

Nesta etapa você irá criar e popular um índice Elasticsearch chamado **infra-hosts** com **10.000 documentos simulados** de servidores (hosts).  
Os dados possuem timestamps distribuídos ao longo de **agosto/2025**.

---

## 🚀 Passos

### 1A) Ingestão rápida (Bulk via cURL)
Use o script otimizado de bulk (converte NDJSON → formato Bulk em stream):

```bash
# dar permissão
chmod +x ingestar-bulk.sh

# executar com defaults:
# ES_URL=http://localhost:9200, INDEX=infra-hosts, FILE=dados-10000-ago-2025.ndjson
./ingestar-bulk.sh

# ou customizando:
ES_URL=http://localhost:9200 INDEX=infra-hosts FILE=dados-10000-ago-2025.ndjson ./ingestar-bulk.sh
```

> O script recria o índice (settings + mappings), desliga o `refresh` durante o bulk e reativa ao final.

---

### 1B) Ingestão alternativa (Logstash)
Se preferir transformar/validar na entrada, use o Logstash com **arquivo dedicado**:

- Arquivo de dados: `02-indexacao-basica/dados-10000-ago-2025-logstash.ndjson`  
- Pipeline: `02-indexacao-basica/logstash.conf`  
- Compose override: `docker-compose.override.yml` (já mapeando os caminhos acima)

Suba o Logstash junto do stack:

```bash
docker compose up -d logstash
docker logs -f logstash   # acompanhe a ingestão (pontos no log)
```

No pipeline:
- Cada documento recebe um **_id determinístico** (`host@timestamp`) → a ingestão é idempotente.  
- É adicionado o campo `"ingest": "logstash"` → permitindo diferenciar dados do Logstash dos dados do Bulk.  

> Por padrão, o pipeline indexa no índice `infra-hosts`.  
> Para rodar sem Logstash, suba apenas `elasticsearch` e `kibana`.

---

## 2) Verificar a ingestão

### Usando cURL:
```bash
# Contagem total (esperado: 10000 se usou só um método; ~20000 se usou Bulk + Logstash)
curl -s "http://localhost:9200/infra-hosts/_count?pretty"

# Amostra (5 docs), ordenados por tempo desc
curl -s -H 'Content-Type: application/json' -X POST "http://localhost:9200/infra-hosts/_search?pretty" -d '{
  "size": 5,
  "sort": [{"@timestamp":"desc"}],
  "query": { "match_all": {} }
}'

# Apenas agosto/2025 (filtro de data)
curl -s -H 'Content-Type: application/json' -X POST "http://localhost:9200/infra-hosts/_search?pretty" -d '{
  "size": 0,
  "query": {
    "range": { "@timestamp": { "gte": "2025-08-01", "lte": "2025-08-31T23:59:59" } }
  }
}'

# Apenas documentos do Logstash
curl -s -H 'Content-Type: application/json' -X POST "http://localhost:9200/infra-hosts/_search?pretty" -d '{
  "size": 0,
  "query": { "term": { "ingest": "logstash" } }
}'
```

### Usando Kibana Dev Tools:
```json
GET infra-hosts/_count

GET infra-hosts/_search
{
  "size": 5,
  "sort": [{ "@timestamp": "desc" }],
  "query": { "match_all": {} }
}

GET infra-hosts/_search
{
  "size": 0,
  "query": {
    "range": { "@timestamp": { "gte": "2025-08-01", "lte": "2025-08-31T23:59:59" } }
  }
}

# Apenas documentos do Logstash
GET infra-hosts/_search
{
  "size": 0,
  "query": { "term": { "ingest": "logstash" } }
}
```

---

## 📊 Campos disponíveis
- `host`: identificador do servidor (ex: `srv-web-00001`)
- `servico`: serviço (ex: `webserver`, `api`, `database`, `auth-service`, `cache`, `queue`, `search`, `payments`, `analytics`)
- `status`: estado do serviço (`online`, `warning`, `offline`)
- `cpu`: uso de CPU (%)
- `memoria`: uso de memória (%)
- `@timestamp`: data/hora da coleta (agosto/2025)
- `ingest`: origem da ingestão (`bulk` ou `logstash`)

---

## ✅ Checklist de validação
1. O índice `infra-hosts` foi criado corretamente (`GET _cat/indices?v`).  
2. Existem **10.000 documentos** no índice (se usou apenas um método) ou ~20.000 (se rodou Bulk + Logstash).  
3. O filtro de data retorna apenas registros de **agosto/2025**.  
4. O campo `ingest` permite diferenciar a origem dos documentos.  
5. (Se usar Logstash) os logs mostram progresso e finalização sem erros; a contagem bate com o esperado.

---

## 🛠️ Boas práticas e dicas extras

- **Validação do dataset**  
  Antes de ingerir, confira se o arquivo tem de fato 10.000 linhas:  
  ```bash
  wc -l dados-10000-ago-2025.ndjson
  ```

- **Evite duplicação de documentos**  
  Se não definir `_id`, o Elasticsearch gera automaticamente um UUID.  
  → No Bulk isso pode duplicar docs caso rode 2x o mesmo arquivo.  
  → No Logstash o `_id` foi configurado como `host@timestamp` → garante idempotência.

- **Controle de performance**  
  Durante ingestão em massa, é comum desligar o `refresh_interval` e usar `number_of_replicas=0`.  
  Isso já está implementado nos scripts.  
  Depois da ingestão, o `refresh` volta ao normal para as buscas funcionarem.

- **Debug de erros comuns**  
  - `400 Bad Request` → formato NDJSON errado (verifique que cada doc ocupa uma linha).  
  - `mapper_parsing_exception` → campo com tipo incorreto (ex.: string em campo integer).  
  - Dica: rode o bulk com `--verbose` ou verifique o log do Logstash para ver quais docs falharam.

- **Primeira visualização no Kibana**  
  Após a ingestão, vá em **Kibana → Discover** e selecione o data view `infra-hosts`.  
  Teste filtros rápidos:  
  - `status:warning`  
  - `cpu > 90`  
  - `memoria > 85`

---

Pronto! Agora você tem a ingestão por **Bulk** (rápida) e por **Logstash** (flexível e idempotente), ambas apontando para datasets distintos — perfeito para demonstrar dois fluxos comuns de indexação no dia a dia, com boas práticas aplicadas.
