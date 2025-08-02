# 📒 Queries no Dev Tools – Elasticsearch na Prática

Este guia contém todas as queries utilizadas durante o curso, organizadas por módulo, com perguntas claras e comandos prontos para execução no **Dev Tools do Kibana**.

---

## 🧩 01 - Verificando o Cluster

🔹 **Qual é o status do cluster Elasticsearch?**

```json
GET /
```

---

## 📥 02 - Criação e Estrutura do Índice

🔹 **Como criar o índice `infra-hosts` com campos esperados?**

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

## 🔎 03 - Consultas Simples e Complexas

🔹 **Quais hosts oferecem serviço `api`?**

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

🔹 **Quais hosts estão com uso de CPU maior ou igual a 80%?**

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

🔹 **Quais hosts estão com status `warning` e CPU acima de 85%?**

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

## 🧠 04 - Filtros e Análise

🔹 **Quais hosts estão online com memória acima de 75%, excluindo bancos de dados?**

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

🔹 **Como funciona a análise de texto com `standard analyzer`?**

```json
POST /_analyze
{
  "analyzer": "standard",
  "text": "srv-api-01 entrou em estado warning"
}
```

---

## 📊 05 - Agregações e Dashboards

🔹 **Qual a média de uso de CPU por tipo de serviço?**

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

🔹 **Quantos hosts existem por status (online, offline, warning)?**

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

🔹 **Mostrar os hosts com maior uso de memória**

```json
GET infra-hosts/_search
{
  "size": 5,
  "sort": [
    { "memoria": "desc" }
  ]
}
```

---

## 📅 06 - Filtro por Período (julho de 2025)

🔹 **Quais eventos ocorreram entre 01 e 31 de julho de 2025?**

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

✅ **Dica**: Cole qualquer uma dessas queries no **Dev Tools** do Kibana para executá-las diretamente.  
Acompanhe os resultados e monte seus dashboards com base nesses dados!

