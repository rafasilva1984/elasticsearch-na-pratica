# 📥 Etapa 02 – Indexação de 10.000 Hosts de Infraestrutura

Nesta etapa você irá criar e popular um índice Elasticsearch chamado **infra-hosts** com **10.000 documentos simulados** de servidores (hosts).  
Os dados possuem timestamps distribuídos ao longo de **agosto/2025**.

---

## 🚀 Passos

### 1. Executar o script de ingestão
Crie o índice com mapping básico e popule com os hosts:

```bash
bash ingestar-hosts.sh
```

Esse script cria o índice `infra-hosts` e insere os documentos contidos em `dados-hosts.json`.

---

### 2. Verificar a ingestão

#### Usando cURL:
```bash
# Contar documentos no índice
curl -X GET "http://localhost:9200/infra-hosts/_count?pretty"

# Buscar alguns documentos
curl -X GET "http://localhost:9200/infra-hosts/_search?size=5&pretty"
```

#### Usando Kibana Dev Tools:
```json
GET infra-hosts/_count

GET infra-hosts/_search
{
  "size": 5
}
```

---

## 📊 Campos disponíveis
- `host`: identificador do servidor (ex: srv-web-01)
- `servico`: serviço rodando (ex: api, database, webserver)
- `status`: estado do serviço (online, offline, warning)
- `cpu`: uso de CPU (%)
- `memoria`: uso de memória (%)
- `@timestamp`: data/hora da coleta (agosto/2025)

---

## ✅ Checklist de validação
1. O índice `infra-hosts` foi criado corretamente (`GET _cat/indices?v`).
2. Existem **10.000 documentos** no índice (`_count`).
3. As queries de busca retornam registros com dados coerentes de agosto/2025.

---

Pronto! Agora você tem um dataset robusto para simular cenários reais de **infraestrutura** no Elasticsearch 🚀
