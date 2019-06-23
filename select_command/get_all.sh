readonly SERVICES=$(aws help \
    | tee ~/.local/aws_help/aws \
    | fzf --ansi --filter=^ \
    | perl -ne 'BEGIN{$p=0;} exit if(/^SEE ALSO$/); print if($p); $p=1 if(/^AVAILABLE SERVICES$/);' \
    | sed -n 's/^ *o //p')

for s in $SERVICES; do
  echo "aws $s"
  aws $s help > ~/.local/aws_help/aws_${s} 2>/dev/null
done

