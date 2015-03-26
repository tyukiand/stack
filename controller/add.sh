#!/bin/bash
#
# Defines functions that are used for initialization of new tasks

if [ -z "$STACK_ADD_SOURCED" ]
then 
  export STACK_ADD_SOURCED="true"
else 
  return
fi

source "${STACK_PATH}/utils/validation.sh"
source "${STACK_PATH}/utils/colors.sh"

# Creates a new task. 
#
# This includes creating a directory for the task, 
# writing task properties into a key-value file, and
# adding a description in a simple text file.
#
# Sets a variable `LAST_CREATED_TASK` if successful.
function __add_new_task {

  # The variables that must be entered by the user, or parsed from the 
  # arguments.
  local subtaskName=""
  local description=""
  local value="1.0"

  # declare everything local so that we don't contaminate anything else.
  local errMsg=""
  local argsValid="true"
  local subtaskNameValid=""
  local valueValid=""
  local optionName=""

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
        echoError "$errMsg"
      fi
    done

    # Wait until the user enters a valid numeric value
    valueValid="false"
    while [[ $valueValid != "true" ]]
    do
      echo -n -e \
        "${askColor}Value (ENTER for default value=1.0): ${defaultColor}" 
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
        echoError "$errMsg"
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
            echoError "${errMsg}"
          fi
        ;;
        * ) 
          echoError "Unrecognized option: $optionName"
          argsValid="false"
        ;;
      esac
    done
    
    # parse the task name
    subtaskName="$1"
    errMsg=$(isValidSubtaskName "$subtaskName")
    if [[ ! -z "$errMsg" ]]
    then
      echoError "${errMsg}"
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
    __set_task_properties "$subtaskName" "$value" ""
    touch ".description.txt"
    echo "$description" >> .description.txt 
    echoSuccess "Added new subtask '$subtaskName'"
    cd ..
  
    # This variable is sourced and exposed by `add-return.sh`
    LAST_CREATED_TASK="$subtaskName"
  fi
}