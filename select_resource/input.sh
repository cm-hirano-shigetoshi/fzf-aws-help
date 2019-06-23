#!/usr/bin/env bash
set -eu

INPUT=$1
RESULT=$2
if [[ ! -s ${RESULT} ]]; then
  bash -c "${INPUT}" > ${RESULT}
fi
cat ${RESULT}

