#! /bin/bash

# Simple wrapper around linkchecker to check my personal websites for dead links.
#
# Meant to be run on successful network connection, so that after hopping on a
# network for the first time in a day, I just get notified if the sites have
# issues.
#
# On OS X, crankd (part of https://github.com/nigelkersten/pymacadmin) is a decent
# tool for running scripts on network status changes. I set it up as described
# in this blog post:
# http://nokyotsu.com/qscripts/2011/03/run-script-in-os-x-on-network.html

# Constants.
SITES=("http://www.nateeag.com" "http://howicode.nateeag.com")
DATESTAMP_PATH=~/.check-site-links-last-run

# Format the current date as a number, so we can compare it to the last run date
# with -ne.
NOW=$(date +'%Y%m%d')

# If the datestamp is missing, assume we've never run.
LAST_RUN=$(cat "$DATESTAMP_PATH")
LAST_RUN=${LAST_RUN:-0}

if [ $NOW -le $LAST_RUN ]; then
    echo "Already checked today."
    exit
fi

# Load my personal PATH and similar settings, since launchd doesn't include them.
. /Users/nate/.bashrc

/sbin/ping -c 1 ${SITES[0]:7}
if [ $? -ne 0 ]; then
    echo "Cannot reach site; assuming no net connection."
    exit
fi

SITES_OKAY=0
for SITE in ${SITES[*]}; do
    linkchecker --check-extern "$SITE" 2> /dev/null

    if [ $? -ne 0 ]; then
        # FIXME Without this echo, growlnotify fails silently. Race condition?
        echo "Checked $SITE"
        growlnotify -s -m "$SITE has broken links."

        SITES_OKAY=1
    fi
done

echo "$NOW" > "$DATESTAMP_PATH"

if [ $SITES_OKAY -eq 0 ]; then
    # Explicitly telling us the site looks okay mitigates the risk of silent
    # failure - if we don't get the all clear, we know we need to research.
    growlnotify -s -m "All sites' links look good."
fi
