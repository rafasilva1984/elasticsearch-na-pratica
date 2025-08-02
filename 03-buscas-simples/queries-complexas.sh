#!/bin/bash
# Hosts com alta CPU e status warning
curl -X POST "http://localhost:9200/infra-hosts/_search" -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "must": [
        { "match": { "status": "warning" } },
        { "range": { "cpu": { "gte": 85 } } }
      ]
    }
  }
}'
