#!/bin/bash

#
# given a device that has a label like "swift:foo", mount the device
# at /srv/node/foo
#

export PATH=/bin:/usr/bin:/sbin:/usr/sbin
DEVICE=$1

if [ ! -b /dev/${DEVICE} ]; then
    echo "swift-mount: '${DEVICE}' not a device"
    exit 0
fi

whole_label=$(xfs_admin -l /dev/${DEVICE} | cut -d\" -f2)
labels=(${whole_label//:/ })

if [ ${#labels[@]} -ne 2 ] || [ "${labels[0]}" != "swift" ]; then
    echo "Not a swift device"
    exit 0
fi

LABEL=${labels[1]}

if grep -q /dev/${DEVICE} /etc/mtab; then
    echo "Device is mounted"
    exit 0
fi

if [ ! -e /srv/node/${LABEL} ]; then
    mkdir -p /srv/node/${LABEL}
    chown -R swift: /srv/node/${LABEL}
fi

mount /dev/${DEVICE} /srv/node/${LABEL} -o noatime,nodiratime,nobarrier,logbufs=8
chown swift: /srv/node/${LABEL}
