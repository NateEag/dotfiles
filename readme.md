dotfiles
========

A set of dotfiles for use on a Unixy system, along with a few extras:

* Keyboard remappings to make a MacBook Pro's keyboard feel more like a
TrulyErgonomic keyboard, and to make Emacsing on a TrulyErgonomic more
satisfactory. They are implemented with
[Karabiner](https://pqrs.org/osx/karabiner/) and
[Seil](https://pqrs.org/osx/karabiner/seil.html.en).

* A semi-random collection of useful third-party commands, mostly npm packages.

* A not-very-comprehensive [Slate](https://github.com/jigish/slate) config.

Usage
=====

``src/`` contains the actual dotfiles, named without the preceding dot, so that
they show up in standard UIs and ls commands. I'm beginning to regret that
decision and may yet change it.

``install.sh`` symlinks each file or top-level folder in src/ to ~/.$filename.

``uninstall.sh`` undoes ``install.sh``'s hard work. It might give odd results
if you have not previously run ``install.sh``.

``lib/`` contains dependencies that do not need to be installed elsewhere.
