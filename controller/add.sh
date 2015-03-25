#!/bin/bash
#
# Creates a new task. 
#
# This includes creating a directory for the task, 
# writing task properties into a key-value file, and
# adding a description in a simple text file.
#
# Sets a variable `LAST_CREATED_TASK` if successful.

errorColor='\033[0;31m'
successColor='\033[0;32m'
askColor='\033[0;37m'
defaultColor='\033[39m'

# load utility functions that are used to validate the input
source "${STACK_PATH}/utils/validation.sh"

# The variables that must be entered by the user, or parsed from the 
# arguments.
subtaskName=""
description=""
value="1.0"

argsValid="true"

if (( $# == 0 )) 
then
  # interactive mode

  # Wait until the user enters a valid subtask name
  subtaskNameValid="false"
  while [[ $subtaskNameValid != "true" ]] 
  do 
    echo -n -e "${askColor}Name of the subtask "
    echo -n -e "(ENTER to abort): ${defaultColor}" 
    read subtaskName
    if [[ -z "$subtaskName" ]]
    then
      # Abort
      echo -e "${askColor}Aborting.${defaultColor}"
      exit 0
    fi
    errMsg=$(isValidSubtaskName "$subtaskName")
    if [[ -z "$errMsg" ]]
    then
      subtaskNameValid="true"
    else
      echo -e "${errorColor}${errMsg}${defaultColor}"
    fi
  done

  # Wait until the user enters a valid numeric value
  valueValid="false"
  while [[ $valueValid != "true" ]]
  do
    echo -n -e "${askColor}Value (ENTER for default value=1.0): ${defaultColor}" 
    read value
    if [[ -z "$value" ]]
    then
      value="1.0"
    fi
    errMsg=$(isValidValue "$value")
    if [[ -z "$errMsg" ]]
    then
      valueValid="true"
    else
      echo -e "${errorColor}${errMsg}${defaultColor}"
    fi
  done

  # Let the user enter a short description
  echo -e "${askColor}Enter a short description:${defaultColor}"
  read description

  argsValid="true"

else
  # parse new task description from the arguments

  # parse options
  while (( $# != 1 )) 
  do
    optionName="$1"
    shift
    case "$optionName" in
      "--description" | "-d" ) 
        description="$1"
        shift
      ;;
      "--value" | "-v" )
        value="$1"
        shift
        errMsg=$(isValidValue "$value")
        if [[ ! -z "$errMsg" ]]
        then
          argsValid="false"
          echo -e "${errorColor}${errMsg}${defaultColor}"
        fi
      ;;
      * ) 
        echo "Unrecognized option: $optionName"
        argsValid="false"
      ;;
    esac
  done
  
  # parse the task name
  subtaskName="$1"
  errMsg=$(isValidSubtaskName "$subtaskName")
  if [[ ! -z "$errMsg" ]]
  then
    echo -e "${errorColor}${errMsg}${defaultColor}"
    argsValid="false"
  fi
fi

# if the input is allright, create new directory, file and description
if [[ $argsValid == "true" ]]
then

  # create new directory that represets a task, add key-value file and
  # a description file
  mkdir "$subtaskName"
  cd "$subtaskName" 
  "$STACK_PATH"/persistence/write-task-properties.sh "$subtaskName" "$value" ""
  touch "description.txt"
  echo "$description" >> description.txt 
  echo -e "${successColor}Added new subtask '$subtaskName'${defaultColor}"
  cd ..

  # This variable is sourced and exposed by `add-return.sh`
  LAST_CREATED_TASK="$subtaskName"
fi