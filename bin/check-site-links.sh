#! /bin/bash

# Simple wrapper around linkchecker to check my personal websites for dead links.
#
# Meant to be run regularly via cron.

SITES=("http://www.nateeag.com" "http://howicode.nateeag.com")

for SITE in ${SITES[*]}; do
    linkchecker --check-extern "$SITE" 2> /dev/null
    if [ "$?" != "0" ]; then
        # FIXME Without the echo statement, the growlnotify command does not
        # work consistently. Some sort of race condition?
        echo "This shouldn't make a difference..."
        growlnotify -s -m "$SITE has broken links."
    fi
done
