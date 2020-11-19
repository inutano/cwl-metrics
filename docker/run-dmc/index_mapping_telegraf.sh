#!/bin/sh

curl -s --header "Content-Type:application/json" -XPUT ${ES_HOST}:${ES_PORT}/telegraf -d '{
  "mappings": {
    "docker_metrics": {
      "properties": {
        "timestamp": {"type": "date", "format": "epoch_second"}
      }
    }
  }
}'
