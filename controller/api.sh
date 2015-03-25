#!/bin/bash
#
# This script contains all the functions available to the user
# of the Stack 4.0. 
#
# It is used as init-script when starting a new
# customized shell (this happens in `stack`-script),
# so that all the commands like `help`, `add`, `push` etc.
# become available in the customized version of shell.

# Set a new prompt
export PS1="\033[0;32mstack\033[39m:\033[0;96m\w\033[39m> "
export PROMPT_COMMAND=""

# Displays help.
#
# If a parameter is passed, tries to display command-specific 
# help. Otherwise displays general help.
function help {
  local cmd="$1"
  case "$cmd" in
    "add" )
      echo "TODO: display add-help here"
    ;;
    * )
      cat "$STACK_PATH"/help/general_help.txt
    ;;
  esac
}

# Adds a new subtask.
#
# Can be used either in interactive mode or with arguments.
# See implementation of `stack-add` for more details.
function add {
  "${STACK_PATH}/controller/add.sh" "$@"
}

# Displays what is todo for the current task
#
# Shows the parent tasks that lead to this task, some progress information,
# and the active subtasks
function todo {
  "${STACK_PATH}/view/todo.sh" "$@"
}

# Follows the `FOCUSED_SUBTASK` pointer as far as possible
#
# Allows the user to quickly go from a high-level goal to the detailed substeps.
function concrete {
  source "${STACK_PATH}/persistence/get-focused-subtask.sh"
  if [ ! -z "$FOCUSED_SUBTASK" ]
  then
    cd "$FOCUSED_SUBTASK"
    concrete
  fi
}

# Focuses on a subtask.
#
# If no arguments are passed, focuses on the current task.
# Otherwise focuses on specified subtask.
function focus {
  if (( $# == 0 )) 
  then
    # focus on this task
    thisTask=$(basename $(pwd))
    cd ..
    focus "$thisTask"
  else
    # focus on a subtask
    subtask=$1
    if [ -d "$subtask" ] 
    then
      "${STACK_PATH}/persistence/set-focused-subtask.sh" "$subtask"
      concrete
      todo
    fi
  fi
}

# Adds a new subtask
#
# Creates a task, focuses on the new task, 
# and changes the directory immediately after
# creation.
function push {
  eval $("${STACK_PATH}/controller/add-return.sh" "$@")
  if [[ ! -z "$LAST_CREATED_TASK" ]] 
  then
    focus "$LAST_CREATED_TASK"
    cd "$LAST_CREATED_TASK"
  fi
}