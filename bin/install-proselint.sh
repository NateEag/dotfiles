#! /bin/bash

# Lame little script to install proselint for use by flycheck. I don't like
# having platform-specific binary files in a repo, or else I'd just commit it.

# NOTE WELL: If you're on OS X 10.6.8, built-in Python's got an SSL issue that
# makes installing things via pip unworkable. To use this script on that
# platform, install a more recent Python and get it first on your path. Once
# the virtualenv's built, that shouldn't matter, of course...

project_dir=$(dirname $(dirname "$0"))
virtualenv $project_dir/lib/proselint

source $project_dir/lib/proselint/bin/activate

# Recent versions of virtualenv auto-install pip, but for a sufficiently old
# version you may need to uncomment this.
#easy_install pip

pip install proselint