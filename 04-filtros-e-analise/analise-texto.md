# 🧠 Análise de texto (analyzers) – quando usar `text` vs `keyword`

- **`keyword`**: não tokeniza (bom para exato: `status`, `servico`, `host`).  
- **`text`**: tokeniza (bom para busca textual: descrições, logs).  
- Você pode ter **multi-fields**: `descricao` como `text` + `descricao.keyword` para exato.

## 1) Usando a API `_analyze` (sem criar índice)
**Dev Tools**
```json
POST _analyze
{
  "analyzer": "standard",
  "text": "Falha ao conectar ao banco de dados do serviço de pagamentos"
}
```

## 2) Índice de laboratório com analisador em PT-BR
Crie um índice com um analisador customizado e um campo `descricao`:

**Dev Tools**
```json
PUT lab-analise
{
  "settings": {
    "analysis": {
      "filter": {
        "portuguese_stop": { "type": "stop", "stopwords": "_portuguese_" },
        "portuguese_stemmer": { "type": "stemmer", "language": "light_portuguese" }
      },
      "analyzer": {
        "pt_custom": {
          "tokenizer": "standard",
          "filter": ["lowercase", "asciifolding", "portuguese_stop", "portuguese_stemmer"]
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "descricao": { "type": "text", "analyzer": "pt_custom", "fields": { "keyword": { "type": "keyword" } } }
    }
  }
}
```

Indexe alguns exemplos e pesquise:

```json
POST lab-analise/_doc
{ "descricao": "Falha ao conectar ao banco de dados de pagamentos" }

POST lab-analise/_doc
{ "descricao": "Serviço de pagamentos: conexão restabelecida com banco" }

GET lab-analise/_search
{
  "query": { "match": { "descricao": "pagamentos banco" } }
}
```

Veja o efeito de stemmer/stopwords (“pagamento/pagamentos”) e remoção de palavras comuns.

> Dica: para campos `keyword` com variações de caixa/acentos, use **normalizer** (ex.: lowercase + asciifolding) ao criar o índice.
