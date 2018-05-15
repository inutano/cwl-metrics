# CWL-spec

CWL-spec is a framework to collect and analyze computational resource usage of workflow runs based on the [Common Workflow Language (CWL)](https://www.commonwl.org). CWL-spec launches a daemon process to catch `cwltool` processes, [Telegraf](https://github.com/influxdata/telegraf) to collect the resource usage via docker API, and [Elasticsearch](https://github.com/elastic/elasticsearch) to store the collected data in.

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
$ curl "https://raw.githubusercontent.com/inutano/cwl-spec/master/bin/cwl-spec" | bash
```

This will do followings:

- Check prerequisites
- Create `$HOME/.cwlspec`
- Fetch scripts and required docker containers
- Generate config files
- Run CWL-spec

## Usage

### Launch CWL-spec system

CWL-spec will start automatically after the installation. The script to control the system `cwl-spec` is at `$HOME/.cwlspec/bin/cwl-spec`. Do any of followings to control the system:

- `cwl-spec status`: shows if the system is running
- `cwl-spec start`: launches metrics collection system
- `cwl-spec stop`: stops metrics collection system

### Collect workflow resource usage

Current version of CWL-spec supports only `cwltool` for CWL execution engine. While the system is running, run `cwltool` with options below to collect workflow metadata:

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
$ cwl-spec start
$ cwl-spec status
cwl-spec is running.
$ cd /home/inutano/workflows/kallisto
$ ls
kallisto.cwl kallisto.yml
$ mkdir result
$ cwltool --debug --leave-container --timestamps --compute-checksum --record-container-id --cidfile-dir $(pwd)/result --outdir $(pwd)/result 2> $(pwd)/result/cwltool.log
```

## Usage: summarize workflow metrics

## How it works
