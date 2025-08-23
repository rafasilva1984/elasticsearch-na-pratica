# 📘 Elasticsearch na Prática – Guia Completo com Simulação Real de Infraestrutura

Este repositório é um guia prático para quem deseja aprender **Elasticsearch** simulando um cenário real de monitoramento de infraestrutura de TI.  

A proposta é simples: aprender na prática como usar Elasticsearch e Kibana com **dados realistas**, tudo com scripts prontos, pipelines e explicações claras.

---

## 🎯 Objetivo

Simular o monitoramento de servidores de uma empresa, com dados como:
- Nome do host
- Tipo de serviço
- Status do sistema (`online`, `warning`, `offline`)
- Uso de CPU e memória (%)
- Timestamps realistas distribuídos em **agosto/2025**

---

## 🧱 Estrutura do Projeto

| Pasta                      | Conteúdo                                                                 |
|---------------------------|--------------------------------------------------------------------------|
| `01-instalacao/`          | Subida do Elasticsearch e Kibana com Docker                             |
| `02-indexacao-basica/`    | Criação do índice `infra-hosts` e ingestão de **10.000 documentos**      |
| `03-buscas-simples/`      | Consultas básicas com `match`, `range` e `bool`                         |
| `04-filtros-e-analise/`   | Filtros booleanos e análises textuais                                   |
| `05-visualizacao-kibana/` | Criação de dashboards no Kibana                                          |
| `docs/`                   | Guia rápido e desafio prático final                                     |

---

## 🚀 Passo a Passo Completo

### 🧩 1. Clonar o repositório
```bash
git clone https://github.com/rafasilva1984/elasticsearch-na-pratica.git
cd elasticsearch-na-pratica
```

---

### 🐳 2. Subir o ambiente com Docker
```bash
cd 01-instalacao
docker compose up -d
```

Acesse:
- Elasticsearch → [http://localhost:9200](http://localhost:9200)
- Kibana → [http://localhost:5601](http://localhost:5601)

⚠️ Se usar `docker-compose` v2+, a chave `version:` é opcional e pode ser removida dos YAMLs.

---

### 📥 3. Indexar os dados simulados

Agora você pode escolher **duas formas de ingestão**:

#### 🔹 A) Via Bulk cURL (mais rápido)
```bash
cd ../02-indexacao-basica
chmod +x ingestar-bulk.sh
./ingestar-bulk.sh
```

Esse script:
- Cria o índice `infra-hosts` com mappings básicos
- Desliga `refresh_interval` durante o bulk
- Ingere **10.000 documentos**
- Reativa `refresh` ao final

#### 🔹 B) Via Logstash (mais flexível)
Se quiser transformar/validar os dados na entrada, use Logstash:

```bash
cd ../01-instalacao
docker compose up -d logstash
docker logs -f logstash
```

Arquivos envolvidos:
- `02-indexacao-basica/dados-10000-ago-2025-logstash.ndjson`
- `02-indexacao-basica/logstash.conf`
- `01-instalacao/docker-compose.override.yml`

---

### 🔎 4. Validar a ingestão

#### Via cURL
```bash
# Contagem total (esperado: 10000)
curl -s "http://localhost:9200/infra-hosts/_count?pretty"

# Amostra (5 docs mais recentes)
curl -s -X POST "http://localhost:9200/infra-hosts/_search?pretty" -H 'Content-Type: application/json' -d '{
  "size": 5,
  "sort": [{ "@timestamp": "desc" }]
}'
```

#### Via Kibana (Dev Tools)
```json
GET infra-hosts/_count

GET infra-hosts/_search
{
  "size": 5,
  "sort": [{ "@timestamp": "desc" }]
}
```

---

### 🔎 5. Realizar buscas simples e avançadas
A partir da **Aula 03**, explore queries com `match`, `range` e `bool`:

```bash
curl -X POST "http://localhost:9200/infra-hosts/_search"   -H 'Content-Type: application/json' -d @03-buscas-simples/query-match.json
```

Mais exemplos em `03-buscas-simples/`.

---

### 🧠 6. Trabalhar com filtros e análise de texto
Exemplos em `04-filtros-e-analise/`.

---

### 📊 7. Criar dashboards no Kibana
Exemplos em `05-visualizacao-kibana/`.

---

## 🧠 Desafio Final

📁 `docs/desafio-pratico.md`

Responda:
- Quais serviços têm mais hosts em `warning`?
- Qual a média de CPU por serviço?
- Quais são os hosts mais críticos?

✅ Poste no LinkedIn e marque **@Rafael Silva**  
✅ Compartilhe seu dashboard e insights!

---

## 🛠️ Troubleshooting

- **Erro `^M` em scripts no Windows:**  
  Use `dos2unix *.sh`
- **Erro de rede `elastic` no Docker Compose:**  
  Garanta que o bloco `networks:` esteja definido no `docker-compose.override.yml`.
- **Bulk `400 error`:**  
  Confirme que está postando em `/$INDEX/_bulk` e não em `/_bulk`.

---

## 📬 Dúvidas ou sugestões?

Conecte-se comigo:

- GitHub: [rafasilva1984](https://github.com/rafasilva1984)
- LinkedIn: [rafael-silva-leader-coordenador](https://linkedin.com/in/rafael-silva-leader-coordenador)
- Medium: [rafaelldasilva1984](https://medium.com/@rafaelldasilva1984)
- YouTube: [Observabilidade na Prática](https://www.youtube.com/@ObservabilidadenaPrática)

---

**Projeto criado por Rafael Silva – Elasticsearch e Observabilidade na Prática.**
