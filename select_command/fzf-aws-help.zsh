FZF_AWS_HELP_HOME=${0:A:h}
export FZF_AWS_HELP_HOME
function __fzf_aws_help() {
  BUFFER=$(fzfer run ${FZF_AWS_HELP_HOME}/fzf-aws-help.yml)
  CURSOR=${#BUFFER}
  zle redisplay
}
zle -N fzf-aws-help __fzf_aws_help
