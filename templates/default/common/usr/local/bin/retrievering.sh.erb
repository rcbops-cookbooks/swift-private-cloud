#!/bin/sh

# Author: SwiftOPs
# Date : 2012-10-23
#
# Info: Script to pull swift ring down to a system 
#

host=$1

acctmd5=$(w3m -dump http://$host/ring/ring.md5sum | grep account | awk '{print $1}')
contmd5=$(w3m -dump http://$host/ring/ring.md5sum | grep container | awk '{print $1}')
objmd5=$(w3m -dump http://$host/ring/ring.md5sum | grep object | awk '{print $1}')

wget -q -O /tmp/account.ring.gz http://$host/ring/account.ring.gz
wget -q -O /tmp/container.ring.gz http://$host/ring/container.ring.gz
wget -q -O /tmp/object.ring.gz http://$host/ring/object.ring.gz


md5sum /tmp/account.ring.gz | awk '{print $1}' | grep $acctmd5 -q
if [ $? -ne 0 ]; then
    echo "Error: account.ring.gz md5sum doesn't match after download"
    exit 1
fi

md5sum /tmp/container.ring.gz | awk '{print $1}' | grep $contmd5 -q
if [ $? -ne 0 ]; then
    echo "Error: container.ring.gz md5sum doesn't match after download"
    exit 1
fi

md5sum /tmp/object.ring.gz | awk '{print $1}' | grep $objmd5 -q
if [ $? -ne 0 ]; then
    echo "Error: object.ring.gz md5sum doesn't match after download"
    exit 1
fi

sudo mv -v /tmp/*.ring.gz /etc/swift/

md5sum /etc/swift/account.ring.gz | awk '{print $1}' | grep $acctmd5 -q
if [ $? -ne 0 ]; then
    echo "Error: account.ring.gz md5sum doesn't match"
    exit 1
fi

md5sum /etc/swift/container.ring.gz | awk '{print $1}' | grep $contmd5 -q
if [ $? -ne 0 ]; then
    echo "Error: container.ring.gz md5sum doesn't match"
    exit 1
fi

md5sum /etc/swift/object.ring.gz | awk '{print $1}' | grep $objmd5 -q
if [ $? -ne 0 ]; then
    echo "Error: object.ring.gz md5sum doesn't match"
    exit 1
fi

sudo chown -R swift.swift /etc/swift

exit 0

