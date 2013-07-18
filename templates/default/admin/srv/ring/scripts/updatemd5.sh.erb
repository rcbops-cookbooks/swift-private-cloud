#!/bin/bash

ring_path="/srv/ring"
ring_md5="/srv/ring/ring.md5sum"
ring_md5_temp="/tmp/.ring.md5.new"

cd /srv/ring
printf '%s' "Generating new ring md5 hashes"
/usr/bin/md5sum *.ring.gz > $ring_md5_temp
if [[ ! -e $ring_md5 ]]; then 
    touch $ring_md5
fi
/usr/bin/diff $ring_md5 $ring_md5_temp

echo -n "Ok to submit ? [y/n]: "
read confirm
if [ "$confirm" != "y" ]; then
    echo "Exiting"
    exit 1
else
    /bin/mv $ring_md5_temp $ring_md5
    printf '%s \n\n' "Copying new rings to /etc/swift/"
    sudo /bin/cp $ring_path/*.ring.gz /etc/swift/ && sudo chown -R swift.swift /etc/swift
fi
