#!/bin/bash

# Info: 
#       This is a simple sript to verify the ring md5s match with what is 
#       in the Admin system. Please note that this should only be used
#       within a Swift FOLSOM environment. 
#
#       When using Swift GRIZZLY, one should be using swift-ring-master 
#       for ring management, deployment and verification
#

RINGSERVERIP="$1"

if [ -z "$RINGSERVERIP" ]; then
    echo "Need Ring Server IP as valid argument"
    exit 1
fi


LOCKFILE=/tmp/.ringcheck.lock
if [ -e $LOCKFILE ]; then
    exit 1
else
    touch $LOCKFILE
fi

cd /etc/swift
w3m -dump http://$RINGSERVERIP/ring/ring.md5sum | md5sum -c --quiet

rm -f $LOCKFILE
exit 0
