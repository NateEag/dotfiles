#! /bin/bash

# Set up auto-completion for my custom git commands.

_git_nuke_branch () {
    __gitcomp_nl "$(__git_heads)"
}
export _git_nuke_branch


_git_rename_branch () {
    __gitcomp_nl "$(__git_heads)"
}
export _git_rename_branch
