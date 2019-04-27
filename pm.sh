#!/bin/bash

export _PMDIR=$(dirname $(readlink -f "$0" ))

source $_PMDIR/functions.sh

if [ "$#" -eq 0 ]; then
  help
  exit 0;
fi

# Initialization
export _PROJECT=$(cat ${HOME}/.pm/_CURRENT_PROJECT)

case $1 in
  help)
    help
    ;;
  version) echo '0.1';;
  init)
    init "$@"
    ;;
  set|current)
    _set "$@"
    ;;
  add)
    add "$@"
    ;;
  remove)
    remove
    ;; 
  list) list;;
  list-projects|projects) projects;;
  edit) edit;;
  *)
    help
    ;;
esac
