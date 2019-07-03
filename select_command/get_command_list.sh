while read file; do
  name=${file##*_}
  cat $file \
  | fzf --filter=^ --ansi \
  | perl -ne '$p=0 if(/\)$/); print if($p); $p=1 if(/^AVAILABLE COMMANDS$/)' \
  | sed -n "s/^ *o /$name\//p" \
  | grep -v '/help$'
done < <(ls -1 ${FZF_AWS_HELP_COMMAND_HOME}/help/aws_* \
  | grep '/aws_[^_]\+$') \
