FZF_AWS_HELP_COMMAND_HOME=${0:A:h}/select_command
FZF_AWS_HELP_RESOURCE_HOME=${0:A:h}/select_resource
FZF_AWS_HELP_RESOURCE_RESULT_DIR=${HOME}/.fzf_aws_help
export FZF_AWS_HELP_COMMAND_HOME FZF_AWS_HELP_RESOURCE_HOME FZF_AWS_HELP_RESOURCE_RESULT_DIR


function __fzf_aws_help() {
  readonly local RESULT=$(fzfyml run ${FZF_AWS_HELP_COMMAND_HOME}/fzf-aws-help.yml)
  if [[ -n ${RESULT} ]]; then
    BUFFER=${RESULT}
    CURSOR=${#BUFFER}
    zle redisplay
  fi
}
zle -N fzf-aws-help __fzf_aws_help


function __aws_resource_info {
  if [[ -z ${AWS_PROFILE} ]]; then
    export AWS_PROFILE=default
  fi
  readonly local RESULT=$(python ${FZF_AWS_HELP_RESOURCE_HOME}/get_target_file_name.py $CURSOR "${BUFFER}")
  if [[ -n ${RESULT} ]]; then
    BUFFER=$(sed '1d' <<< ${RESULT})
    CURSOR=$(head -n -1 <<< ${RESULT})
    zle redisplay
  fi
}
zle -N aws-resource-info __aws_resource_info

