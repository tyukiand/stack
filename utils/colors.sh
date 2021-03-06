#!/bin/bash
#
# Defines a few colors used throughout the code

if [ -z "$STACK_COLORS_SOURCED" ]
then
  export STACK_COLORS_SOURCED="true"
else
  return
fi

errorColor='\033[0;31m'
successColor='\033[0;32m'
askColor='\033[0;37m'
defaultColor='\033[39m'
headerColor='\033[36m'

function echoError {
  msg="$1"
  echo -e "${errorColor}${msg}${defaultColor}"
}

function echoSuccess {
  msg="$1"
  echo -e "${successColor}${msg}${defaultColor}"
}