#!/bin/sh

# Path to this setup.sh
script_dir="$(cd $(dirname ${0}) && pwd -P)"

# Create log dir - /work if exists, otherwise on the parent dir
if [[ -e "/work" ]]; then
  log_dir="/work/log"
else
  log_dir="${script_dir}/../log"
fi

telegraf_log_dir="${log_dir}/telegraf"
fluentd_log_dir="${log_dir}/fluentd"
mkdir -p "${telegraf_log_dir}" "${fluentd_log_dir}"

# Create index mapping on ES
. "${script_dir}/index_mapping.sh"
