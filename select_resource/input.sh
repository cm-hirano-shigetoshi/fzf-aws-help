#!/usr/bin/env bash
set -eu

INPUT=$1
RESULT=$2

mkdir -p $(dirname ${RESULT})

if [[ $# > 2 ]] && [[ $3 = "--reload" ]]; then
  rm -f ${RESULT}
  shift
fi

if [[ ! -s ${RESULT} ]]; then
  bash -c "$(cat ${INPUT})" > ${RESULT}
fi
cat ${RESULT}

