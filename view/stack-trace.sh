#!/bin/bash
#
# Printing breadcrumb/stack-trace-like representations of task hierarchies

source "${STACK_PATH}/utils/colors.sh"

# Writes an indented single-line description of a task
#
# Expects directory of the task and indentation as parameters.
# This is essentially a piece of the __stackTrace function that
# helps to construct indented breadcrumbs.
function __describeIndented {
  local directory="$1"
  local indentation="$2"
  if [ -f "$directory/.tast_properties.kv" ] # TODO: replace by "isTask" or sth.
  then 
    cd "$directory"
    source "${STACK_PATH}/persistence/read-task-properties.sh"
    echo "${indentation}${TASK_NAME} " # (Value: $TASK_VALUE)"
    cd -
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
  if [ -f "$currentDir/.task_properties.kv" ]
  then
    describeIndented "$currentDir" "$indentationAcc"
    stackTrace "$parentDir" "  $indentationAcc"
  fi
}