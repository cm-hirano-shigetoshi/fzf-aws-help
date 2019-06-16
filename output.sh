#!/usr/bin/env bash
set -eu

if [[ $# = 0 ]] || [[ $1 = "" ]]; then
  readonly CMD="aws $(cat - | sed 's%/% %g')"
  cat ~/.local/aws_help/${CMD// /_} \
    | fzf --ansi --filter=^ \
    | perl -ne 'BEGIN{$p=0} exit if(/^OPTIONS$/); print if($p); $p=1 if(/^SYNOPSIS$/);' \
    | grep -v '^\s*$' \
    | sed -e '1d' -e 's/^ \+//' \
    | sed 's/^\[.*/___OPTIONS___/' \
    | awk '!p[$0]++' \
    | sed -e 's/> \+or \+<.*$/>/' \
    | tr '\n' ' ' \
    | sed "s/^/${CMD} /"
else
  readonly OPTIONS=$(cat - | tr '\n' ' ')
  echo "${1}" \
    | sed "s\`___OPTIONS___ \`${OPTIONS}\`" \
    | tr '\n' ' '
fi

