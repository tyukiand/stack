#!/bin/bash
#
# Implementation of a colored resizable progress bar

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
  FRACTION=$1
  LENGTH=$2
  
  # draw the bar
  DONE_LENGTH=$(round $(echo "$FRACTION * $LENGTH" | bc -l))
  REMAINING_LENGTH=$(echo "$LENGTH - $DONE_LENGTH" | bc -l)
  PERCENTAGE_STRING=$(echo "$FRACTION * 100" | bc -l | 
    grep -o -E "^[0-9]*(\.[0-9]{1,2})?")'%'
  PERCENTAGE_STRING_LENGTH=$(echo -n "$PERCENTAGE_STRING" | wc -c)
  PADDING_LENGTH=$(( 6-$PERCENTAGE_STRING_LENGTH ))
    
  for X in $(seq 1 $PADDING_LENGTH)
  do 
    echo -n " "
  done
  
  if [[ "$FRACTION" =~ ^0\.?0*$ ]]
  then 
    echo -e -n "\033[01;35m"
  else
    echo -e -n "\033[01;32m"
  fi
  
  echo -n "$PERCENTAGE_STRING "
  for X in $(seq 1 $DONE_LENGTH) ; do echo -n "#" ; done
  echo -e -n "\033[01;31m"
  for X in $(seq 1 $REMAINING_LENGTH) ; do echo -n "-"; done
  echo -e -n "\033[00m"
}