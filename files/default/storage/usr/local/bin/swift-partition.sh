#!/bin/bash

DEVICE=$1
if [ ! -b /dev/${DEVICE} ]; then
    echo "Error: /dev/${DEVICE}: not a block device"
    exit 1
fi

parted -s /dev/${DEVICE} mklabel msdos
parted -s /dev/${DEVICE} mkpart primary xfs 1M 100%
