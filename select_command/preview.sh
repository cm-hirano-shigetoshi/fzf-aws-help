#!/usr/bin/env bash
set -eu

target_cmd="aws ${1/\// }"
readonly LOCAL_HELP_DIR="${FZF_AWS_HELP_COMMAND_HOME}/help"
readonly LOCAL_FILE="${LOCAL_HELP_DIR}/${target_cmd// /_}"
if [[ ! -e ${LOCAL_FILE} ]]; then
  mkdir -p $(dirname ${LOCAL_FILE})
  ${target_cmd} help > ${LOCAL_FILE}
fi
cat ${LOCAL_FILE}
