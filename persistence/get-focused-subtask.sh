#!/bin/bash
#
# Gets `FOCUSED_SUBTASK` variable from `.task_properties.kv`
#
# Returns an empty string if the value cannot be found.

FOCUSED_SUBTASK=''
if [ -f '.task_properties.kv' ] 
then
  for hit in $(grep '^FOCUSED_SUBTASK=.*' .task_properties.kv)
  do
    FOCUSED_SUBTASK=$(echo "$hit" | cut -d'=' -f2-)
  done
fi