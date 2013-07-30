#!/bin/bash

# don't hang udev if something whacky is going on -- just background the
# thing so that crazy mount hangs or something don't hang the system
#

SCRIPT_DIR=$(dirname $0)
DEVICE=$1

${SCRIPT_DIR}/swift-mount.sh "${DEVICE}" &
