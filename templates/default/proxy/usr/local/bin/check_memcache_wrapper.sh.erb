#!/bin/bash

# Info: 
#   This small script calls check_memcache.py to see if
#   memcache is responding properly. If it's not it will 
#   go ahead and restart memcache.
#

LOCKFILE=/var/lock/.memcachecheck.lock
if [ -e $LOCKFILE ]; then
        exit 1
else
        touch $LOCKFILE
fi

TMPF=`mktemp`
/usr/local/bin/check_memcache.py -H 127.0.0.1 -f > $TMPF
grep restart $TMPF -q
if [ $? -eq 0 ]; then
    cat $TMPF
    echo "Restart attempted, sleeping for one cycle"
fi

rm -f $TMPF
rm -f $LOCKFILE
exit 0
