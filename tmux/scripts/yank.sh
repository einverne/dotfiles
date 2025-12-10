#!/bin/bash
# OSC 52 clipboard copy script
# This script copies stdin to the local clipboard using OSC 52 escape sequence
# Works even when running tmux on a remote server

# Read input from stdin or argument
if [ -t 0 ]; then
    # Input from argument
    input="$*"
else
    # Input from stdin
    input=$(cat)
fi

# Get the length of input
len=$(printf %s "$input" | wc -c)

# OSC 52 has a maximum length, usually 100000 bytes
max_len=100000
if [ "$len" -gt "$max_len" ]; then
    echo "Input is too long for OSC 52 (max $max_len bytes)" >&2
    exit 1
fi

# Base64 encode the input
encoded=$(printf %s "$input" | base64 | tr -d '\r\n')

# Send OSC 52 escape sequence
# Format: \033]52;c;<base64>\007
# Where 'c' means clipboard
printf "\033]52;c;%s\007" "$encoded"
