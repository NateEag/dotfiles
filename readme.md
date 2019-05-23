dotfiles
========

A set of dotfiles for use on a Unixy system, along with a few extras:

* Keyboard remappings to make a MacBook Pro's keyboard feel more like a
TrulyErgonomic keyboard. They are implemented with
[Karabiner-Elements][https://github.com/tekezo/Karabiner-Elements] for macOS >=
10.12, and [Karabiner](https://pqrs.org/osx/karabiner/) and
[Seil](https://pqrs.org/osx/karabiner/seil.html.en) for older Macs.

* A semi-random collection of useful third-party commands, mostly npm packages.

* A [Hammerspoon](http://www.hammerspoon.org/) configuration that's midway
  through replacing my [Slate](https://github.com/mattr-/slate) config, since
  Slate is abandonware these days.

Usage
=====

`src/` contains the actual dotfiles.

`.config/` contains folders to be symlinked into `~/.config`.

`install.sh` symlinks each file or top-level folder in src/ to ~/.$filename.

`uninstall.sh` undoes `install.sh`'s hard work. It might give odd results if
you have not previously run `install.sh`.

`bin/` contains my personal collection of command-line programs. They're mostly
wrappers around existing tools so I don't have to remember arcane interfaces.

`lib/` contains dependencies that do not need to be installed elsewhere.
