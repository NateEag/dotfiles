#! /bin/bash

# Install commands that ship as Python packages.
#
# Assumes [pipsi](https://github.com/mitsuhiko/pipsi) and virtualenv are
# installed (not via pyenv-virtualenv, because pipsi doesn't know about S).

set -e

if ! command -v pipsi; then
    curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py \
        | python
fi

project_dir=$(dirname $(dirname "$0"))

package_list="$project_dir/lib/python-commands.txt"

while read -r package_name; do
    pipsi install "$package_name"
done <"$package_list"
