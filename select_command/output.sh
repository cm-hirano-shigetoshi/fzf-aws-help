#!/usr/bin/env bash
set -eu

# no options
# aws commands are from stdin
readonly CMD="aws $(cat - | sed 's%/% %g')"
cat ${FZF_AWS_HELP_COMMAND_HOME}/help/${CMD// /_} \
  | fzf --ansi --filter=^ \
  | perl -ne 'BEGIN{$p=0} exit if(/^OPTIONS$/); print if($p); $p=1 if(/^SYNOPSIS$/);' \
  | grep -v '^\s*$' \
  | sed -e '1d' -e 's/^ \+//' \
  | sed 's/^\[.*/___OPTIONS___/' \
  | awk '!p[$0]++' \
  | sed -e 's/> \+or \+<.*$/>/' \
  | tr '\n' ' ' \
  | sed "s/^/${CMD} /"
