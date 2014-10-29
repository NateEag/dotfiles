dotfiles
========

A set of dotfiles for use on a Unixy system.

Includes remappings to make a MacBook Pro's keyboard feel more like a
TrulyErgonomic keyboard, and to make Emacsing on a TrulyErgonomic more
satisfactory. They are implemented with
[Karabiner](https://pqrs.org/osx/karabiner/) and
[Seil](https://pqrs.org/osx/karabiner/seil.html.en).

Also contains a semi-random collection of interpreted commands from third
parties, mostly in the form of npm packages.

Usage
=====

``src/`` contains the actual dotfiles, named without the preceding dot, so that
they show up in standard UIs and ls commands.

``install.sh`` symlinks everything in src/ to ~/.$filename.

``uninstall.sh`` undoes ``install.sh``'s hard work. It might give odd results
if you have not previously run ``install.sh``.

``lib/`` contains dependencies that do not need to be installed elsewhere.
