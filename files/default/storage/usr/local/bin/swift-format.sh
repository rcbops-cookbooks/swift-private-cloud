#!/bin/bash

DEVICE=$1
LABEL=$2

if [ "${DEVICE}" = "" ]; then
    echo "swift-format: <device> [label]"
    exit 1
fi

if [ ! -b /dev/${DEVICE} ]; then
    echo "Error: /dev/${DEVICE}: not a block device"
    exit 1
fi

if [ "${LABEL}" = "" ]; then
    LABEL="${DEVICE}"
fi

LABEL=${LABEL// /_}

mkfs.xfs -f -i size=512 -d su=64k,sw=1 /dev/${DEVICE}
# xfs_admin -L "swift:${LABEL}" /dev/${DEVICE}

# kick an event so that we mount
# udevadm trigger --action=add --type=devices --subsystem-match=block --sysname-match=${DEVICE}
