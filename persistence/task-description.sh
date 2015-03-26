#!/bin/bash
#
# Methods for accessing task description

if [ -z "$STACK_TASK_DESCRIPTION_SOURCED" ]
then
  export STACK_TASK_DESCRIPTION_SOURCED="true"
else
  return
fi

# Returns first string of the description of the task in the current directory
function __get_short_description {
  if [ -f .description.txt ]
  then
    head -n 1 .description.txt
  fi
}