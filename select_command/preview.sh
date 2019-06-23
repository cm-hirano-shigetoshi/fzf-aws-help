#!/usr/bin/env bash
set -eu

target_cmd="aws ${1/\// }"
readonly LOCAL_FILE="$(readlink -m ~/.local/aws_help/${target_cmd// /_})"
if [[ ! -e ${LOCAL_FILE} ]]; then
  mkdir -p $(dirname ${LOCAL_FILE})
  ${target_cmd} help > ${LOCAL_FILE}
fi
cat ${LOCAL_FILE}
