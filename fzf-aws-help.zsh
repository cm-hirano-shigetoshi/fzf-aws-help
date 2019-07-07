FZF_AWS_HELP_COMMAND_HOME=${FZF_AWS_HELP_COMMAND_HOME-${0:A:h}/select_command}
FZF_AWS_HELP_RESOURCE_HOME=${FZF_AWS_HELP_RESOURCE_HOME-${0:A:h}/select_resource}
FZF_AWS_HELP_RESOURCE_RESULT_DIR=${FZF_AWS_HELP_RESOURCE_RESULT_DIR-${HOME}/.fzf_aws_help}
export FZF_AWS_HELP_COMMAND_HOME FZF_AWS_HELP_RESOURCE_HOME FZF_AWS_HELP_RESOURCE_RESULT_DIR


function __initialize() {
  echo "初期化を開始します。これには数分かかります。"
  mkdir -p ${FZF_AWS_HELP_COMMAND_HOME}/help
  while read subcmd; do
    echo "aws $subcmd help"
    aws $subcmd help > ${FZF_AWS_HELP_COMMAND_HOME}/help/aws_${subcmd} 2>/dev/null
  done < <(aws help \
    | fzf --ansi --filter=^ \
    | perl -ne 'exit if(/^SEE ALSO$/); print if($p); $p=1 if(/^AVAILABLE SERVICES$/);' \
    | sed -n 's/^\s*o //p'
  )
  echo "初期化が完了しました。"
  echo ""
  zle redisplay
}


function __aws_command_completion() {
  if [[ ! -e "${FZF_AWS_HELP_COMMAND_HOME}/help" ]]; then
    __initialize
    return
  fi

  readonly local RESULT=$(fzfyml run ${FZF_AWS_HELP_COMMAND_HOME}/fzf-aws-help.yml)
  if [[ -n ${RESULT} ]]; then
    BUFFER=${RESULT}
    CURSOR=${#BUFFER}
    zle redisplay
  fi
}


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

function __fzf_aws_help {
  local regexp='^aws *$'
  if [[ "${BUFFER}" =~ $regexp ]]; then
    __aws_command_completion
  else
    __aws_resource_info
  fi
}
zle -N fzf-aws-help __fzf_aws_help
# キーバインドはご自由に
bindkey "^h" fzf-aws-help

