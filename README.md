# Stack 4.0

This collection of bash scripts helps to keep track of multiple 
hierarchically organized subtasks.

Stack` 4.0  is an attempt to mitigate a fundamental deficiency of
the human brain, namely the inability to cope with deep and branched 
trees of subtasks when solving a problem. The brain is good at 
recognizing patterns, but it does not have a good hardware 
implementation of a *stack*: whenever the number of subtasks becomes
larger than 5-10, one is usually better off making some kind of
todo-list. However, lists are flat, but problems with all the 
subproblems are rather trees or DAGs. This software implements 
a *stack* that helps to keep track of multiple hierarchically 
ordered subtasks. The data structure is mapped directly do 
directories of a Linux operating system, and therefore it is also
possible to represent arbitrary DAGs, if one wants to.

# Design

Previous four versions (some implemented in Java, some in Scala, some backed 
by XML files, SQL-databases, by plain text-files and directories, 
or by files written in a custom language) turned out to be too rigid and cumbersome, 
so in this version we return to the design of the very first version, 
and admit that directory structures already are the most efficient way to represent
nested subtasks. This software consists entirely of bash scripts that 
operate directly on text files and directories.

Tasks are represented by directories that contain two hidden files: 
`.description.txt` and a
`.task-properties.kv`. 
All subtasks are represented by subdirectories. 
Everything can be moved around and edited manually using the shell.

# Usage
Simply `cd` into a directory with the tasks, then call `stack`. This will start a new
bash console with a bunch of stack-specific commands. 
There is detailed documentation and autocompletion support for each command. 
Type `help` to get some overview.
