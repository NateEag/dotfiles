#! /bin/bash

# Import .bashrc if it's available.
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Setting PATH for MacPython 2.6
# The orginal version is saved in .bash_profile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/2.6/bin:${PATH}"
# export PATH

if [ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]; then . "$HOME"/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
