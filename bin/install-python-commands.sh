#! /usr/bin/env bash

# Install commands that ship as Python packages.
#
# Assumes [pipx](https://pypi.org/project/pipx/) is installed.
#
# Note that packages which depend on Python 2 (such as jmespath-terminal) will
# not work with this script. Installing them into pyenv's global python2
# version is the best workaround I've come up with so far, but it's not a
# satisfactory one.

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
