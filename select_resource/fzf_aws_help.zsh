FZF_AWS_HELP_RESOURCE_HOME=${0:A:h}
FZF_AWS_HELP_RESOURCE_RESULT_DIR=${HOME}/.fzf_aws_help
export FZF_AWS_HELP_RESOURCE_HOME FZF_AWS_HELP_RESOURCE_RESULT_DIR

function aws_resource_info {
  if [[ -z ${AWS_PROFILE} ]]; then
    export AWS_PROFILE=default
  fi
  local cmd_file input_cmd
  readonly local ORIG_CMD=$(python ${FZF_AWS_HELP_RESOURCE_HOME}/get_target_file_name.py $CURSOR "${BUFFER}")

  cmd_file=${FZF_AWS_HELP_RESOURCE_HOME}/commands/input_${ORIG_CMD}
  if [[ ! -e ${cmd_file} ]]; then
    cmd_file=${cmd_file%_*}
    if [[ ! -e ${cmd_file} ]]; then
      cmd_file=${cmd_file%_*}
      if [[ ! -e ${cmd_file} ]]; then
        echo "Please create the command file: ${FZF_AWS_HELP_RESOURCE_HOME}/commands/input_${ORIG_CMD}" >&2
        return 1
      fi
    fi
  fi
  input_cmd=$(cat ${cmd_file})

  local result_file
  result_file=${FZF_AWS_HELP_RESOURCE_RESULT_DIR}/${AWS_PROFILE}/result_${cmd_file##*/commands/input_}
  mkdir -p $(dirname ${result_file})
  if [[ ! -s ${result_file} ]]; then
    bash -c "${input_cmd}" | sort > ${result_file}
  fi
  cat ${result_file} | fzf -m --reverse
}
zle -N aws_resource_info
bindkey "^j" aws_resource_info

