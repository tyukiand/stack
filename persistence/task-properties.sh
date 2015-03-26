#!/bin/bash
#
# Provides functions for reading/writing task properties

if [ -z "$STACK_TASK_PROPERTIES_SOURCED" ]
then
  export STACK_TASK_PROPERTIES_SOURCED="true"
else
  return
fi

source "${STACK_PATH}/utils/validation.sh"

# Reads task name, value, and focused subtask from a `.task_properties.kv`
# file.
#
# Sets variables TASK_NAME, TASK_VALUE and FOCUSED_SUBTASK
# if successful, prints an error message otherwise
function __get_task_properties {
  if [ -f .task_properties.kv ] 
  then
    TASK_NAME=""
    TASK_VALUE="1.0"
    FOCUSED_SUBTASK=""
    while IFS='=' read -r key value
    do
      case $key in
        "TASK_NAME" )
          TASK_NAME="$value"
        ;;
        "TASK_VALUE" )
          if [[ -z $(isValidValue "$TASK_VALUE") ]] 
          then
            TASK_VALUE="$value"
          fi
        ;;
        "FOCUSED_SUBTASK" )
          FOCUSED_SUBTASK="$value"
        ;;
      esac
    done < .task_properties.kv
  else 
    echo "Current directory does not seem to represent a task. "
    echo "No .task_properties.kv found."
  fi
}

# Persists properties of a task in an `.task_properties.kv` file.
# 
# The `kv` ending stands for key-value pairs.
# Expects task name, value, and a focused subtask as 
# arguments.
function __set_task_properties {
  taskName=$1
  value=$2
  focused=$3
  
  touch .task_properties.kv
  # First must be '>' , others can '>>'
  echo "TASK_NAME=${taskName}" > .task_properties.kv
  echo "TASK_VALUE=${value}" >> .task_properties.kv
  echo "FOCUSED_SUBTASK=${focused}" >> .task_properties.kv
}

# Tests whether the specified directory represents a task
#
# Returns strings "true" or "false"
function __is_task {
  local directory="$1"
  if [ -z "$directory" ]
  then 
    directory=$(pwd)
  fi
  if [ -f "$directory/.task_properties.kv" ]
  then
    echo "true"
  else
    echo "false"
  fi
}