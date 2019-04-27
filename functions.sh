function help() {
  cat $_PMDIR/help.txt
}

function init() {
  PROJECT=$2
  if [ ! -d "${HOME}/.pm/${PROJECT}" ]; then
    mkdir -p ${HOME}/.pm/${PROJECT}
    touch    ${HOME}/.pm/${PROJECT}/aliases
    echo $PROJECT > $HOME/.pm/_CURRENT_PROJECT
    echo "Project *${PROJECT}* created"
  else
    echo "Project *${PROJECT}* already exist"
  fi
  
  # Set project name in a file so we can reuse it in the future
  set $PROJECT
}

## Set the current project
function _set() {
  CURRENT_PROJECT=$(cat $HOME/.pm/_CURRENT_PROJECT)

  if [[ $# -eq 1 ]]
  then
    echo $CURRENT_PROJECT
  else
    PROJECT=$2
    if [ ! -d "${HOME}/.pm/${PROJECT}" ]; then
      echo "Missing project: ${PROJECT}"
    elif [ "$PROJECT" == "$CURRENT_PROJECT" ]; then
      echo "Already on '${PROJECT}'"
    else
      echo $PROJECT > $HOME/.pm/_CURRENT_PROJECT
      echo "Switching to: ${PROJECT}"
    fi
  fi
}

function add() {
  echo "Type your alias like: ll='ls -la'"
  read -p '> ' alias
  NAME=$(echo "${alias}" | cut -d'=' -f1)
  cat ~/.pm/${_PROJECT}/aliases | grep ^${NAME}= > /dev/null
  EXIT=$?
  if [ $EXIT -ne 0 ]; then
    echo "${alias}" >> ${HOME}/.pm/${_PROJECT}/aliases && \
    echo "Alias created: ${_PROJECT}.${NAME}"
  else
    echo "This sub-command already exist"
  fi
}

function remove() {
  echo 'Removing existing command'
}

function list() {
  grep -Eo "^[a-zA-Z0-9]+=" ${HOME}/.pm/${_PROJECT}/aliases | sed 's#=$##' | sed "s#^#${_PROJECT}.#"
}

function projects() {
  CURRENT_PROJECT=$(cat $HOME/.pm/_CURRENT_PROJECT)
  find $HOME/.pm/ -maxdepth 1 -type d -print | tail -n +2 | rev | cut -d'/' -f1 | rev | sed "s#$CURRENT_PROJECT#$CURRENT_PROJECT*#"
}

# Edit with default editor aliases file
function edit() {
  "${EDITOR:-vi}" ${HOME}/.pm/${_PROJECT}/aliases
}