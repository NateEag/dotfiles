#! /bin/bash

if [[ "$OSTYPE" == "msys" ]]; then
    # Support for Windows ssh-agent.
    # This seems like it should work fine on other OSes too, but I haven't
    # really used ssh-agent before, so I'm keeping this Windows-specific for
    # now.
    SSH_ENV="$HOME/.ssh/environment"

    # start the ssh-agent
    function start_agent {
        echo "Initializing new SSH agent..."
        # spawn ssh-agent
        ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
        echo succeeded
        chmod 600 "$SSH_ENV"
        . "$SSH_ENV" > /dev/null
        ssh-add
    }

    # test for identities
    function test_identities {
        # test whether standard identities have been added to the agent already
        ssh-add -l | grep "The agent has no identities" > /dev/null
        if [ $? -eq 0 ]; then
            ssh-add
            # $SSH_AUTH_SOCK broken so we start a new proper agent
            if [ $? -eq 2 ];then
                start_agent
            fi
        fi
    }

    # check for running ssh-agent with proper $SSH_AGENT_PID
    if [ -n "$SSH_AGENT_PID" ]; then
        ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
        if [ $? -eq 0 ]; then
            test_identities
        fi
        # if $SSH_AGENT_PID is not properly set, we might be able to load one from
        # $SSH_ENV
    else
        if [ -f "$SSH_ENV" ]; then
            . "$SSH_ENV" > /dev/null
        fi
        ps -ef | grep "$SSH_AGENT_PID" | grep -v grep | grep ssh-agent > /dev/null
        if [ $? -eq 0 ]; then
            test_identities
        else
            start_agent
        fi
    fi
fi

# Start gpg-agent if it's not running.
if test -f ~/.gpg-agent-info && \
    kill -0 $(cut -d: -f 2 ~/.gpg-agent-info) 2>/dev/null; then
    GPG_AGENT_INFO=$(cat ~/.gpg-agent-info | cut -c 16-)
else
    eval `gpg-agent --daemon --no-grab --write-env-file ~/.gpg-agent-info`
fi
export GPG_TTY
export GPG_AGENT_INFO

# Sometimes, you want to see the headers you get from a site. Enter this
# handy curl alias, which prints the headers received from whatever URL
# you call it on.
alias getheaders='curl -s -D - -o /dev/null'

# Source lib files for my dotfiles.
# GRIPE Hardcoding this is not as clean as letting my dotfiles dir live
# anywhere, but I'm not sure how to achieve that, since I install dotfiles by
# symlinking them.
dotfiles_path=~/dotfiles
dotfiles_lib_path=$dotfiles_path/lib/
for file in "$dotfiles_lib_path"/*.sh; do
    if [[ ! -d "$file" ]]; then
        source "$file"
    fi
done

# Print an absolute path to the directory containing the script that calls it.
# DEBUG This is not usefully reusable. For it to be defined in one place
# usefully, I'd need a way to actually return a value from the function...
abs_script_dirname () {
    echo "$( cd "$( dirname "${BASH_ARGV[0]}" )" && pwd )"
}

# Command-line multi-file find-and-replace.
# Just a thin wrapper around find, xargs, and sed, but sufficient for most
# purposes.
re-replace () {
    if [ -z "$3" ]; then
        echo 'Usage: replace <pattern-to-match> <replacement> <path> [<file-glob>] '
        echo
        echo 'The sed call uses ":" as a delimiter, so watch out for that.'
        return 1
    fi

    file_glob='.*'
    if [ -n "$4" ]; then
        file_glob=$4
    fi

    find "$3" -iname "$file_glob" -print0 | \
        xargs -0 sed -i '' "s:$1:$2:g"
}

# Strip excess whitespace from files in a path.
strip-whitespace () {
    if [ -z "$1" ]; then
        echo 'Usage: strip-whitespace <path> [<file-regex]'
        return 1
    fi

    # GRIPE I should probably generalize the list of text-ish files to an
    # array, then set an environment variable to control the defaults throughout
    # my dotfiles.
    file_regex='.*\.(html|css|js|py|php|c|h|htm|tmpl|xml|xsd|sh)'
    if [ -n "$2" ]; then
        file_regex=$2
    fi

    find $1 -regextype posix-extended -regex $file_regex -print0 | \
        xargs -0 sed -i 's/[ \t]*$//g'
}

# Convert files from DOS line endings to Unix.
dos2unix () {
    if [ -z "$2]" ]; then
        echo "Usage: dos2unix <file>"
    else
        perl -i -p -e 's/\r\n/\n/' $1
    fi
}

# Convert files from Unix line endings to DOS.
unix2dos () {
    if [ -z "$2]" ]; then
        echo "Usage: unix2dos <file>"
    else
        perl -i -p -e 's/\n/\r\n/' $1
    fi
}

# Recursively print the number of lines contained in $1, with optional
# name filter in $2.
# GRIPE A regex would be a better filter for $2 than shell globbing.
linecount () {
    name=''
    if [ -n "$2" ]; then
        name="-name $2"
    fi

    files=$(find $1 -type f $name)
    echo $files | xargs wc -l
}

# Return a string listing all .jars in $1, suitable for use in java -classpath.
# DEBUG Might not quite work; hasn't been entirely tested. I just didn't want
# to throw it out when it proved irrelevant.
classpath () {
    find $1 -type f -name *.jar | awk '{printf "%s:",$0} END {print ""}'
}

# Environment variables.

PATH=~/Applications/LilyPond.app/Contents/Resources/bin:$PATH
PATH=/usr/local/bin:/usr/local/git/bin:~/bin/cron:$PATH
PATH=~/bin:$PATH
PATH="$HOME/Library/Haskell/bin:$PATH"
PATH="$HOME/.gem/ruby/1.8/bin:$PATH"
PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"

# Add Emacs 24 commands to my path, so that emacsclient works right on OS X.
PATH=/Applications/Emacs.app/Contents/MacOS/bin-i386-10_5:$PATH
PATH=/Applications/Emacs.app/Contents/MacOS:$PATH

# Set EMACS var for cask.
EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
export EMACS

PATH=~/.cask/bin:$PATH

# I'm trying out installing npm locally. We'll see how it goes.
PATH=~/npm/bin:$PATH

# Add my custom shell commands to path, for when an alias or function just
# won't hack it.
PATH="$dotfiles_path/lib/node_modules/.bin:$PATH"
PATH="$dotfiles_path/bin:$PATH"

export PATH

# I use Emacs. To minimize the pain of my several-second boot, I use it in server
# mode when feasible. Sadly, Emacs isn't available everywhere, so I have a few
# backup options listed.
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
fi

## Shell extensions.

# Load pyenv into my shell.
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Load Pipsi into my shell.
export PATH="$HOME/.local/bin:$PATH"

# Load nvm into my shell.
export NVM_DIR=~/.nvm
source ~/.nvm/nvm.sh

# Load direnv, if available.
if [ $(command -v direnv) ]; then
    eval "$(direnv hook bash)"
fi