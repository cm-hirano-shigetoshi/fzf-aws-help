#!/usr/bin/env bash
set -eu

readonly CMD="aws $(echo $1 | sed 's%/% %')"
cat ~/.local/aws_help/${CMD// /_} \
  | fzf --ansi --filter=^ \
  | perl -ne 'BEGIN{$p=0} exit if(/^OPTIONS$/); print if($p); $p=1 if(/^SYNOPSIS$/);' \
  | sed -n 's/^ *\[--/[--/p' \
  | tr -d '[]'

