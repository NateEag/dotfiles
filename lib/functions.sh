#! /bin/bash

# A small library of my own functions for use in bash scripting.
#
# Mostly yoinked from misc corners of the web.

# Echo the absolute path to $1. Capture output to a variable by subshelling:
# foo_abs_path=$(abspath $foo_rel_path)
# This one's all over the place - just know I didn't write it.
abspath () {
  # $1 : relative filename
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

# Adapted from http://stackoverflow.com/a/449890/1128957.
randline () {
    head -$((RANDOM % `wc -l < "$1"` + 1)) "$1" | tail -1
}
