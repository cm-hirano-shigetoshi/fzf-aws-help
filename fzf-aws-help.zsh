function fzf_aws_help() {
  BUFFER=$(fzfer run ${0:A:h}/fzf-aws-help.yml)
  CURSOR=${#BUFFER}
  zle redisplay
}
zle -N fzf_aws_help
