#! /bin/bash

# Unlink all files in containing directory that do not have an extension from
# ~/.$FILENAME.

dir=$(dirname $0)

for filename in $(ls $dir);
do
    dot_idx=$(awk -v a="$filename" -v b="." 'BEGIN{print index(a,b)}')
    if [ "$dot_idx" -lt "1" ]; then
        rm ~/.$filename
    fi
done
