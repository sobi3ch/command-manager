# Initialization
PROJECT_FILE=${HOME}/.cm/_CURRENT_PROJECT

## Set current project name
if test -f "$PROJECT_FILE"; then
  _PROJECT=$(cat $PROJECT_FILE)
else
  touch $PROJECT_FILE
fi

## If command-manager main directory doesn't exist create new empty one
if [ ! -d "${HOME}/.cm" ]; then
  mkdir -p ${HOME}/.cm
  echo "command-manager initialized"
fi

# Load all commands from all projects
echo -n '' > /tmp/.cm-source-file
for PRO in $(find $HOME/.cm/ -maxdepth 1 -type d -print | tail -n +2 | rev | cut -d'/' -f1 | rev)
do
  cat ~/.cm/$PRO/aliases | sed "s#^#alias ${PRO}.#g" >> /tmp/.cm-source-file
done
source /tmp/.cm-source-file
rm /tmp/.cm-source-file


# Main function
function _cm() {
  if [ "$#" -eq 0 ]; then
    _cm_help
  else
    case $1 in
      help)        _cm_help;;
      version)     echo '{{VERSION}}';;
      init)        _cm_init "$@";;
      rm-project)  _cm_rm-project "$@";;
      set|current) _cm_set "$@";;
      add)         _cm_add "$@";;
      remove)      _cm_remove;;
      load)        _cm_load;;
      list)        _cm_list;;
      list-projects|projects) _cm_projects;;
      edit)        _cm_edit;;
      *)           _cm_help;;
    esac
  fi
}

alias cm='_cm 2>&1'

# Autocomplete
function _cm__autocomplete() {
  COMMANDS=$(grep --color=never -E "^[[:space:]]+[[:alpha:]|-]+).+;;" cm.sh | cut -d')' -f1 | awk '{$1=$1};1' | sed 's/|/\n/g' | tr '\r\n' ' ')
  complete -W "$COMMANDS" cm
}

# Load all project sub-commands
function _cm_load() {
  cat ${HOME}/.cm/${_PROJECT}/aliases | sed "s#^#alias ${_PROJECT}.#g"
}

function _cm_help() {
  cat <<EOF
usage: cm [command]
  help
    Prints this help page
  version
    Prints version
  init <project-name>
    Create project as an umbrella name for all sub-commands.
    This can be changed in any given time.
  set <project-name>
    If you have more then one project then with this command
    you can switch beetween them. Without project-name this
    will show current project.
  set|current
    Same as set without parameters. Show current project name.
  add <sub-command>
    Add new sub-command
  remove <sub-command>
    Remove existing sub-command
  list
    List all sub-commands for the currently set project.
  list-projects|projects
    List all projects
  edit
    Edit your sub-commands. Default open in vi, if you want to change this
    then `export EDITOR=nano`. To make it permanent add this to the end of
    your ~/.bashrc

Report bugs to: https://github.com/sobi3ch/project-manager/issues
EOF
}

function _cm_init() {
  if [ -z "$2" ]
  then
    echo "Project name is missing"
    echo "usage: cm init <project-name>"
    return
  fi
  local PROJECT=$2
  if [ ! -d "${HOME}/.cm/${PROJECT}" ]; then
    mkdir -p ${HOME}/.cm/${PROJECT}
    touch    ${HOME}/.cm/${PROJECT}/aliases
    _cm_set $PROJECT
    echo "Project *${PROJECT}* created"
  else
    echo "Project *${PROJECT}* already exist"
  fi
}

function _cm_rm-project() {
  local CURRENT_PROJECT=$(cat $HOME/.cm/_CURRENT_PROJECT)
  if [[ $# -gt 1 ]]
  then
    local PROJECT=$2
    if [ "$PROJECT" == "$CURRENT_PROJECT" ]
    then
      echo "error: Cannot delete the project '$PROJECT' which you are currently on."
    else
      _cm_projects | grep $PROJECT > /dev/null
      if [[ $? -gt 0 ]]
      then
        echo "error: There is no project '$PROJECT'."
      else
        read -p "Are you sure you want to permanently delete project '$PROJECT'? [y/N]: " opt
        if [ "$opt" == "y" ]
        then
          rm -rf ${HOME}/.cm/${PROJECT} && \
          echo "'$PROJECT' deleted."
        fi
      fi
    fi
  else
    echo 'To few parameters'
  fi
}

## Set the current project
function _cm_set() {
  local CURRENT_PROJECT=$(cat $HOME/.cm/_CURRENT_PROJECT)

  if [[ $# -eq 1 ]]
  then
    echo $CURRENT_PROJECT
  else
    PROJECT=$2
    if [ ! -d "${HOME}/.cm/${PROJECT}" ]; then
      echo "Missing project: ${PROJECT}"
    elif [ "$PROJECT" == "$CURRENT_PROJECT" ]; then
      echo "Already on '${PROJECT}'"
    else
      echo $PROJECT > $HOME/.cm/_CURRENT_PROJECT
      echo "Switching to: ${PROJECT}"
      _PROJECT=$(cat ${HOME}/.cm/_CURRENT_PROJECT)
    fi
  fi
}

function _cm_add() {
  echo "Type your alias like: ll='ls -la'"
  read -p '> ' ALIAS
  local NAME=$(echo "${ALIAS}" | cut -d'=' -f1)
  cat ~/.cm/${_PROJECT}/aliases | grep ^${NAME}= > /dev/null
  local EXIT=$?
  if [ $EXIT -ne 0 ]; then
    echo "${ALIAS}" >> ${HOME}/.cm/${_PROJECT}/aliases && \
    _cm_reload_project_commands $_PROJECT.$NAME && \
    echo "Alias created: ${_PROJECT}.${NAME}"
  else
    echo "This sub-command already exist"
  fi
}

function _cm_reload_project_commands()  {
  echo "Setting out: $1"
  cat ${HOME}/.cm/${_PROJECT}/aliases | sed "s#^#alias $_PROJECT.#g" >> /tmp/.cm-source-file
  source /tmp/.cm-source-file
  rm /tmp/.cm-source-file
}

function _cm_remove() {
  echo 'Removing existing command'
}

function _cm_list() {
  grep -Eo "^[a-zA-Z0-9]+=" ${HOME}/.cm/${_PROJECT}/aliases | sed 's#=$##' | sed "s#^#${_PROJECT}.#"
}

function _cm_projects() {
  LIST=$(for P in $(find $HOME/.cm/ -maxdepth 1 -type d -print | tail  -n+2); do
    basename $P
  done)

  # TODO check if not empty
  local CURRENT_PROJECT=$(cat $HOME/.cm/_CURRENT_PROJECT)
  echo "$LIST" | sed "s#$CURRENT_PROJECT#$CURRENT_PROJECT*#"
}

# Edit with default editor aliases file
function _cm_edit() {
  "${EDITOR:-vi}" ${HOME}/.cm/${_PROJECT}/aliases
  cat ${HOME}/.cm/${_PROJECT}/aliases | sed "s#^#alias ${_PROJECT}.#g" > /tmp/.cm-source-file
  source /tmp/.cm-source-file
}

_cm__autocomplete
