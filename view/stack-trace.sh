#!/bin/bash
#
# Printing breadcrumb/stack-trace-like representations of task hierarchies

if [ -z "$STACK_TRACE_SOURCED" ]
then
  export STACK_TRACE_SOURCED="true"
else
  return
fi

source "${STACK_PATH}/utils/colors.sh"
source "${STACK_PATH}/persistence/task-properties.sh"
source "${STACK_PATH}/persistence/task-description.sh"

# Writes an indented single-line description of a task
#
# Expects directory of the task and indentation as parameters.
# This is essentially a piece of the __stackTrace function that
# helps to construct indented breadcrumbs.
function __describeIndented {
  local directory="$1"
  local indentation="$2"
  if [[ $(__is_task "$directory") == "true" ]]
  then 
    cd "$directory"
    __get_task_properties
    local prefix="${indentation}${TASK_NAME}                                   "
    prefix=${prefix:0:28}
    local shortDescr="$(__get_short_description)"
    local suffix=""
    if (( ${#shortDescr} + ${#prefix} > 76 ))
    then
      suffix="${shortDescr:0:$(( 74 - ${#prefix} ))}..."
    else
      suffix="$shortDescr"
    fi
    local line="$prefix [${suffix}]"
    echo "$line"
    cd - > /dev/null
  else 
    echoError "The directory $directory does not seem to be a valid task."
  fi
}

# Prints short description of all parent goals and this goal
#
# Recursively walks up in the hierarchy of subtasks, and prints 
# predecessors of specified task.
#
# Outputs something like this:
#
# currentGoalDescription
#   parentGoalDescription
#     grandfatherGoalDescription
function __stackTrace {
  local currentDir=$1
  local indentationAcc=$2
  local parentDir=$(dirname $currentDir)
  if [[ $(__is_task "$currentDir") == "true" ]]
  then
    __describeIndented "$currentDir" "$indentationAcc"
    __stackTrace "$parentDir" " $indentationAcc"
  fi
}