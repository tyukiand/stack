#!/bin/bash
#
# This script contains all the functions available to the user
# of the Stack 4.0. 
#
# It is used as init-script when starting a new
# customized shell (this happens in `stack`-script),
# so that all the commands like `help`, `add`, `push` etc.
# become available in the customized version of shell.

if [ -z "$STACK_API_SOURCED" ] 
then
  export STACK_API_SOURCED="true"
else
  return
fi

source "${STACK_PATH}/utils/colors.sh"
source "${STACK_PATH}/controller/add.sh"
source "${STACK_PATH}/controller/help.sh"
source "${STACK_PATH}/view/todo.sh"
source "${STACK_PATH}/persistence/focused-subtask.sh"
source "${STACK_PATH}/persistence/task-properties.sh"

# Set a new prompt
export PS1="\033[0;32mstack\033[39m:\033[0;96m\w\033[39m\n>> "
export PROMPT_COMMAND=""

# Displays help.
#
# If a parameter is passed, tries to display command-specific 
# help. Otherwise displays general help.
function help {
  local cmd="$1"
  __show_help "$cmd"
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
   __add_new_task "$@"
}

# Displays what is todo for the current task
#
# Shows the parent tasks that lead to this task, some progress information,
# and the active subtasks
function todo {
  __show_todo "$@"
}

# Follows the `FOCUSED_SUBTASK` pointer as far as possible
#
# Allows the user to quickly go from a high-level goal to the detailed substeps.
function concrete {
  local FOCUSED_SUBTASK=$(__get_focused_subtask)
  if [ -d "$FOCUSED_SUBTASK" ]
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
      __set_focused_subtask "$subtask"
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
  __set_focused_subtask ""
}

# Adds a new subtask
#
# Creates a task, focuses on the new task, 
# and changes the directory immediately after
# creation.
function push {
  LAST_CREATED_TASK=""
  __add_new_task "$@"
  if [[ ! -z "$LAST_CREATED_TASK" ]] 
  then
    focus "$LAST_CREATED_TASK"
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