# Base bash settings — portable subset

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# History length
HISTSIZE=100000
HISTFILESIZE=200000

# Check the window size after each command
shopt -s checkwinsize
