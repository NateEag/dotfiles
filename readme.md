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


## OS X Automation Notes

I used to love Mac OS X but no longer trust Apple to develop it well. It is
slowly growing more and more closed-off and iOS-like.

Nonetheless, as a developer it's a pragmatic choice for a desktop, as it's the
only supported platform for writing and testing code that works on all desktop
/ mobile OSes (be it web code or native).

Thus, I live in it, until the day I can't stand it any more.

Accessibility Inspector.app is an essential tool for automating graphical
programs. Paired with AppleScript's command-line interpreter `osascript` (and
the necessary permissions for Terminal.app, which is not without risk but sure
is handy), you can write command-line programs to automate almost any graphical
program you run.

`bin/mute-slack` is an example. It mutes the current Slack call (as long as
it's Slack's frontmost window). My Hammerspoon config gives that command a
global keybinding, thus giving me a global keyboard shortcut for muting Slack.

The same general principle applies on any OS, platform, or program. If it has a
useful accessibility API, you can use it to automate graphical components
(which, I should note, means you have a usable mechanism for writing functional
tests).

It's tempting to call that "abusing the accessibility API", but it really
isn't. The whole purpose of such an API is to do exactly these sorts of things,
to make it easier for people to use programs that do not fit their needs.

Assistive devices are useful even for those without handicaps.
