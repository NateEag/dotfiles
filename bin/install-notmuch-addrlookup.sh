#! /usr/bin/env bash

# Download and install notmuch-addrlookup to local bin directory.
#
# Assumes OS X, with a glib install via Homebrew and git on $PATH.
#
# TODO Turn this into a Homebrew recipe, for future generations?
# It's just a few env vars to set.

. ~/.bashrc

cd ~

if [ ! -d ~/notmuch-addrlookup-c ]; then
    git clone https://github.com/aperezdc/notmuch-addrlookup-c
fi

cd notmuch-addrlookup-c

export LDFLAGS='-L/usr/local/Cellar/glib/2.46.2/lib/ -lglib-2.0'
export CPPFLAGS='-I/usr/local/include/glib-2.0/ -I/usr/local/lib/glib-2.0/include/'

make

mkdir -p ~/bin
cp notmuch-addrlookup ~/bin
