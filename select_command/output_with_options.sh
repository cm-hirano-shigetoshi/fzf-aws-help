#!/usr/bin/env bash
set -eu

# $1:    "lambda/get-function --required <value> ___options___"
# stdin: "--option <value>"

STDIN=$(cat - | tr '\n' ' ')

DIRNAME=$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))
echo "$1" \
  | bash ${DIRNAME}/output.sh \
  | sed "s\`___OPTIONS___\`${STDIN}\`g"

