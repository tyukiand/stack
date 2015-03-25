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
export PS1="\033[0;32mstack\033[39m:\033[0;96m\w\033[39m\n>> "
export PROMPT_COMMAND=""

source "$STACK_PATH/utils/colors.sh"

# Displays help.
#
# If a parameter is passed, tries to display command-specific 
# help. Otherwise displays general help.
function help {
  local cmd="$1"
  case "$cmd" in
    "add" )
      cat "${STACK_PATH}/help/add_help.txt"
    ;;
    "todo" )
      cat "${STACK_PATH}/help/todo_help.txt"
    ;;
    "concrete" )
      cat "${STACK_PATH}/help/concrete_help.txt"
    ;;
    "focus" )
      cat "${STACK_PATH}/help/focus_help.txt"
    ;;
    "blur" )
      cat "${STACK_PATH}/help/blur_help.txt"
    ;;
    "push" )
      cat "${STACK_PATH}/help/push_help.txt"
    ;;
    "finish" )
      cat "${STACK_PATH}/help/finish_help.txt"
    ;;
    "abandon" )
      cat "${STACK_PATH}/help/abandon_help.txt"
    ;;
    * )
      cat "${STACK_PATH}/help/general_help.txt"
    ;;
  esac
}

# Used code generator was:
# for x in focus blur push finish abandon
# do   
#   echo -e "\"${x}\" )\n  cat \"\${STACK_PATH}/help/${x}_help.txt\"\n;;"
# done

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
    else
      echoError "The subtask '$subtask' does not exist."
    fi
  fi
}

# Unsets the focused subtask.
#
# After this function is called, no subtask is marked as focused.
function blur {
  "${STACK_PATH}/persistence/set-focused-subtask.sh" ""
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

# Finishes a subtask
# 
# Moves a subtask into a hidden .finished.<task_name> directory
function finish {
  if (( $# == 0 )) 
  then
    # focus on this task
    thisTask=$(basename $(pwd))
    cd ..
    finish "$thisTask"
  else
    # focus on a subtask
    subtask=$1
    if [ -d "$subtask" ] 
    then
      mv "$subtask" ".finished.${subtask}"
    else
      echoError "The subtask '$subtask' does not exist."
    fi
  fi
}

# Abandones a subtask
# 
# Moves a subtask into a hidden .finished.<task_name> directory
function abandon {
  if (( $# == 0 )) 
  then
    # focus on this task
    thisTask=$(basename $(pwd))
    cd ..
    abandon "$thisTask"
  else
    # focus on a subtask
    subtask=$1
    if [ -d "$subtask" ] 
    then
      mv "$subtask" ".abandoned.${subtask}"
    else
      echoError "The subtask '$subtask' does not exist."
    fi
  fi
}