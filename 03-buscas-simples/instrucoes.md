# 🔎 Etapa 03 – Buscas Simples no Elasticsearch

Nesta etapa vamos aprender a executar buscas básicas no índice **infra-hosts**, explorando queries `match`, `range` e `bool`.  
Essas consultas permitem responder perguntas do dia a dia, como identificar serviços em `warning` ou servidores com CPU acima de 85%.

---

## 🚀 Passos

### 1) Match Query – buscar por serviço
Exemplo: encontrar todos os hosts rodando o serviço `api`.

**cURL:**
```bash
curl -X POST "http://localhost:9200/infra-hosts/_search?pretty"   -H 'Content-Type: application/json' -d '{
  "query": { "match": { "servico": "api" } }
}'
```

**Dev Tools:**
```json
GET infra-hosts/_search
{
  "query": { "match": { "servico": "api" } }
}
```

---

### 2) Range Query – valores numéricos
Exemplo: encontrar hosts com CPU acima de 85%.

**cURL:**
```bash
curl -X POST "http://localhost:9200/infra-hosts/_search?pretty"   -H 'Content-Type: application/json' -d '{
  "query": { "range": { "cpu": { "gte": 85 } } }
}'
```

**Dev Tools:**
```json
GET infra-hosts/_search
{
  "query": {
    "range": { "cpu": { "gte": 85 } }
  }
}
```

---

### 3) Bool Query – combinação de condições
Exemplo: hosts em `warning` com CPU acima de 85%.

**cURL:**
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

**Dev Tools:**
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

## 📊 Interpretando os resultados
- **hits.total.value** → número total de documentos encontrados.  
- **_source** → conteúdo do documento.  
- É possível limitar e ordenar os resultados:

**Dev Tools:**
```json
GET infra-hosts/_search
{
  "size": 5,
  "sort": [{ "@timestamp": "desc" }],
  "query": { "match": { "status": "warning" } }
}
```

---

## ✅ Exercícios práticos
1. Buscar hosts do serviço `database`.  
2. Buscar hosts com memória acima de 90%.  
3. Combinar: `status=offline` AND `memoria>80`.  

---

Pronto! Agora você já domina as consultas básicas do Elasticsearch para explorar seus dados de infraestrutura 🚀
