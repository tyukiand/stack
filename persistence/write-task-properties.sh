#!/bin/bash
#
# Persists properties of a task in an `.task_properties.kv` file.
# 
# The `kv` ending stands for key-value pairs.
# Expects task name, value, and a focused subtask as 
# arguments.

taskName=$1
value=$2
focused=$3

touch .task_properties.kv
# echo "# You can modify this file as user, " >> .task_properties.kv
# echo "# but make sure you don't introduce any spaces." >> .task_properties.kv
# echo "# The format is: " >> .task_properties.kv
# echo "# KEY=VALUE " >> .task_properties.kv
# echo "# without any extra empty spaces between KEY, =, and VALUE" >> \
#   .task_properties.kv
echo "TASK_NAME=${taskName}" >> .task_properties.kv
echo "TASK_VALUE=${value}" >> .task_properties.kv
echo "FOCUSED_SUBTASK=" >> .task_properties.kv