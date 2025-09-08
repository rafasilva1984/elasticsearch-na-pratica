# 📘 Aula 04 – Filtros e Análise

Nesta aula vamos aprender a combinar condições de busca com o **bool query** (`must`, `filter`, `must_not`, `should`) e também entender a diferença entre **campos textuais** e **campos exatos** (`text` vs `keyword`).  
Além disso, vamos explorar o recurso `_analyze`, criar consultas práticas e finalizar com exercícios.

---

## 🧩 Conceitos básicos

- **must** → condição obrigatória que impacta o score (relevância).  
- **filter** → condição obrigatória que **não impacta o score** (mais rápido e cacheável).  
- **should** → condição opcional que dá “peso extra” no score.  
- **must_not** → exclui documentos que atendem à condição.  

⚡ Dica:  
- Use **filter** em dashboards ou relatórios (quando não precisa de score).  
- Use **must** quando a relevância da busca importa (exemplo: busca textual).  

---

## 🔎 Exemplos práticos de filtros

### 1. Hosts em warning com CPU >= 85
```json
GET infra-hosts/_search
{
  "query": {
    "bool": {
      "filter": [
        { "term": { "status": "warning" } },
        { "range": { "cpu": { "gte": 85 } } }
      ]
    }
  }
}
```

### 2. Hosts críticos, mas sem os que estão offline
```json
GET infra-hosts/_search
{
  "query": {
    "bool": {
      "must":   [{ "range": { "cpu": { "gte": 70 } } }],
      "must_not":[{ "term": { "status": "offline" } }]
    }
  }
}
```

### 3. Priorizar `database` quando CPU >= 80
```json
GET infra-hosts/_search
{
  "query": {
    "bool": {
      "must":   [{ "range": { "cpu": { "gte": 80 } } }],
      "should": [{ "term": { "servico": "database" } }],
      "minimum_should_match": 0
    }
  }
}
```

---

## 📊 Análise de texto

O Elasticsearch trata **campos textuais** de forma diferente:

- **text** → passa por análise (tokenizer + filtros). Bom para busca de frases.  
- **keyword** → valor exato. Bom para filtros, ordenações e agregações.  

### 1. Usando `_analyze`
```json
POST _analyze
{
  "analyzer": "standard",
  "text": "Elasticsearch na Prática: Conectou, buscou e achou!"
}
```

👉 Resultado: mostra como o texto é quebrado em tokens.  
Exemplo: “Elasticsearch”, “na”, “prática”, “conectou”, “buscou”, “achou”.

### 2. Match (texto) vs Term (exato)
```json
# match em campo text
GET logs-app/_search
{
  "query": { "match": { "mensagem": "erro de conexão" } }
}

# term em campo keyword
GET infra-hosts/_search
{
  "query": { "term": { "status": "warning" } }
}
```

⚡ Regra de ouro:  
- Use **match** para `text`.  
- Use **term** para `keyword`.  

---

## 🧪 Casos práticos

### 1. Lista crítica limpa (CPU alta, mas não offline)
```json
GET infra-hosts/_search
{
  "size": 10,
  "sort": [{ "cpu": "desc" }],
  "query": {
    "bool": {
      "filter": [
        { "range": { "cpu": { "gte": 85 } } }
      ],
      "must_not": [
        { "term": { "status": "offline" } }
      ]
    }
  }
}
```

### 2. Dar peso extra para `database`
```json
GET infra-hosts/_search
{
  "size": 10,
  "query": {
    "bool": {
      "must":   [{ "range": { "cpu": { "gte": 80 } } }],
      "should": [{ "term": { "servico": "database" } }],
      "minimum_should_match": 0
    }
  }
}
```

### 3. Projeção enxuta (só os campos que interessam)
```json
GET infra-hosts/_search
{
  "_source": ["host","servico","status","cpu","memoria","@timestamp"],
  "size": 15,
  "sort": [{ "@timestamp": "desc" }],
  "query": {
    "bool": {
      "filter": [
        { "range": { "cpu": { "gte": 85 } } },
        { "range": { "memoria": { "gte": 90 } } }
      ]
    }
  }
}
```

---

## 📝 Exercícios

1. Buscar hosts **offline** com CPU >= 80.  
2. Listar o top 10 de memória para o serviço `api`.  
3. Rodar `_analyze` com a frase “Falha de conexão no serviço de pagamentos”.  
   - Compare o resultado usando os analisadores `standard` e `simple`.

---

## ✅ Conclusão

- Aprendemos a diferença entre **must, filter, should, must_not**.  
- Vimos como funciona a análise de texto.  
- Criamos queries práticas para infraestrutura.  
- Finalizamos com exercícios para fixar.  

👉 Na próxima aula, vamos levar tudo isso para o **Kibana**, criando dashboards visuais.  

Conectou, buscou e achou 🚀
