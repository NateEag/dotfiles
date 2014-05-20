#! /bin/bash

# Set up auto-completion for my custom git commands.

_git_nuke_branch () {
    __gitcomp_nl "$(__git_refs)"
}

export _git_nuke_branch
