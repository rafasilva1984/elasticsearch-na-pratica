#!/bin/bash
for i in {1..10}
do
  curl -X POST 'http://localhost:9200/clientes/_doc/' \
  -H 'Content-Type: application/json' \
  -d '{
    "nome": "Cliente Teste '$i'",
    "email": "cliente'$i'@exemplo.com",
    "idade": '$((20 + i))',
    "cidade": "Cidade '$i'",
    "data_cadastro": "2024-08-01"
  }'
  echo ""
done
