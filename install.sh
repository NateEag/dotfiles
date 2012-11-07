#! /bin/bash

# Set up the current user's account to use the files in src/ as dotfiles.

dotfiles_dir=$(dirname $0)/src

for filename in $(ls $dotfiles_dir);
do
    if [ -e ~/.$filename ]; then
        mv ~/.$filename ~/.$filename.old
    fi

    ln -s $dotfiles_dir/$filename ~/.$filename
done
