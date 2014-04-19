========
dotfiles
========

A set of dotfiles for use on a Unixy system.

Usage
=====

``src/`` contains the actual dotfiles, named without the preceding dot, so that
they show up in standard UIs and ls commands.

``install.sh`` symlinks everything in src/ to ~/.$filename.

``uninstall.sh`` undoes ``install.sh``'s hard work. It might give odd results
if you have not previously run ``install.sh``.

``lib/`` contains dependencies that do not need to be installed elsewhere.
