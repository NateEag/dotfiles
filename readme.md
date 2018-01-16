dotfiles
========

A set of dotfiles for use on a Unixy system, along with a few extras:

* Keyboard remappings to make a MacBook Pro's keyboard feel more like a
TrulyErgonomic keyboard. They are implemented with
[Karabiner-Elements][https://github.com/tekezo/Karabiner-Elements] for macOS >=
10.12, and [Karabiner](https://pqrs.org/osx/karabiner/) and
[Seil](https://pqrs.org/osx/karabiner/seil.html.en) for older Macs.

* A semi-random collection of useful third-party commands, mostly npm packages.

* A not-very-comprehensive [Slate](https://github.com/mattr-/slate) config.
  Since Slate is abandonware these days, I'm considering moving to
  [Hammerspoon](), but then I'm considering leaving OS X entirely, so it might
  just be a waste of time.

* My personal [Plover](http://stenoknight.com/wiki/Main_Page) dictionary. Note
  that I am a complete novice with Plover and stenography, so it may contain
  some poor choices. You have to start somewhere...

Usage
=====

``src/`` contains the actual dotfiles.

``install.sh`` symlinks each file or top-level folder in src/ to ~/.$filename.

``uninstall.sh`` undoes ``install.sh``'s hard work. It might give odd results
if you have not previously run ``install.sh``.

``lib/`` contains dependencies that do not need to be installed elsewhere.
