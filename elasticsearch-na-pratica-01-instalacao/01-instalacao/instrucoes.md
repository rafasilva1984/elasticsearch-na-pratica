# Instalação do Elasticsearch com Docker

### Pré-requisitos
- Docker e Docker Compose instalados

### Passos
1. Clone o repositório:
   ```bash
   git clone https://github.com/seuusuario/elasticsearch-na-pratica.git
   cd elasticsearch-na-pratica/01-instalacao
   ```

2. Suba os containers:
   ```bash
   docker-compose up -d
   ```

3. Acesse os serviços:
   - Elasticsearch: http://localhost:9200
   - Kibana: http://localhost:5601

### Teste a instalação
Execute no terminal:
```bash
curl http://localhost:9200
```

Você deve ver informações do cluster.
