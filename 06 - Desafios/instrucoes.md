# 🎯 Aula 06 – Desafios Práticos de Observabilidade no Elasticsearch

Chegou a hora de colocar em prática tudo que você aprendeu nas aulas anteriores!  
Nesta etapa, você vai aplicar seus conhecimentos de indexação, consultas, filtros e dashboards para resolver **desafios reais** inspirados no dia a dia de um time de observabilidade.  

---

## 🚀 Desafios

### 🔹 Desafio 1 — Saúde da Infraestrutura
Crie um dashboard no Kibana que mostre:
- Quantidade total de hosts por **status** (online, warning, offline).
- Um gráfico de **linha do tempo** para acompanhar o uso de CPU ao longo de Agosto/2025.
- Uma tabela com os **Top 10 hosts** por uso de memória.

➡️ Dica: combine pelo menos 3 visualizações diferentes em um único painel.

---

### 🔹 Desafio 2 — Queries avançadas
No Dev Tools, crie queries para responder:
1. Quais hosts estão com `status = offline` e `cpu > 80`?
2. Liste apenas os campos `host` e `status` para todos os hosts em warning.
3. Mostre os **5 hosts mais críticos** ordenados por CPU.
4. Qual a **média de CPU por serviço**?

➡️ Use combinações de `bool`, `range`, `sort`, `size` e `_source`.

---

### 🔹 Desafio 3 — Comparando origens de ingestão
Nos exercícios anteriores, aprendemos a usar **Bulk** e **Logstash**.  
Agora, crie queries para comparar:
- Quantos documentos vieram do Bulk.
- Quantos documentos vieram do Logstash.
- Um gráfico de barras mostrando a distribuição de status (online, warning, offline) **separado por origem**.

---

### 🔹 Desafio 4 — Explorando tendências
Monte uma visualização de linha do tempo que mostre:
- Uso médio de CPU **por serviço**.
- Compare API, Database e Webserver ao longo do tempo.
- Aplique filtros para mostrar apenas hosts em warning.

---

## 📝 Resolução dos Desafios

### ✅ Desafio 1 — Dashboard
- Pizza: `status` em Slices.
- Linha do tempo: `@timestamp` vs CPU média.
- Tabela: `host`, `servico`, `status`, `cpu`, `memoria` → ordenado por memória.

Salve como **infra-desafio-dashboard-06**.

---

### ✅ Desafio 2 — Queries

```json
# 1) Offline e CPU > 80
GET infra-hosts/_search
{
  "query": {
    "bool": {
      "must": [
        { "term": { "status": "offline" } },
        { "range": { "cpu": { "gte": 80 } } }
      ]
    }
  }
}

# 2) Campos host e status
GET infra-hosts/_search
{
  "_source": ["host","status"],
  "query": { "term": { "status": "warning" } }
}

# 3) Top 5 hosts críticos
GET infra-hosts/_search
{
  "size": 5,
  "sort": [{ "cpu": "desc" }],
  "query": { "match_all": {} }
}

# 4) Média de CPU por serviço
GET infra-hosts/_search
{
  "size": 0,
  "aggs": {
    "cpu_por_servico": { "avg": { "field": "cpu" } }
  }
}
```

---

### ✅ Desafio 3 — Comparando origens

```json
# Contagem por Bulk
GET infra-hosts/_count
{
  "query": { "term": { "ingest": "bulk" } }
}

# Contagem por Logstash
GET infra-hosts/_count
{
  "query": { "term": { "ingest": "logstash" } }
}
```

No Kibana, use `ingest` no eixo X e `status` em Slices para ver a distribuição por origem.

---

### ✅ Desafio 4 — Tendências
- Linha do tempo com `@timestamp` no eixo X.
- `cpu` média no eixo Y.
- Split por `servico`.
- Filtro `status: warning`.

---

## 📌 Compartilhe seus resultados

Agora é com você 🚀  
Monte os dashboards, execute as queries e compartilhe os resultados no LinkedIn ou outras redes sociais.  

➡️ Marque **@Rafael Silva** para que eu possa acompanhar seu progresso e celebrar junto!  
➡️ Traga também suas dúvidas, ideias de melhoria e novos desafios que gostaria de ver nas próximas edições.

---

**Conectou, buscou e achou! 🚀**
