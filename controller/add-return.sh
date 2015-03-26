#!/bin/bash
#
# Prints values set by add.sh
#
# A little work-around for returning values from a 
# complex script that produces some echo-output that
# is supposed to be read by user.
# 
# `add.sh` sets lots of variables, but not all of them 
# should be treated as "return values". Instead, we
# source `add.sh` here, and print only those variables that
# make sense in other scripts. These variables can be evaluated
# using the `eval`.
source "${STACK_PATH}/controller/add.sh"      # this sets `LAST_CREATED_TASK`,
                                              # but also tons of other stuff.
echo "LAST_CREATED_TASK=$LAST_CREATED_TASK"   # this exposes `LAST_CREATED_TASK`