#! /bin/bash

# Set up the current user's account to use the files in src/ as dotfiles.

# If arguments are passed, each one is a filename to install from src/.

dotfiles_dir=$(dirname $0)
source $dotfiles_dir/lib/functions.sh
dotfiles_dir=$(abspath $dotfiles_dir)

src_dir="$dotfiles_dir/src/"
files_to_install=$(ls $src_dir)
if [[ $# -gt 0 ]]; then
    files_to_install="$@"
fi

for filename in $files_to_install;
do
    if [ -e ~/.$filename ]; then
        echo "~/.$filename already exists. Not overwriting." >&2
    else
        ln -s "$src_dir/$filename" ~/'.'$filename
    fi
done
