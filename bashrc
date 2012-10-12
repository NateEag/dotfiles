# Aliases. I'm not quite sure how much I should use these things.
alias mysqlstart='sudo /opt/local/bin/mysqld_safe5'
alias mysqlstop='/opt/local/bin/mysqladmin5 -u root -p shutdown'

# Sometimes, you want to see the headers you get from a site. Enter this
# handy curl alias, which prints the headers received from whatever URL
# you call it on.
alias getheaders='curl -s -D - -o /dev/null'

# TODO Move any generally useful shell functions into their own git repo and
# source them from here, if they exist.

# Print an absolute path to the directory containing the script that calls it.
# DEBUG This is not usefully reusable. For it to be defined in one place
# usefully, I'd need a way to actually return a value from the function...
abs_script_dirname () {
    echo "$( cd "$( dirname "${BASH_ARGV[0]}" )" && pwd )"
}

# Command-line multi-file find-and-replace. I hate using perl, but...
re-replace () {
    if [ -z "$3" ]; then
        echo 'Usage: replace pattern-to-match replacement directory'
    else
        perl -e "s/$1/$2/g;" -pi $(find $3 -type f)
    fi
}

# Convert files from Unix line endings to DOS.
unix2dos () {
    if [ -z "$2]" ]; then
        echo "Usage: unix2dos infile outfile"
    else
        perl -i -p -e 's/\n/\r\n/' "'$1'" > "'$2'"
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
# Since I'm writing it, I run the dev version of cmdline.py.
PYTHONPATH=$PYTHONPATH:~/cmdline
export PYTHONPATH

PATH=/opt/local/lib/postgresql91/bin:$PATH
PATH=/usr/local/bin:/opt/local/bin:/usr/local/git/bin:~/bin:~/bin/cron:$PATH
PATH=/usr/local/pear/bin:$PATH
PATH=/usr/local/bin:/opt/local/bin:$PATH
PATH=/usr/local/bin/docutils-0.8.1/tools:$PATH
export PATH

MANPATH=$MANPATH:/opt/local/share/man
export MANPATH

INFOPATH=$INFOPATH:/opt/local/share/info
export INFOPATH

# I use Emacs. To minimize the pain of my several-second boot (which, yes, is
# an absurd amount of time for a text editor to start), I use it in server
# mode when feasible.
EDITOR=emacsclient
export EDITOR

SVN_EDITOR=emacsclient
export SVN_EDITOR

VISUAL=emacsclient
export VISUAL

ALTERNATE_EDITOR=emacs   # emacsclient runs this if it can't find a server.
export ALTERNATE_EDITOR
