# CWL-metrics

[![DOI](https://zenodo.org/badge/130311460.svg)](https://zenodo.org/badge/latestdoi/130311460)

CWL-metrics is a framework to collect and analyze computational resource usage of workflows defined in [Common Workflow Language (CWL)](https://www.commonwl.org). CWL-metrics provides a command line tool to run a CWL workflow, collect resource usage, and integrate with the workflow information. CWL-metrics uses [Telegraf](https://github.com/influxdata/telegraf) to collect the resource usage via docker API, and [Elasticsearch](https://github.com/elastic/elasticsearch) to store the collected data in. You can specify an Elasticsearch server to send out the collected resource usage.

Visit [github pages](https://inutano.github.io/cwl-metrics/) for more details.

## Prerequisites

- [`docker-compose`](https://docs.docker.com/compose/install/) (version 3)

## Install

Use `curl` to fetch the main bash script from GitHub:

```
$ curl -sLO "https://raw.githubusercontent.com/inutano/cwl-metrics/master/bin/cwl-metrics"
```

Run your workflow as following:

```
$ cwl-metrics run <your CWL workflow> <your workflow job configuration>
```

This will do followings:

- Check prerequisites and fetch containers (first time only)
  - [cwltool docker container](https://hub.docker.com/r/commonworkflowlanguage/cwltool)
  - [telegraf docker container]()
  - [Elasticsearch docker container]()
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

If you already set and still have a problem on launching CWL-metrics, please let us know by creating an [issue](https://github.com/inutano/cwl-metrics/issues).
