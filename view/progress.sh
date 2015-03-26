#!/bin/bash

if [ -z "$STACK_PROGRESS_SOURCED" ]
then
  export STACK_PROGRESS_SOURCED="true"
else
  return
fi

source "${STACK_PATH}/persistence/task-properties.sh"

# Calculates progress on the current goal.
# 
# Recursively computes the overall progress.
# Returns a number between 0.0 and 1.0.
function __calculate_progress {
  local CURRENT_GOAL_NAME=$(basename $(pwd))
  if [[ "$CURRENT_GOAL_NAME" =~ ^\.finished\..*$ ]]
  then
    echo "1.0"
  else
    local TOTAL_VALUE=0.0
    local FINISHED_VALUE=0.0
    for SUBGOAL in $(find . -maxdepth 1 -type d | grep ^\./.)
    do
      cd $SUBGOAL
      __get_task_properties
      SUBGOAL_VALUE=$TASK_VALUE
      SUBGOAL_PROGRESS=$( __calculate_progress )
      # arithmetic context doesn't work, not-integer values
      TOTAL_VALUE=$(echo "$TOTAL_VALUE + $SUBGOAL_VALUE" | bc -l)
      FINISHED_VALUE=$(
        echo "$FINISHED_VALUE + $SUBGOAL_VALUE * $SUBGOAL_PROGRESS" | bc -l
      )
      cd ..
    done

    if [[ "$TOTAL_VALUE" =~ ^0\.?0*$ ]]
    then
      echo "0"
    else
      local RESULT_PROGRESS=$(echo "$FINISHED_VALUE / $TOTAL_VALUE" | bc -l)
      echo $RESULT_PROGRESS
    fi
  fi
}