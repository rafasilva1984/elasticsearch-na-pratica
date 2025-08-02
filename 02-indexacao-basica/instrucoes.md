# 📥 Etapa 02 – Indexação de Hosts de Infraestrutura

1. Execute o script para criar o índice `infra-hosts` e popular com 100 documentos simulados:
```bash
bash ingestar-hosts.sh
```

2. Verifique a estrutura dos dados:
```bash
curl -X GET http://localhost:9200/infra-hosts/_search?pretty
```

3. Campos disponíveis:
- `host`, `servico`, `status`, `cpu`, `memoria`, `@timestamp`
