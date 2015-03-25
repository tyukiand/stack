#!/bin/bash
#
# Reads task name, value, and focused subtask from a `.task_properties.kv`
# file.
#
# Sets variables TASK_NAME, TASK_VALUE and FOCUSED_SUBTASK
# if successful, prints an error message otherwise

# load functions used for validation
source "${STACK_PATH}/utils/validation.sh"

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