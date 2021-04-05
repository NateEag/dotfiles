#! /bin/bash

# Install commands that ship as Python packages.
#
# Assumes [pipsi](https://github.com/mitsuhiko/pipsi) and virtualenv are
# installed (not via pyenv-virtualenv, because pipsi doesn't know about S).

if ! command -v pipx; then
    brew install pipx
fi

project_dir=$(dirname $(dirname "$0"))

package_list="$project_dir/lib/python-commands.txt"

while read -r package_name; do
    pipx install "$package_name"
done <"$package_list"

echo "Remember to manually install chrome-pass with python3, then to run"
echo
echo "    nativePass install"
echo
echo "...or figure out how to automate the installation with pipx."
