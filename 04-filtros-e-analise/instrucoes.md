# 🧩 Etapa 04 – Filtros e Análise (query vs filter, must/should/must_not e análise de texto)

Nesta etapa você aprende a:
- Usar `bool` com **`filter`** (sem score, cacheável) e `must` (com score).
- Combinar condições com `must_not` e `should` (+ `minimum_should_match`).
- Aplicar **filtros de tempo** e exclusões.
- Entender **análise de texto** (analyzers) e quando usar `keyword` vs `text`.

> Dataset: índice **infra-hosts** (10k docs de agosto/2025). Campos: `host` (keyword), `servico` (keyword), `status` (keyword), `cpu` (integer), `memoria` (integer), `@timestamp` (date), `ingest` (keyword).
