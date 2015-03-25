#!/bin/bash
#
# Updates the `focused` variable in `.task_properties.kv`
#
# Looks for a `.task_properties.kv` file in 
# the current directory. Checks whether it 
# contains a `focused` variable, updates or adds
# it with the new updated value.

newFocusedSubtask=$(echo "$1" | tr -d '/') # remove trailing slashes 

if [ -f '.task_properties.kv' ] 
then
  if [[ "$(grep '^FOCUSED_SUBTASK=' .task_properties.kv | wc -l)" == '1' ]]
  then
    sed -i -e "s/FOCUSED_SUBTASK=.*/FOCUSED_SUBTASK=${newFocusedSubtask}/g" \
      .task_properties.kv
  else
    echo "FOCUSED_SUBTASK=${newFocusedSubtask}" >> .task_properties.kv
  fi
else
  echo "This directory does not seem to represent a valid task."
fi