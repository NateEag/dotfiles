#! /bin/bash

# A few useful constants.
dotfiles_path="$HOME/dotfiles"
dotfiles_etc="$dotfiles_path/etc"
dotfiles_lib_path="$dotfiles_path/lib"


## Bash Completions
#
# Life without them is frustrating. These target bash 4 and up.

# Load bash completions for Nix-installed bash.
#
# (The nix bash completion setup takes care of only running on bash > 4.)
export XDG_DATA_DIRS="$HOME/.nix-profile/share/:$XDG_DATA_DIRS"
source "$HOME/.nix-profile/etc/profile.d/bash_completion.sh"

# Load my non-standard completions explicitly.
for file in "$dotfiles_path/bash-completions/"*; do
    if [ -f "$file" ]; then
        source "$file"
    fi
done

# Tell bash completion where to find my personal lazy-loaded completions
#
# Tabbing after a command name that does not yet have any completions defined
# causes a search in all configured directories for a file matching the command
# name (see the base bash completion script for exact patterns). If one is
# found, it will be sourced.
#
# That makes it very easy to lazy-load completions for tools that suggest you
# eval their output to define completions.
#
# In turn, that means I can have lots of nice autocompletions work seamlessly
# for various slow-starting tools without having a shell startup time measured
# in seconds.
#
# TODO Make sure there are docs on defining your own lazy-loaded completions. I
# wound up reading code to figure it out, and I'm hoping I just missed
# something, because that does not seem like it should be necessary.
#
# ...that said, I'm a little suspicious they're _not_ out there, because
# otherwise wouldn't some of the projects where the command generates its own
# autocompletions would tell you do something like I'm doing here, rather than
# saying "just eval this output".
export BASH_COMPLETION_USER_DIR="$HOME/dotfiles/bash-completions"

# We export GPG_TTY to work around a failure I don't really understand but
# resolved with the aid of this post:
# https://bbs.archlinux.org/viewtopic.php?pid=1648479#p1648479
GPG_TTY="$(tty)"
export GPG_TTY

# fc -ln -1 gets the last command from your history. Strip off whitespace and
# the trailing newline, and bam - last command is on your clipboard!
#
# I used (\t| ) to match tabs and spaces because \t didn't work in a character
# class and literal tabs are harder to read.
#
# TODO Sub in a portable command for pbcopy. I know Linux does it differently.
alias copy-last-cmd="fc -ln -1 | sed -E 's/^(\t| )*//' | tr -d '\n' | pbcopy"

# Sometimes, you want to see the headers you get from a site. Enter this
# handy curl alias, which prints the headers received from whatever URL
# you call it on.
alias getheaders='curl -s -D - -o /dev/null'

# Magit is my preferred Git client, but I do plenty of work in a terminal
# emulator. This alias fires up the magit-status prompt directly from my
# terminal emulator and makes sure Emacs.app is focused.
alias mg='emacsclient -a emacs -e "(magit-status)" && focus-emacs'

# Source lib files for my dotfiles.
for file in "$dotfiles_lib_path"/*.sh; do
    if [[ ! -d "$file" ]]; then
        source "$file"
    fi
done


# Return a string listing all .jars in $1, suitable for use in java -classpath.
# DEBUG Might not quite work; hasn't been entirely tested. I just didn't want
# to throw it out when it proved irrelevant.
classpath () {
    find $1 -type f -name *.jar | awk '{printf "%s:",$0} END {print ""}'
}

# Load nix configuration first. This way, tools installed locally by things
# like Homebrew should take precedence, which helps me stay on the
# employer-sanctioned versions of tools in specific projects.
if [ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]; then . "$HOME"/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Environment variables.

PATH=~/Applications/LilyPond.app/Contents/Resources/bin:$PATH
PATH="/Applications/VirtualBox.app/Contents/MacOS:$PATH"
PATH=/usr/local/bin:/usr/local/git/bin:~/bin/cron:$PATH
PATH=~/bin:$PATH
PATH=~/the_silver_searcher:$PATH
PATH=~/finances/bin:$PATH
PATH="$HOME/Library/Haskell/bin:$PATH"
PATH="$HOME/.gem/ruby/1.8/bin:$PATH"
PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
PATH="$HOME/icsv2ledger:$PATH"
PATH="$HOME/.composer/vendor/bin:$PATH"

# Load pipx-installed variables into my shell.
PATH="$HOME/.local/bin:$PATH"

# Set up for building Chrome.
PATH="$HOME/chromium-build/depot_tools:$PATH"

# Add Emacs commands to my path, so that emacsclient works right on OS X.
PATH=/Applications/Emacs.app/Contents/MacOS/bin:$PATH
PATH=/Applications/Emacs.app/Contents/MacOS:$PATH

# Set EMACS var for cask.
EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
export EMACS

PATH=~/.cask/bin:$PATH

# I'm trying out installing npm locally. We'll see how it goes.
PATH=~/npm/bin:$PATH

# I have a local collection of Node modules, mostly installed to get binaries
# on my PATH.
PATH="$dotfiles_path/lib/node_modules/.bin:$PATH"

# Add my custom shell commands to path, for when an alias or function just
# won't hack it.
PATH="$dotfiles_path/bin:$PATH"

# Get `ts` on my path (installing moreutils with Homebrew is not
# compatible with installing GNU Parallel, as there is a name collision).
PATH="$PATH:$HOME/third-party/moreutils"

export PATH

# I use Emacs. To minimize the pain of my many-second boot, I use it in server
# mode when feasible. Sadly, Emacs isn't available everywhere, so I have a few
# backup options listed.
#
# OPTIMIZE Get Emacs booting quickly and this would be much less necessary.
declare -a EDITORS=("emacsclient" "emacs" "vim" "vi")
for editor in "${EDITORS[@]}"; do
    editor_path=$(which $editor 2> /dev/null)
    if [ -n "$editor_path" ]; then
        EDITOR=$editor
        break
    fi
done
export EDITOR

ALTERNATE_EDITOR=emacs   # emacsclient runs this if it can't find a server.
export ALTERNATE_EDITOR

SVN_EDITOR=$EDITOR
export SVN_EDITOR

VISUAL=$EDITOR
export VISUAL

# In here for notmuch, really. On work machines I override this in my
# .bashrc.local file.
export EMAIL=nate@nateeag.com

export SLACK_CLI_TOKEN_CMD='pass show api.slack.com/token'

# Uncomment the following (and its sibling at file bottom) to profile .bashrc.
#
# When things start slowing down, NVM and bash completion are my big killers.
#
# PS4='+ $(gdate "+%s.%N")\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log
# set -x

# Append to the bash history file rather than overwriting it.
shopt -s histappend
# Save bash history after every command.
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
# Explicitly write history to ~/.bash_history - on OS X 10.14 each terminal
# seems to write to its own history file (I think to help with restoring state
# after quitting Terminal.app?).
HISTFILE=~/.bash_history

# Customizations that require [Homebrew](http://brew.sh) to be installed.
if command -v brew > /dev/null ; then
    # If available, use Homebrew's SSL cert file. This works around various
    # issues with SSL in the OS X command line:
    #
    # http://stackoverflow.com/questions/24675167/ca-certificates-mac-os-x
    INSTALLED_SSL_CERT_PATH=$(brew --prefix)/etc/openssl/cert.pem 2> /dev/null
    if [ -e "$INSTALLED_SSL_CERT_PATH" ]; then
        export SSL_CERT_FILE="$INSTALLED_SSL_CERT_PATH"
    fi

    # For some reason this is where Homebrew puts PHP. *shrugs*
    PATH="/usr/local/opt/bin/php:$PATH"
fi


## Shell extensions.

# Load direnv if available.
#
# Note that this takes virtually no time. Perhaps there's something to be said
# for writing shell extensions in compiled languages.
if command -v direnv > /dev/null; then
    eval "$(direnv hook bash)"
fi


# I use nvm for managing different versions of node.
#
# Loading it fully at shell start makes for a slow shell startup, despite
# https://github.com/nvm-sh/nvm/issues/1277 being closed.
#
# I also use some node commands day-to-day here in my dotfiles repository,
# which means it's awkward to just not load it at all, cause then those don't
# work.
#
# I saw the "slap latest node in $PATH" workaround here and thought "yeah, that
# should work if I pair it with --no-use".
#
# I guess we'll see if it works out okay for me.
export NVM_DIR="$HOME/.nvm"
node_versions_dir="$NVM_DIR/versions/node"
latest_node_path="$(find "$node_versions_dir" -type d -maxdepth 1 |
                         sort -V |
                         tail -n1)/bin/"
PATH="$latest_node_path:$PATH"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Load pyenv into my shell.
#
# Note that I use a manually-generated cache of pyenv's self-generated
# configuration, instead of the recommended approach of running pyenv to
# generate the required configuration on demand.
#
# That lets me avoid the slight delay in shell start brought on by running
# pyenv, at the cost of having to maintain a fragile method for detecting
# whether pyenv has been updated and thus that I should regenerate the
# initialization code.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
source "$dotfiles_etc/pyenv-init"

# Check whether pyenv may have been updated, and thus whether I should
# regenerate the cached configuration that's loaded above.
pyenv_binary="$(which pyenv)"
if ! [ -L "$pyenv_binary" ]; then
    echo "WARNING: pyenv binary is no longer a symlink! Update pyenv conf?" >&2
elif [ "$(readlink "$pyenv_binary" | cut -d / -f 4)" != '2.2.3' ]; then
    echo "WARNING: Could not confirm pyenv version is 2.2.3! Update pyenv conf?" >&2
fi

# Load any machine-specific customizations (usually settings specific to
# $DAYJOB).
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

# Uncomment the following (along with the preamble at top) to profile .bashrc.
#
# set +x
# exec 2>&3 3>&-

# Perl settings to support edbi (Emacs DataBase Interface)
PATH="/Users/neagleson/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/neagleson/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/neagleson/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/neagleson/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/neagleson/perl5"; export PERL_MM_OPT;
