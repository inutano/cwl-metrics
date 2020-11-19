#!/bin/sh

curl -s --header "Content-Type:application/json" -XPUT ${ES_HOST}:${ES_PORT}/workflow -d '{
  "settings": {
    "index.mapping.total_fields.limit": 5000
  },
  "mappings": {
    "workflow_log": {
      "properties": {
        "workflow": {
          "properties": {
            "start_date": {"type": "date", "format": "yyyy-MM-dd HH:mm:ss"},
            "end_date": {"type": "date", "format": "yyyy-MM-dd HH:mm:ss"}
          }
        }
      }
    }
  }
}'
