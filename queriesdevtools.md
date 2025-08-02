# 📒 Queries no Dev Tools – Elasticsearch na Prática

Este guia contém todas as queries divididas por módulo para serem utilizadas no **Dev Tools do Kibana**.

---

## 🧩 01 - Verificando o Cluster

```json
GET /
```

Retorna o status do Elasticsearch.

---

## 📥 02 - Criação de índice `infra-hosts` com mapping

```json
PUT infra-hosts
{
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
}
```

---

## 🔎 03 - Consultas básicas

### Match

```json
GET infra-hosts/_search
{
  "query": {
    "match": {
      "servico": "api"
    }
  }
}
```

### Range

```json
GET infra-hosts/_search
{
  "query": {
    "range": {
      "cpu": {
        "gte": 80
      }
    }
  }
}
```

---

## 🧠 04 - Consultas booleanas

```json
GET infra-hosts/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "status": "online" } },
        { "range": { "memoria": { "gt": 75 } } }
      ],
      "must_not": [
        { "match": { "servico": "database" } }
      ]
    }
  }
}
```

---

## 📊 05 - Agregações para dashboards

### CPU médio por serviço

```json
GET infra-hosts/_search
{
  "size": 0,
  "aggs": {
    "media_cpu_por_servico": {
      "terms": { "field": "servico" },
      "aggs": {
        "media_cpu": {
          "avg": { "field": "cpu" }
        }
      }
    }
  }
}
```

### Quantidade de hosts por status

```json
GET infra-hosts/_search
{
  "size": 0,
  "aggs": {
    "status_hosts": {
      "terms": {
        "field": "status"
      }
    }
  }
}
```

---

## 📅 06 - Filtrar por data (julho de 2025)

```json
GET infra-hosts/_search
{
  "query": {
    "range": {
      "@timestamp": {
        "gte": "2025-07-01",
        "lte": "2025-07-31"
      }
    }
  }
}
```

---

✅ Copie, cole e execute estas queries no Dev Tools do Kibana (ícone de terminal na barra lateral esquerda).

