#! /bin/bash

# Undo the work of install.sh.
# This may have unexpected results if you never ran install.sh.

dir=$(dirname $0)/src

for filename in $(ls -a $dir);
do
    target_path="$HOME/$filename"

    if [ "$filename" == "." ] || [ "$filename" == ".." ]; then
	continue
    fi

    if [ "$filename" = ".gitconfig" ]; then
        # Install gitconfig to secondary git config path, so ~/.gitconfig can
        # be used to override settings per-machine. This is handy for
        # working on an employer's machine, so you can default repos to your
        # work email address but keep your other git settings.
        # Note: Older gits will not read from this path.
        target_path="$HOME/.config/git/config"
    fi

    rm -f "$target_path"
    if [ -e "$target_path".old ]; then
        mv "$target_path".old "$target_path"
    fi
done
