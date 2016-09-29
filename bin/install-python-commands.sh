#! /bin/bash

# Install commands that ship as Python packages.
#
# Assumes [pyenv](https://github.com/yyuu/pyenv) and
# [pyenv-virtualenv](https://github.com/yyuu/pyenv-virtualenv) are installed.
#
# We install each one into its own virtualenv, so that there is no possibility
# of conflicting dependencies.j
#
# To keep that from making PATH ugly, we also put symlinks to the binaries in a
# single folder, which is then added to PATH.
#
# ...this great theory turned out not to work, because pyenv install clever
# global shims that just hacking PATH cannot bypass. These clever shims detect
# it when you run a command for a virtualenv that's not active and tell you
# "Sorry, that doesn't exist globally, but this does!" so helpful. :P

# Be sure pyenv and the virtualenv plugin are set up.
eval "$(pyenv init -)"
eval "$pyenv virtualenv-init -"

project_dir=$(dirname $(dirname "$0"))

package_list="$project_dir/lib/python-commands.txt"

pyenv install 2.7.12

while read package_name; do
    echo "$package_name"
    pyenv virtualenv 2.7.12 "$package_name"
    pyenv activate "$package_name"
    pip install "$package_name"
    pyenv deactivate

    # Don't see a way to get pyenv to tell me this path; therefore, hardcoding
    # it.
    #
    # Also note the assumption that $package_name is the command's name in the
    # package. If I install more, that might change somehow.
    ln -s "~/.pyenv/versions/$package_name/bin/$package_name" \
       "$project_dir/lib/python-commands/$package_name"
done <"$package_list"
