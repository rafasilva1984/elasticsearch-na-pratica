# 📘 Elasticsearch na Prática – Curso Completo com Simulação Real de Infraestrutura

Este repositório é um guia prático para quem deseja aprender Elasticsearch simulando um cenário real de monitoramento de infraestrutura de TI.  

A proposta é simples: aprender na prática como usar Elasticsearch e Kibana com dados realistas, tudo com scripts prontos e explicações claras.

---

## 🎯 Objetivo

Simular o monitoramento de servidores de uma empresa, com dados como:
- Nome do host
- Tipo de serviço
- Status do sistema
- Uso de CPU e memória
- Timestamp realista (mês 07/2025)

---

## 🧱 Estrutura do Projeto

| Pasta                      | Conteúdo                                                                 |
|---------------------------|--------------------------------------------------------------------------|
| `01-instalacao/`          | Subida do Elasticsearch e Kibana com Docker                             |
| `02-indexacao-basica/`    | Criação do índice `infra-hosts` e ingestão de 100 documentos             |
| `03-buscas-simples/`      | Consultas com `match`, `range` e `bool`                                  |
| `04-filtros-e-analise/`   | Filtros booleanos e análises textuais                                    |
| `05-visualizacao-kibana/` | Criação de dashboards                                                    |
| `docs/`                   | Guia rápido e desafio prático final                                      |

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
docker-compose up -d
```

Acesse:
- Elasticsearch: http://localhost:9200
- Kibana: http://localhost:5601

---

### 📥 3. Indexar os dados simulados
```bash
cd ../02-indexacao-basica
bash ingestar-hosts.sh
```

Isso criará o índice `infra-hosts` com 100 documentos simulando hosts de servidores com diferentes serviços, status, uso de CPU/memória e datas no mês 07/2025.

---

### 🔎 4. Realizar buscas simples e avançadas

- Match por serviço:
```bash
curl -X POST "http://localhost:9200/infra-hosts/_search" -H 'Content-Type: application/json' -d @03-buscas-simples/query-match.json
```

- Range por CPU:
```bash
curl -X POST "http://localhost:9200/infra-hosts/_search" -H 'Content-Type: application/json' -d @03-buscas-simples/query-range.json
```

- Busca complexa:
```bash
cd ../03-buscas-simples
bash queries-complexas.sh
```

---

### 🧠 5. Trabalhar com filtros e análise de texto

- Combine múltiplas condições com `bool`, `must`, `must_not`, etc.
- Exemplos em `04-filtros-e-analise/exemplo-bool-query.json`

---

### 📊 6. Criar dashboards no Kibana

1. Acesse: http://localhost:5601
2. Vá para Visualize Library
3. Crie gráficos com:
   - Total de hosts por status
   - CPU médio por serviço
   - Hosts críticos com alta memória
4. Salve como Dashboard `infra-overview`

---

## 🧠 Desafio Final

📁 `docs/desafio-pratico.md`

Responda perguntas como:

- Quais serviços estão com mais hosts em estado `warning`?
- Qual a média de uso de CPU por serviço?
- Quem são os hosts mais críticos da infraestrutura?

✅ Poste seu resultado no LinkedIn e marque **@Rafael Silva**  
✅ Compartilhe seu dashboard e insights com a comunidade!

---

## 📬 Dúvidas ou sugestões?

Conecte-se comigo:

- GitHub: [rafasilva1984](https://github.com/rafasilva1984)
- LinkedIn: [rafael-silva-leader-coordenador](https://linkedin.com/in/rafael-silva-leader-coordenador)

---

**Projeto criado por Rafael Silva – Elasticsearch e Observabilidade na Prática.**
