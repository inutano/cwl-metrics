# CWL-metrics

<!-- [![DOI](https://zenodo.org/badge/130311460.svg)](https://zenodo.org/badge/latestdoi/130311460) -->

CWL-metrics is a framework to collect and analyze computational resource usage of workflows defined in [Common Workflow Language (CWL)](https://www.commonwl.org). CWL-metrics provides a command line tool to run a CWL workflow, collect resource usage, and integrate with the workflow information. CWL-metrics uses [Telegraf](https://github.com/influxdata/telegraf) to collect the resource usage via docker API, and [Elasticsearch](https://github.com/elastic/elasticsearch) to store the collected data in. You can specify an Elasticsearch server to send out the collected resource usage.

<!-- Visit [GitHub pages](https://inutano.github.io/cwl-metrics/) for more details. -->

## Changes on ver 2.0

- CWL-metrics no longer uses the Perl daemon, provides `cwl-metrics run` command to run a CWL workflow and collect metrics instead.

## Prerequisites

- [`docker`](https://docs.docker.com/get-docker/)
- [`docker-compose`](https://docs.docker.com/compose/install/) (version 3)

## Install

Clone this repository and execute the script `cwl-metrics`

```
$ git clone https://github.com/inutano/cwl-metrics
$ cd cwl-metrics
$ ./cwl-metrics
cwl-metrics: 2.0.0
Usage:
  cwl-metrics [subcommand] [options] <wf.cwl> <wf.conf>

Subcommand:
  up                      Start metrics collector containers
  down                    Stop metrics collector containers
  run                     Run given workflow via cwltool and collect metrics
  fetch                   Start Virtuoso and load data; add data to the existing
  ps                      Show status of metrics collector containers
  logs                    Show docker-compose logs
  clean                   Clean up tmpdir (./tmp)
  help (-h|--help)        Show this help message
  version (-v|--version)  Show version information

Options:
  --es-host  Set Elasticsearch host name (default: localhost)
  --es-port  Set Elasticsearch port number (default: 9200)
```

## Getting started

Use subcommands to control CWL-metrics system as follows:

```
$ ./cwl-metrics up
Creating network "tmp_default" with the default driver
Creating cwl-metrics-elasticsearch ... done
Creating cwl-metrics-fluentd       ... done
Creating cwl-metrics-telegraf      ... done
[2020/12/04 16:16:34] CWL-metrics: Creating ElasticSearch indexes..
{"acknowledged":true,"shards_acknowledged":true,"index":"metrics"}{"acknowledged":true,"shards_acknowledged":true,"index":"workflow"}{"metrics":{"aliases":{},"mappings":{"properties":{"timestamp":{"type":"date","format":"epoch_second"}}},"settings":{"index":{"creation_date":"1607066231035","number_of_shards":"1","number_of_replicas":"1","uuid":"6yhEsxrrSL6LXQavIYgG0Q","version":{"created":"7070099"},"provided_name":"metrics"}}}}{"workflow":{"aliases":{},"mappings":{"properties":{"end_date":{"type":"date","format":"yyyy-MM-dd HH:mm:ss"},"start_date":{"type":"date","format":"yyyy-MM-dd HH:mm:ss"}}},"settings":{"index":{"mapping":{"total_fields":{"limit":"5000"}},"number_of_shards":"1","provided_name":"workflow","creation_date":"1607066231680","number_of_replicas":"1","uuid":"TyM8DZnsQWyCg_7dGHOxrQ","version":{"created":"7070099"}}}}}%
$ ./cwl-metrics run <your CWL workflow> <your workflow job configuration>
$ ./cwl-metrics fetch
$ ./cwl-metrics down
```

This will do followings:

- Create tmp directory (`./tmp`)
- Check prerequisites and fetch containers (first time only)
  - [telegraf docker container](https://hub.docker.com/layers/telegraf/library/telegraf/1.5-alpine/images/sha256-aa8daabb3b1cc27b8d7247fea799eded4dd7a3f26dda1641bcb065a5c577985a?context=explore)
  - [Elasticsearch docker container](https://hub.docker.com/layers/elasticsearch/library/elasticsearch/7.7.0/images/sha256-e93505e5a277480995bd682b8e0e91e16deba9dd6b190015c48134eff519f15a?context=explore)
  - [cwl-log-generator](https://github.com/inutano/cwl-log-generator) docker container
  - [cwl-metrics-client](https://github.com/inutano/cwl-metrics-client) docker container
- Run `cwltool` and collect metrics usage


## Troubleshooting

### CWL-metrics starting process stopped with showing "Creating Elasticsearch index..."

This happens because Elasticsearch did not launch successfully because of the machine setting on `vm.max_map_count`. Follow the guide below to set it to 262144.

```
# Linux
$ sudo sysctl -w vm.max_map_count=262144
$ grep vm.max_map_count /etc/sysctl.conf
vm.max_map_count=262144

# On mac os
$ screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
$ sudo sysctl -w vm.max_map_count=262144

# Windows and macOS with Docker Toolbox
$ docker-machine ssh
$ sudo sysctl -w vm.max_map_count=262144
```

If you still get an error on launching CWL-metrics, please let us know by creating an [issue](https://github.com/inutano/cwl-metrics/issues).
