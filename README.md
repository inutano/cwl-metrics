# CWL-spec

CWL-spec is a set of tools to collect and analyze computational resource usage of workflow runs based on the [Common Workflow Language (CWL)](https://www.commonwl.org). CWL-spec launches a daemon process to catch new `cwltool` processes, and [Telegraf](https://github.com/influxdata/telegraf) to collect the resource usage, and [Elasticsearch](https://github.com/elastic/elasticsearch) to store the data in.

## Prerequisites

- `git`
- `perl`
- `docker`
- `docker-compose`
- `cwltool`

## Install

Use `curl` to fetch the install script and exec via bash command as:

```
$ curl "https://raw.githubusercontent.com/inutano/cwl-spec/master/bin/cwl-spec" | bash
```

This will check prerequisites, create `$HOME/.cwlspec`, and fetch config files, required scripts, and docker containers.

## Usage

### Launch CWL-spec system

The system will start automatically after the installation. The script to control the system `cwl-spec` is installed in `$HOME/.cwlspec/bin/cwl-spec`. Below are the commands:

- `cwl-spec status`: Tells if the system is running
- `cwl-spec start`: Launches metrics collection system
- `cwl-spec stop`: Stops metrics collection system

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
