#!/bin/bash
#
# Contains functions used for validation of inputs and file content

# Checks whether a subtask name is valid
#
# Returns empty string if the name is valid, and if no subtask with this name
# already exists.
# Returns a comprehensible error message if the name is not valid.
function isValidSubtaskName {
  proposal="$1"
  if [[ "$subtaskName" =~ ^[_a-zA-Z0-9]+$ ]] 
  then
    if [ -d "$subtaskName"  ] || \
       [ -d ".finished.$subtaskName" ] || \
       [ -d ".abandoned.$subtaskName" ] 
    then
      echo "A task with this name already exists."
      echo "You might want to delete or reactivate"
      echo "hidden tasks (type `ls -a` to see all "
      echo "subtasks)."
    else 
      echo ""
    fi
  else
    echo "Invalid name '$subtaskName'"
    echo "The name can contain only a-z, A-Z, 0-9, _ (underscore)."
  fi
}

# Checks whether a string is a valid floating point value.
#
# Returns empty string if it is, or an error message otherwise.
function isValidValue {
  value=$1
  if [[ "$value" =~ ^[0-9]+(\.[0-9]+)?$ ]]
  then 
    : # everything allright, do not output any error messages
  else
    echo "Invalid value '$value'"
    echo "Requires positive floating-point value, e.g. '0.75' or '100500'"
    echo "(depending on the units you use)."
  fi
}