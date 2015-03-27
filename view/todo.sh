#!/bin/bash
#
# Shows what has to be done for the current task

if [ -z "$STACK_TODO_SOURCED" ]
then 
  export STACK_TODO_SOURCED="true"
else 
  return
fi

source "${STACK_PATH}/utils/colors.sh"
source "${STACK_PATH}/view/stack-trace.sh"
source "${STACK_PATH}/view/progress.sh"
source "${STACK_PATH}/view/progress-bar.sh"
source "${STACK_PATH}/persistence/task-properties.sh"

function __show_todo {
  clear
  echo -e "$(basename $(pwd))" 
  __progress_bar $(__calculate_progress) 73
  
  echo -e "${headerColor}
_______________________________  Stack trace  __________________________________
  ${defaultColor}"
  
    __stackTrace $(pwd)
    echo -e "${headerColor}
_________________________________  Subtasks   __________________________________
  ${defaultColor}"
    local PARENT_FOCUS=$(__get_focused_subtask)
    # ls -1
    for SUBGOAL_FULLPATH in $(find . -maxdepth 1 -type d | grep "^\./.*")
    do
      local SUBGOAL=$(basename $SUBGOAL_FULLPATH)  
      if [[ ! $(basename $SUBGOAL) =~ \.abandoned\..* ]]
      then
       
        local DONE_COLOR=""
        local TODO_COLOR=""
        local LINE_COLOR="${defaultColor}"

        if [[ $(basename $SUBGOAL) =~ \.finished\..* ]]
        then 
          DONE_COLOR='\e[38;5;22m'
          TODO_COLOR='\e[38;5;57m'
          LINE_COLOR='\033[01;90m'
        fi 

        cd $SUBGOAL
        __get_task_properties
        local BAR_STR="$(
          __progress_bar $(__calculate_progress) 23 "$DONE_COLOR" "$TODO_COLOR"
        )"
        local HEAD_STR="$BAR_STR"
        if [[ "$SUBGOAL" == "$PARENT_FOCUS" ]]
        then
          HEAD_STR="${HEAD_STR} \033[01;93m->"
        fi
        HEAD_STR="$HEAD_STR ${LINE_COLOR}($TASK_VALUE) $TASK_NAME"
        local COLORLESS_HEAD=$(echo -e "$HEAD_STR" | tr -d [:cntrl:])
        local HEAD_LENGTH=${#COLORLESS_HEAD}

        # tail string length calculation is somewhat weird due
        # to colored prompt in the moment... 
        # (the number 98 has been found experimentally by bisecting)
        TAIL_LENGTH=$(( 106 - $HEAD_LENGTH ))
        if (( TAIL_LENGTH < 0 ))
        then
          TAIL_LENGTH=0
        fi
        DESCRIPTION=$( __get_short_description )
        
        if (( ${#DESCRIPTION} < TAIL_LENGTH ))
        then
          local TAIL_STR="$DESCRIPTION"
        else
          local reducedLength=$TAIL_LENGTH
          if (( reducedLength >= 3 ))
          then
            reducedLength=$(( reducedLength - 3 ))
          fi
          local TAIL_STR="${DESCRIPTION:0:${reducedLength}}..."
        fi

        echo -e "$HEAD_STR [$TAIL_STR]${defaultColor}" 
        cd ..
      fi  
    done

    echo -e "${headerColor}
_______________________________  Description  __________________________________
  ${defaultColor}"
  
    cat .description.txt
  
#    echo -e "$HEADING_COLOR
#____________________________  Sub-(sub)*-tasks  ________________________________
#  $BACK_TO_NORMAL"
#
#  tree -d
}