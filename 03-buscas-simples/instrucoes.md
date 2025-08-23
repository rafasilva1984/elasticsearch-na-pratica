# 🔎 Etapa 03 – Buscas Simples no Elasticsearch

Nesta etapa vamos explorar diferentes formas de consultar os dados do índice **infra-hosts**, utilizando queries básicas que simulam perguntas do dia a dia em infraestrutura.

---

## 1) Match Query – buscar por serviço
**cURL**
```bash
curl -X POST "http://localhost:9200/infra-hosts/_search?pretty"   -H 'Content-Type: application/json' -d '{
  "query": { "match": { "servico": "api" } }
}'
```

**Dev Tools**
```json
GET infra-hosts/_search
{
  "query": { "match": { "servico": "api" } }
}
```

---

## 2) Range Query – valores numéricos (CPU)
**cURL**
```bash
curl -X POST "http://localhost:9200/infra-hosts/_search?pretty"   -H 'Content-Type: application/json' -d '{
  "query": { "range": { "cpu": { "gte": 85 } } }
}'
```

**Dev Tools**
```json
GET infra-hosts/_search
{
  "query": { "range": { "cpu": { "gte": 85 } } }
}
```

---

## 3) Bool Query – status e CPU combinados
**cURL**
```bash
curl -X POST "http://localhost:9200/infra-hosts/_search?pretty"   -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "must": [
        { "match": { "status": "warning" } },
        { "range": { "cpu": { "gte": 85 } } }
      ]
    }
  }
}'
```

**Dev Tools**
```json
GET infra-hosts/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "status": "warning" } },
        { "range": { "cpu": { "gte": 85 } } }
      ]
    }
  }
}
```

---

## 4) Paginação – `from` e `size`
**Dev Tools**
```json
GET infra-hosts/_search
{
  "from": 10,
  "size": 20,
  "query": { "match_all": {} }
}
```

---

## 5) Campos específicos – `_source`
**Dev Tools**
```json
GET infra-hosts/_search
{
  "_source": ["host","cpu"],
  "query": { "match": { "status": "warning" } }
}
```

---

## 6) Ordenação – `sort` por CPU
**Dev Tools**
```json
GET infra-hosts/_search
{
  "size": 5,
  "sort": [{ "cpu": "desc" }],
  "query": { "match_all": {} }
}
```

---

## 7) Filtro de datas – `@timestamp`
**Dev Tools**
```json
GET infra-hosts/_search
{
  "query": {
    "range": { "@timestamp": { "gte": "2025-08-15", "lte": "2025-08-20" } }
  }
}
```

---

## 8) Bool avançado – must + filter
**Dev Tools**
```json
GET infra-hosts/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "servico": "database" } }
      ],
      "filter": [
        { "range": { "cpu": { "gte": 85 } } },
        { "term": { "status": "warning" } }
      ]
    }
  }
}
```

---

## 9) Exibir `_score` (relevância)
**Dev Tools**
```json
GET infra-hosts/_search
{
  "query": { "match": { "servico": "api" } }
}
```

---

## 10) Exercícios práticos
1. Buscar hosts do serviço `database`.  
2. Buscar hosts com memória acima de 90%.  
3. Listar os 5 hosts com maior CPU (`sort` + `size`).  
4. Combinar: `status=offline` AND `memoria>80`.  
5. Mostrar apenas campos `host` e `status` dos hosts em `warning`.  

---

Pronto! Agora você tem um conjunto completo de consultas básicas para praticar no Elasticsearch 🚀
