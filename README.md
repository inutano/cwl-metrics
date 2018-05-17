# CWL-metrics

CWL-metrics is a framework to collect and analyze computational resource usage of workflow runs based on the [Common Workflow Language (CWL)](https://www.commonwl.org). CWL-metrics launches a daemon process to catch `cwltool` processes, [Telegraf](https://github.com/influxdata/telegraf) to collect the resource usage via docker API, and [Elasticsearch](https://github.com/elastic/elasticsearch) to store the collected data in.
