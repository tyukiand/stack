#!/bin/bash
#
# Contains utility functions that help to display help

if [ -z "$STACK_HELP_SOURCED" ]
then 
  export STACK_HELP_SOURCED="true"
else 
  return
fi

# Displays help for a specific topic
#
# Expects one argument (the topic) that has a corresponding 
# help-file in `help/`
function __show_help {
  topic="$1"
  filePath="${STACK_PATH}/help/${topic}_help.txt"
  if [ -f "$filePath" ] 
  then 
    cat "$filePath"
  else
    cat "${STACK_PATH}/help/general_help.txt"
  fi
}