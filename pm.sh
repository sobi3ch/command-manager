# Initialization
_PROJECT=$(cat ${HOME}/.pm/_CURRENT_PROJECT)


# Load all projects
echo -n '' > /tmp/.pm-source-file
for PRO in $(find $HOME/.pm/ -maxdepth 1 -type d -print | tail -n +2 | rev | cut -d'/' -f1 | rev)
do
  cat ~/.pm/$PRO/aliases | sed "s#^#alias ${PRO}.#g" >> /tmp/.pm-source-file
done
source /tmp/.pm-source-file


# Main function
_pm() {
  if [ "$#" -eq 0 ]; then
    _pm_help
  else
    case $1 in
      help)        _pm_help;;
      version)     echo '{{VERSION}}';;
      init)        _pm_init "$@";;
      set|current) _pm_set "$@";;
      add)         _pm_add "$@";;
      remove)      _pm_remove;;
      load)        _pm_load;;
      list)        _pm_list;;
      list-projects|projects) _pm_projects;;
      edit)        _pm_edit;;
      *)           _pm_help;;
    esac
  fi
}

alias pm='_pm 2>&1'

# Load all project sub-commands
_pm_load() {
  cat ${HOME}/.pm/${_PROJECT}/aliases | sed "s#^#alias ${_PROJECT}.#g"
}

_pm_help() {
  cat <<EOF
usage: pm [command]
  help
    this help page
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

_pm_init() {
  local PROJECT=$2
  if [ ! -d "${HOME}/.pm/${PROJECT}" ]; then
    mkdir -p ${HOME}/.pm/${PROJECT}
    touch    ${HOME}/.pm/${PROJECT}/aliases
    _pm_set $PROJECT
    echo "Project *${PROJECT}* created"
  else
    echo "Project *${PROJECT}* already exist"
  fi
}

## Set the current project
_pm_set() {
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
      _PROJECT=$(cat ${HOME}/.pm/_CURRENT_PROJECT)
    fi
  fi
}

_pm_add() {
  echo "Type your alias like: ll='ls -la'"
  read -p '> ' ALIAS
  local NAME=$(echo "${ALIAS}" | cut -d'=' -f1)
  cat ~/.pm/${_PROJECT}/aliases | grep ^${NAME}= > /dev/null
  local EXIT=$?
  if [ $EXIT -ne 0 ]; then
    echo "${ALIAS}" >> ${HOME}/.pm/${_PROJECT}/aliases && \
    echo "Alias created: ${_PROJECT}.${NAME}"
  else
    echo "This sub-command already exist"
  fi
}

_pm_remove() {
  echo 'Removing existing command'
}

_pm_list() {
  grep -Eo "^[a-zA-Z0-9]+=" ${HOME}/.pm/${_PROJECT}/aliases | sed 's#=$##' | sed "s#^#${_PROJECT}.#"
}

_pm_projects() {
  local CURRENT_PROJECT=$(cat $HOME/.pm/_CURRENT_PROJECT)
  find $HOME/.pm/ -maxdepth 1 -type d -print | tail -n +2 | rev | cut -d'/' -f1 | rev | sed "s#$CURRENT_PROJECT#$CURRENT_PROJECT*#"
}

# Edit with default editor aliases file
_pm_edit() {
  "${EDITOR:-vi}" ${HOME}/.pm/${_PROJECT}/aliases
  cat ${HOME}/.pm/${_PROJECT}/aliases | sed "s#^#alias ${_PROJECT}.#g" > /tmp/.pm-source-file
  source /tmp/.pm-source-file
}