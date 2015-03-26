#!/bin/bash
#
# Provides getters and setters for focused subtasks

if [ -z "$STACK_FOCUSED_SUBTASK_SOURCED" ] 
then
  export STACK_FOCUSED_SUBTASK_SOURCED="true"
else
  return
fi

# Updates the `FOCUSED_SUBTASK` variable in `.task_properties.kv`
#
# Looks for a `.task_properties.kv` file in 
# the current directory. Checks whether it 
# contains a `focused` variable, updates or adds
# it with the new updated value.
function __set_focused_subtask {
  newFocusedSubtask=$(echo "$1" | tr -d '/') # remove trailing slashes 
  
  if [ -f '.task_properties.kv' ] 
  then
    if [[ "$(grep '^FOCUSED_SUBTASK=' .task_properties.kv | wc -l)" == '1' ]]
    then
      # update
      sed -i -e "s/FOCUSED_SUBTASK=.*/FOCUSED_SUBTASK=${newFocusedSubtask}/g" \
        .task_properties.kv
    else
      # insert 
      echo "FOCUSED_SUBTASK=${newFocusedSubtask}" >> .task_properties.kv
    fi
  else
    echo "This directory does not seem to represent a valid task."
  fi
}

# Gets `FOCUSED_SUBTASK` variable from `.task_properties.kv`
#
# Returns an empty string if the value cannot be found.
function __get_focused_subtask {
  local FOCUSED_SUBTASK=""
  if [ -f '.task_properties.kv' ] 
  then
    for hit in $(grep '^FOCUSED_SUBTASK=.*' .task_properties.kv)
    do
      FOCUSED_SUBTASK=$(echo "$hit" | cut -d'=' -f2-)
    done
  fi
  echo "$FOCUSED_SUBTASK"
}