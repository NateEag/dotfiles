========
dotfiles
========

A set of dotfiles for use on a Unixy system.

Usage
=====

``install.sh`` symlinks everything in src/ to ~/.$filename. It moves files that
would be clobbered to ~/.$filename.old.

``uninstall.sh`` undoes ``install.sh``'s hard work. It might give odd results
if you have not previously run ``install.sh``.

The ``lib`` directory holds things the dotfiles depend on, usually from
third-party sources.
