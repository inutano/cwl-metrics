#!/bin/sh

# Set variables
ES_HOST=${ES_HOST:-localhost}
ES_PORT=${ES_PORT:-9200}
echo "Use ElasticSearch server at ${ES_HOST}:${ES_PORT}"

# Wait until elasticsearch is up
while [[ -z "$(curl -s ${ES_HOST}:${ES_PORT})" ]]; do
  echo "waiting for Elasticsearch to be up"
  sleep 3
done

# Create index mapping
script_dir="$(cd $(dirname ${0}) && pwd -P)"
echo "\n"
echo "Creating index mapping for Workflow metrics.."
. "${script_dir}/index_mapping_telegraf.sh"

echo "\n"
echo "Creating index mapping for Workflow description.."
. "${script_dir}/index_mapping_workflow.sh"

# Check if index properly created
telegraf_ep="${ES_HOST}:${ES_PORT}/telegraf"
workflow_ep="${ES_HOST}:${ES_PORT}/workflow"

echo "\n"
echo "Index mapping done - Endpoint: ${telegraf_ep}"
curl -s "${telegraf_ep}"

echo "\n"
echo "Index mapping done - Endpoint: ${workflow_ep}"
curl -s "${workflow_ep}"
