# 🔎 Filtros práticos com `bool` (filter/must/must_not/should)

## 1) Filtro de “críticos” (status=warning AND cpu>=85) para agosto/2025
**cURL**
```bash
curl -s -H 'Content-Type: application/json' -X POST "http://localhost:9200/infra-hosts/_search?pretty" -d '{
  "size": 10,
  "query": {
    "bool": {
      "filter": [
        { "term": { "status": "warning" } },
        { "range": { "cpu": { "gte": 85 } } },
        { "range": { "@timestamp": { "gte": "2025-08-01", "lte": "2025-08-31T23:59:59" } } }
      ]
    }
  }
}'
```

**Dev Tools**
```json
GET infra-hosts/_search
{
  "size": 10,
  "query": {
    "bool": {
      "filter": [
        { "term": { "status": "warning" } },
        { "range": { "cpu": { "gte": 85 } } },
        { "range": { "@timestamp": { "gte": "2025-08-01", "lte": "2025-08-31T23:59:59" } } }
      ]
    }
  }
}
```

---

## 2) Excluir serviços (must_not) e ordenar por CPU desc
**cURL**
```bash
curl -s -H 'Content-Type: application/json' -X POST "http://localhost:9200/infra-hosts/_search?pretty" -d '{
  "size": 5,
  "sort": [{ "cpu": "desc" }],
  "query": {
    "bool": {
      "filter": [
        { "range": { "cpu": { "gte": 80 } } }
      ],
      "must_not": [
        { "term": { "servico": "cache" } },
        { "term": { "servico": "queue" } }
      ]
    }
  }
}'
```

**Dev Tools**
```json
GET infra-hosts/_search
{
  "size": 5,
  "sort": [{ "cpu": "desc" }],
  "query": {
    "bool": {
      "filter": [
        { "range": { "cpu": { "gte": 80 } } }
      ],
      "must_not": [
        { "term": { "servico": "cache" } },
        { "term": { "servico": "queue" } }
      ]
    }
  }
}
```

---

## 3) `should` com preferência (mínimo 1 deve bater)
**cURL**
```bash
curl -s -H 'Content-Type: application/json' -X POST "http://localhost:9200/infra-hosts/_search?pretty" -d '{
  "query": {
    "bool": {
      "should": [
        { "term": { "servico": "api" } },
        { "term": { "servico": "webserver" } }
      ],
      "minimum_should_match": 1,
      "filter": [
        { "range": { "@timestamp": { "gte": "2025-08-01", "lte": "2025-08-31T23:59:59" } } }
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
      "should": [
        { "term": { "servico": "api" } },
        { "term": { "servico": "webserver" } }
      ],
      "minimum_should_match": 1,
      "filter": [
        { "range": { "@timestamp": { "gte": "2025-08-01", "lte": "2025-08-31T23:59:59" } } }
      ]
    }
  }
}
```

> Dica: `should` altera o **_score** (relevância); quando há `must`/`filter`, `should` melhora a ordem dos resultados.

---

## 4) `post_filter` (filtrar só o resultado, mantendo agregações)
> Útil quando você quer **aggs do conjunto amplo** mas **exibir** só uma fatia.

**Dev Tools (com agg por status)**
```json
GET infra-hosts/_search
{
  "size": 5,
  "aggs": {
    "por_status": {
      "terms": { "field": "status" }
    }
  },
  "query": {
    "bool": {
      "filter": [
        { "range": { "@timestamp": { "gte": "2025-08-01", "lte": "2025-08-31T23:59:59" } } }
      ]
    }
  },
  "post_filter": {
    "term": { "status": "warning" }
  }
}
```
