#! /bin/bash

# Link all files in containing directory that do not have an extension from
# ~/.$FILENAME.

dir=$(dirname $0)

for filename in $(ls $dir);
do
    dot_idx=$(awk -v a="$filename" -v b="." 'BEGIN{print index(a,b)}')
    if [ "$dot_idx" -lt "1" ]; then
        dotfiles_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

        if [ -e ~/.$filename ]; then
            mv ~/.$filename ~/.$filename.old
        fi

        ln -s $dotfiles_dir/$filename ~/.$filename
    fi
done
