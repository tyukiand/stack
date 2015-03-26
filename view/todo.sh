#!/bin/bash
#
# Shows what has to be done for the current task

source "${STACK_PATH}/utils/colors.sh"
source "${STACK_PATH}/view/stack-trace.sh"
source "${STACK_PATH}/view/progress.sh"
source "${STACK_PATH}/view/progress-bar.sh"
source "${STACK_PATH}/persistence/read-task-properties.sh"

clear
echo -e "$(basename $(pwd))" 
__progress_bar $(__calculate_progress) 73

echo -e "${headerColor}
_________________________________  Statement  __________________________________
${defaultColor}"

  __stackTrace $(pwd)
  echo -e "${headerColor}
_________________________________  Subtasks   __________________________________
${defaultColor}"

  # ls -1
  for SUBGOAL_FULLPATH in $(find . -maxdepth 1 -type d | grep "^\./.*")
  do
    local SUBGOAL=$(basename $SUBGOAL_FULLPATH)
    if [[ ! $(basename $SUBGOAL) =~ \.finished\..* ]] && 
       [[ ! $(basename $SUBGOAL) =~ \.abandoned\..* ]]
    then
      cd $SUBGOAL
      __read_task_properties
      local BAR_STR="$(__progress_bar $(__calculate_progress) 23)"
      local HEAD_STR="$BAR_STR ($TASK_VALUE) $TASK_NAME"
      local HEAD_LENGTH=$(#HEAD_STR)
      TAIL_LENGTH=$(( 74 - $HEAD_LENGTH ))
      DESCRIPTION=$( head -n 1 .description.txt ) # TODO: move to persistence 
      if (( ${#DESCRIPTION} < TAIL_LENGTH ))
      then
        local TAIL_STR="$DESCRIPTION"
      else
        local TAIL_STR="${DESCRIPTION:0:$(( TAIL_LENGTH - 3 ))}..."
      fi

      echo "$HEAD_STR" # tail string length calculation is somewhat weird due
                       # to colored prompt in the moment...









                       HERE : what is TAIL_STR, why not used?
      cd ..
    fi  
  done

  echo -e "$HEADING_COLOR
_______________________________  Description  __________________________________
${defaultColor}"

  cat .knowledge

  echo -e "$HEADING_COLOR
____________________________  Sub-(sub)*-tasks  ________________________________
$BACK_TO_NORMAL"

  tree -d
}

