#!/usr/bin/env bash
set -eu

readonly CMD="aws $(cat - | sed 's%/% %g')"
cat ${FZF_AWS_HELP_COMMAND_HOME}/help/${CMD// /_} \
  | fzf --ansi --filter=^ \
  | perl -ne 'BEGIN{$p=0} exit if(/^OPTIONS$/); print if($p); $p=1 if(/^SYNOPSIS$/);' \
  | grep -v '^\s*$' \
  | sed 's/^\s\+//' \
  | grep '^\[' \
  | tr -d '[]'

