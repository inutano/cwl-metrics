# CWL-metrics

CWL-metrics is a framework to collect and analyze computational resource usage of workflow runs based on the [Common Workflow Language (CWL)](https://www.commonwl.org). CWL-metrics launches a daemon process to catch `cwltool` processes, [Telegraf](https://github.com/influxdata/telegraf) to collect the resource usage via docker API, and [Elasticsearch](https://github.com/elastic/elasticsearch) to store the collected data in.

## Prerequisites

- `git`
- `curl`
- `perl`
- `docker`
- `docker-compose`
- `cwltool`

## Install

Use `curl` to fetch the install script from GitHub and exec via bash command as:

```
$ curl "https://raw.githubusercontent.com/inutano/cwl-metrics/master/bin/cwl-metrics" | bash
```

This will do followings:

- Check prerequisites
- Create `$HOME/.cwlmetrics`
- Fetch scripts and required docker containers
- Generate config files
- Run CWL-metrics

## Usage

### Launch CWL-metrics system

CWL-metrics will start automatically after the installation. The script to control the system `cwl-metrics` is at `$HOME/.cwlmetrics/bin/cwl-metrics`. Do any of followings to control the system:

- `cwl-metrics status`: shows if the system is running
- `cwl-metrics start`: launches metrics collection system
- `cwl-metrics stop`: stops metrics collection system

### Collect workflow resource usage

Current version of CWL-metrics supports only `cwltool` for CWL execution engine. While the system is running, run `cwltool` with options below to collect workflow metadata:

- `--debug`
- `--leave-container`
- `--timestamps`
- `--compute-checksum`
- `--record-container-id`
- `--cidfile-dir </path/to/container_id_dir>`
- `--outdir </path/to/cwl_result_dir>`
- `2> </path/to/debug_output_log_file>` (redirect stderr to a file)

Example:

```
$ cwl-metrics start
$ cwl-metrics status
cwl-metrics is running.
$ cd /home/inutano/workflows/kallisto
$ ls
kallisto.cwl kallisto.yml
$ mkdir result
$ cwltool --debug --leave-container --timestamps --compute-checksum --record-container-id --cidfile-dir $(pwd)/result --outdir $(pwd)/result kallisto.cwl kallisto.yml 2> $(pwd)/result/cwltool.log 
```

## Usage: summarize workflow metrics

## How it works
