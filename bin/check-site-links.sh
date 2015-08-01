#! /bin/bash

# Simple wrapper around linkchecker to check my personal websites for dead links.
#
# Meant to be run on successful network connection, so that after hopping on a
# network for the first time in a day, I just get notified if the sites have
# issues.

DATESTAMP_PATH=~/.check-site-links-last-run

# Format dates like numbers, so we can compare them as integers.
NOW=$(date +'%Y%m%d')

LAST_RUN=$(cat "$DATESTAMP_PATH")
# If the datestamp can't be read, assume we've never run.
LAST_RUN=${LAST_RUN:-0}

if [ $NOW -le $LAST_RUN ]; then
    echo "Already checked today."
    exit
fi


SITES=("http://www.nateeag.com" "http://howicode.nateeag.com")

for SITE in ${SITES[*]}; do
    linkchecker --check-extern "$SITE" 2> /dev/null
    if [ "$?" != "0" ]; then
        # FIXME Without the echo statement, the growlnotify command does not
        # work consistently. Some sort of race condition?
        echo "This shouldn't make a difference..."
        growlnotify -s -m "$SITE has broken links."
    fi

    echo "$NOW" > "$DATESTAMP_PATH"
done
