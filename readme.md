## dotfiles

A set of dotfiles for use on a Unixy system, along with a few extras:

* Keyboard remappings to make a MacBook Pro's keyboard feel more like a
TrulyErgonomic keyboard. They are implemented with
[Karabiner-Elements][https://github.com/tekezo/Karabiner-Elements] for macOS >=
10.12, and [Karabiner](https://pqrs.org/osx/karabiner/) and
[Seil](https://pqrs.org/osx/karabiner/seil.html.en) for older Macs.

* A semi-random collection of useful third-party commands, mostly npm packages.

* A small [Hammerspoon](http://www.hammerspoon.org/) configuration aimed mostly
  at letting me manage windows and swap apps with minimal mouse and keyboard
  usage.

* A basic configuration for using
  [mbsync](http://isync.sourceforge.net/mbsync.html) and
  [notmuch](https://notmuchmail.org/) to retrieve and filter email. It's
  tightly coupled with my [emacs
  configuration](https://github.com/NateEag/.emacs.d), which I use for reading
  and writing emails.


## Usage

`install.sh` symlinks each file or top-level folder in src/ to ~/$filename. It
also registers `lib/.crontab` as the executing user's crontab.

`uninstall.sh` undoes `install.sh`'s hard work. It might give odd results if
you have not previously run `install.sh`.


## Layout

`src/` contains the actual dotfiles.

`.config/` contains folders to be symlinked into `~/.config`.

`bin/` contains my personal collection of command-line programs. They're mostly
wrappers around existing tools so I don't have to remember arcane interfaces.

`lib/` contains dependencies that do not need to be installed elsewhere.
