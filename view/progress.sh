#!/bin/bash

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
      source "${STACK_PATH}/persistence/read-task-properties.sh"
      SUBGOAL_VALUE=$TASK_VALUE
      SUBGOAL_PROGRESS=$( __calculate_progress )
      TOTAL_VALUE=$(( $TOTAL_VALUE + $SUBGOAL_VALUE ))
      FINISHED_VALUE=$(( $FINISHED_VALUE + $SUBGOAL_VALUE * $SUBGOAL_PROGRESS ))
      cd ..
    done

    if [[ "$TOTAL_VALUE" =~ ^0\.?0*$ ]]
    then
      echo "0"
    else
      local RESULT_PROGRESS=$(( $FINISHED_VALUE / $TOTAL_VALUE ))
      echo $RESULT_PROGRESS
    fi
  fi
}