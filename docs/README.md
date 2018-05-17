# CWL-metrics

![RUN CWL](images/run-cwl.png)

CWL-metrics is a framework to collect and analyze computational resource usage of workflow runs based on the [Common Workflow Language (CWL)](https://www.commonwl.org). CWL-metrics launches a daemon process to catch `cwltool` processes, [Telegraf](https://github.com/influxdata/telegraf) to collect the resource usage via docker API, and [Elasticsearch](https://github.com/elastic/elasticsearch) to store the collected data in.

---

## Prerequisites

- `git`
- `curl`
- `perl`
- `docker`
- `docker-compose` (version 3)
- `cwltool`

---

## Install

Use `curl` to fetch the install script from GitHub and exec via bash command as:

```
$ curl "https://raw.githubusercontent.com/inutano/cwl-metrics/master/bin/cwl-metrics" | bash
```

This will do followings:

- Check prerequisites
- Create `$HOME/.cwlmetrics`
- Fetch required tools
  - CWL-metrics daemon script (this repository)
  - [docker-metrics-collector](https://github.com/inutano/docker-metrics-collector) repository
  - [docker-cwllog-generator](https://github.com/inutano/docker-cwllog-generator) docker container
  - [cwl-metrics-client](https://github.com/inutano/cwl-metrics-client) docker container
- Generate config files
- Run CWL-metrics

Installing CWL-spec will pull the following containers to your host environment:

- `telegraf` for collecting container metrics
- `sebp/elk` for Elasticsearch and Kibana
- `quay.io/inutano/run-dmc` for setting up docker-metrics-collector
- `quay.io/inutano/fluentd` for sending log data to Elasticsearch
- `yyabuki/docker-cwllog-generator` for processing workflow metadata
- `quay.io/inutano/cwl-metrics-client` for summarizing metrics data

---

## Usage

### Launch CWL-metrics system

CWL-metrics will start automatically after the installation. The script to control the system `cwl-metrics` is at `$HOME/.cwlmetrics/bin/cwl-metrics`. `export PATH=$HOME/.cwlmetrics/bin:$PATH` would be useful to execute the command wherever you need.

Do any of followings to control the system:

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

### Visualize data on Elasticsearch/Kibana

Collected metrics data are stored in Elasticsearch which exposes the port 9022. To check the status of the Elasticsearch server, run the following command:

```
$ curl localhost:9200/_cluster/health?pretty=true
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 11,
  "active_shards" : 11,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 52.38095238095239
}
```

To visualize the collected metrics data, Kibana is also available via port 5601. Access the Kibana server from `localhost:5601`, and you will see the dashboard screen like below:

![Kibana dashboard](images/kibana01.png)

Click "Set up index patterns".

![Create index pattern](images/kibana02.png)

In this screen you'll have to create index pattern, but we'll only have two indices named "telegraf" and "workflow", which contain the metrics data and workflow metadata, respectively. Type "telegraf" to filter indices, and click "next step". In the next step you have to configure time filter field name, just click the drop down, and select timestamp, then Create index pattern. Once the index pattern successfully created, click "Discover" in the left side menu. You will see the timeline of collected data and the list of records like the screenshot below.

![Discover data](images/kibana03.png)

In this screen you can see all the data stored in the Elasticsearch server, and Kibana has some useful visualization tools which can aggregate data and draw plots, but the data are too raw. For more simple statistics like total memory usage by workflow runs, use the command explained in the next section.

### Summarize data by `cwl-metrics fetch`

`cwl-metrics` command has a feature to fetch data from the Elasticsearch server and aggregate metrics with the workflow metadata. It can output the data in JSON or TSV.

```
$ cwl-metrics fetch json
{"CWL-metrics":[{"workflow_id":"48813280-5990-11e8-9693-0aafe96a2914","workflow_name":"KallistoWorkflow-se.cwl","platform":{"instance_type":" m5.2xlarge","region":" us-east-1a","hostname":" ip-172-31-10-231.ec2.internal"},"steps":{"135df0da59c968f22d1e394c9412cb9c3fa4580cf62616790ff79ffa162c7911":{"stepname":"kallisto_quant","container_name":"yyabuki/kallisto:0.43.1","tool_version":"0.43.1","tool_status":"success","input_files":{"SRR1274306.fastq":229279368,"GRCh38Gencode":2836547930},"metrics":{"cpu_total_percent":99.7522093765586,"memory_max_usage":4053995520,"memory_cache":152821760,"blkio_total_bytes":51630080,"elapsed_time":40}},"e4796affa915d74f05d2094c410fcfcd0771e51fba9e7712be26a5b124393a94":{"stepname":"kallisto_stdout","container_name":"yyabuki/kallisto:0.43.1","tool_version":"0.43.1","tool_status":"success","input_files":{},"metrics":{"cpu_total_percent":0,"memory_max_usage":0,"memory_cache":null,"blkio_total_bytes":null,"elapsed_time":0}},"1caaaf7b5be68affbec2f4df1a95fcc534431c93fb8b56164affa59c7ae47871":{"stepname":"kallisto_version","container_name":"yyabuki/docker-ngs-version:0.1.0","tool_version":"0.43.1","tool_status":"success","input_files":{"kallisto_stdout":1337},"metrics":{"cpu_total_percent":null,"memory_max_usage":null,"memory_cache":null,"blkio_total_bytes":null,"elapsed_time":null}}}}]}
```

in TSV:

```
$ cwl-metrics fetch tsv
container_id    stepname        instance_type   cpu_total_percent       memory_max_usage        memory_cache    blkio_total_bytes       elapsed_time    workflow_id     workflow_name   container_name  tool_version    tool_status     total_inputfile_size
7fc27d4d335a    kallisto_quant   m5.2xlarge             6811197440      2909052928      2956857344      20      1acbecae-5990-11e8-9693-0aafe96a2914    KallistoWorkflow-se.cwl yyabuki/kallisto:0.43.1 0.43.1  success 2951599476
1c979a72b9f7    kallisto_stdout  m5.2xlarge                                             1acbecae-5990-11e8-9693-0aafe96a2914    KallistoWorkflow-se.cwl yyabuki/kallisto:0.43.1 0.43.1  success
fa0831923476    kallisto_version         m5.2xlarge                                             1acbecae-5990-11e8-9693-0aafe96a2914    KallistoWorkflow-se.cwl yyabuki/docker-ngs-version:0.1.0        0.43.1  success 1337
```

And you can use any software you like to visualize the result.

---

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
