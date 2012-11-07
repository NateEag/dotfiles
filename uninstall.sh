#! /bin/bash

# Undo the work of install.sh.
# This may have unexpected results if you never ran install.sh.

dir=$(dirname $0)/src

for filename in $(ls $dir);
do
    rm ~/.$filename
    if [ -e ~/.$filename.old ]; then
        mv ~/.$filename.old ~/.$filename
    fi
done
