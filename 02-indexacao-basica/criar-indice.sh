#!/bin/bash
curl -X PUT 'http://localhost:9200/clientes' -H 'Content-Type: application/json' -d '{
  "mappings": {
    "properties": {
      "nome": { "type": "text" },
      "email": { "type": "keyword" },
      "idade": { "type": "integer" },
      "cidade": { "type": "text" },
      "data_cadastro": { "type": "date" }
    }
  }
}'
