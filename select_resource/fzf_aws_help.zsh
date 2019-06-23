FZF_AWS_HELP_RESOURCE_HOME=${0:A:h}
FZF_AWS_HELP_RESOURCE_RESULT_DIR=${HOME}/.fzf_aws_help
export FZF_AWS_HELP_RESOURCE_HOME FZF_AWS_HELP_RESOURCE_RESULT_DIR

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

