# 📘 Elasticsearch na Prática

Este repositório é uma introdução prática ao Elasticsearch, ideal para quem está começando na área de dados, observabilidade ou desenvolvimento de aplicações. A proposta é apresentar cada etapa de forma progressiva e acessível.

---

## 🚀 Etapa 01 – Instalação com Docker

Suba o Elasticsearch e o Kibana em sua máquina com apenas um comando utilizando Docker Compose.

### 📁 Estrutura
```
elasticsearch-na-pratica/
└── 01-instalacao/
    ├── docker-compose.yml
    ├── elasticsearch.yml
    ├── kibana.yml
    └── instrucoes.md
```

---

## 🔧 Pré-requisitos

- Docker instalado [Instruções aqui](https://docs.docker.com/get-docker/)
- Docker Compose instalado

---

## ▶️ Como usar

```bash
git clone https://github.com/seuusuario/elasticsearch-na-pratica.git
cd elasticsearch-na-pratica/01-instalacao
docker-compose up -d
```

Acesse:
- Elasticsearch: http://localhost:9200
- Kibana: http://localhost:5601

---

## 📚 Próximas etapas

- [ ] Criação de índices e ingestão de dados
- [ ] Consultas básicas
- [ ] Filtros e análise de texto
- [ ] Dashboards no Kibana

Siga o projeto, contribua e compartilhe!
