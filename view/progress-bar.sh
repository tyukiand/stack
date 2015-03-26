#!/bin/bash
#
# Implementation of a colored resizable progress bar

if [ -z "$STACK_PROGRESS_BAR_SOURCED" ]
then
  export STACK_PROGRESS_BAR_SOURCED="true"
else
  return
fi

source "${STACK_PATH}/utils/colors.sh"

# round function: simply cuts of everything after "."
function round {
  local cutoff=$(echo "$1" | sed -e "s/\..*//")
  if [[ -z "$cutoff" ]]
  then
    echo 0
  else
    echo $cutoff
  fi
}

# Writes a pretty colored progress bar to standard output.
#
# accepts a number in [0,1] and a total length of the progress bar
# writes a pretty progress bar
function __progress_bar {
  # read the arguments
  local FRACTION=$1
  local LENGTH=$2
  local DONE_COLOR=$3
  local TODO_COLOR=$4

  if [ -z "$DONE_COLOR" ] 
  then
    DONE_COLOR='\033[01;32m'
  fi
  
  if [ -z "$TODO_COLOR" ] 
  then
    TODO_COLOR='\033[01;35m'
  fi

  #echo -e "DEBUG: done color = $DONE_COLOR [TEST]\033[00m"
  #echo -e "DEBUG: todo color = $TODO_COLOR [TEST]\033[00m"

  # draw the bar
  DONE_LENGTH=$(round $(echo "$FRACTION * $LENGTH" | bc -l))
  REMAINING_LENGTH=$(echo "$LENGTH - $DONE_LENGTH" | bc -l)
  PERCENTAGE_PREFIX=$(echo "$FRACTION * 100" | bc -l | 
    grep -o -E "^[0-9]*(\.[0-9]{1,2})?")
  if [[ "$PERCENTAGE_PREFIX" == "100.00" ]] 
  then
    PERCENTAGE_PREFIX="100.0"
  fi
  PERCENTAGE_STRING="${PERCENTAGE_PREFIX}%"
  PERCENTAGE_STRING_LENGTH=$(echo -n "$PERCENTAGE_STRING" | wc -c)
  PADDING_LENGTH=$(( 6-$PERCENTAGE_STRING_LENGTH ))
    
  for X in $(seq 1 $PADDING_LENGTH)
  do 
    echo -n " "
  done
  
  if [[ "$FRACTION" =~ ^0\.?0*$ ]]
  then 
    echo -e -n "$TODO_COLOR"
  else
    echo -e -n "$DONE_COLOR"
  fi
  
  echo -n "$PERCENTAGE_STRING "
  for X in $(seq 1 $DONE_LENGTH) ; do echo -n "#" ; done
  echo -e -n "$TODO_COLOR"
  for X in $(seq 1 $REMAINING_LENGTH) ; do echo -n "-"; done
  echo -e -n "${defaultColor}"
}