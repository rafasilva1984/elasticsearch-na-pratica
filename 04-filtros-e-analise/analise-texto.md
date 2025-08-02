# Análise de Texto

Embora os campos neste exemplo usem `keyword`, você pode usar `text` com `analyzers` personalizados para logs de mensagens, por exemplo.

Use `_analyze` para testar:
```json
POST /_analyze
{
  "analyzer": "standard",
  "text": "srv-api-01 entrou em estado warning"
}
```
