#!/bin/bash
#
# Provides stack-specific autocompletion

# The BASH-convention is the following:
# 
# Input:
# COMP_WORDS: an array containing individual command arguments typed so far
# COMP_CWORD: the index of the command argument containing the current cursor position
# COMP_LINE: the current command line
#
# Output:
# COMPREPLY: an array containing possible completions as a result of your function

if [ -z "$STACK_AUTOCOMPLETE_SOURCED" ]
then
  export STACK_AUTOCOMPLETE_SOURCED="true"
else
  return
fi

ALL_COMMANDS="help add push finish abandon reactivate focus concrete blur todo"

function __identify_command {
  if (( COMP_CWORD == 1 ))
  then 
    local cmd=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$ALL_COMMANDS" "$cmd") )
  fi
}

# We have to mask '-' by '~'
# otherwise we get collisions with compgen options.
STACK_ADD_OPTIONS="~~description ~~value"

# Autocomplete for `add` and `push` commands
#
# Proposes options `--description` and `--value`
function __addpush_autocomplete {
  local previous=""
  if (( COMP_CWORD > 1 ))
  then
    local prevIdx=$(( COMP_CWORD - 1 ))
    previous=${COMP_WORDS[prevIdx]}
  fi
  if [[ "$previous" == "--description" || "$previous" == "-d" ]]
  then
    COMPREPLY=( "brief" "description" )
  elif [[ "$previous" == "--value" || "$previous" == "-v" ]]
  then
    COMPREPLY=( "numeric" "value" )
  else 
    local maskedCmd=$(echo ${COMP_WORDS[COMP_CWORD]} | tr '-' '~')
    COMPREPLY=( $(compgen -W "$STACK_ADD_OPTIONS" "$maskedCmd" | tr '~' '-') )
  fi
}

# Trivial autocomplete for functions that do not require any arguments
function __trivial_autocomplete {
  COMPREPLY=( )
}

# enumerates subtasks that are neither .finished nor .abandoned
function __propose_active_subtasks {
  if (( COMP_CWORD == 1))
  then
    local cmd=${COMP_WORDS[COMP_CWORD]}
    local activeTasks=$(
      find . -maxdepth 1 \
      ! -path . \
      ! -path "*.finished.*" \
      ! -path "*.abandoned.*" \
      -type d -exec basename {} \; | tr '\n' ' '
    )
    COMPREPLY=( $(compgen -W "$activeTasks" "$cmd") )
  fi
}

# enumerates subtasks that are either .finished or .abandoned
function __propose_inactive_subtasks {
  if (( COMP_CWORD == 1 ))
  then
    local cmd=${COMP_WORDS[COMP_CWORD]}
    local finishedTasks=$(
      find . -maxdepth 1 -name ".finished.*" \
      -exec basename {} \; | tr '\n' ' ' | \
      sed 's/.finished.//g'
    )
    local abandonedTasks=$(
      find . -maxdepth 1 -name ".abandoned.*" \
      -exec basename {} \; | tr '\n' ' ' | \
      sed 's/.abandoned.//g'
    )
    local allFiles="$finishedTasks $abandonedTasks"
    COMPREPLY=( $(compgen -W "$allFiles" "$cmd") )
  fi
}