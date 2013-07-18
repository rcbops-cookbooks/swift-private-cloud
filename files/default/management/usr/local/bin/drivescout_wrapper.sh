#!/bin/bash

# Author: Marcelo Martins
# Date: 2013-04-02
# Version: 1.00
#
# Info:
#   Quick script for setting up the drives for swift storage nodes
#
# Attention:
#   On a real system, I usually have a udev file created for the drives
#   in order to maintain a sane device block order otherwise somtimes the kernel
#   may choose another label for a drive that has been hot swapped. 
#   The udev rules are created mapping each device block ID to a SYMLINK of
#   format cXuYp, where X is the controller number and Y the unit number.
#
#   On a VM system, it's a whole other story and therefore a drive_list
#   would be used to figure those out.
#



# Arguments
num_of_args=$#
args_sarray=("$@")


usage_display (){
cat << USAGE

Syntax:
    sudo drivescout_wrapper.sh [ip address/ip range] [zone]  [region]
      - IP range as "1.1.1.1-254"
      - Zone where servers should be located
      - Region, if not specified it will default to 1

      For more detailed help see "drivescout -h" 
USAGE
exit 1
}


# Variables
ip_addr=$1
zone=$2
region=${3:-1}
mount_prefix="/srv/node"

if [[ $num_of_args -lt 2 ]]; then 
    printf "\nError: Must have all arguments defined\n"
    usage_display
fi


for x in object container account
do
    case $x in
        object)
            port=6000
        ;;
        container)
            port=6001
        ;;
        account)
            port=6002
        ;;
        *)
            printf "\nError: No port assigned\n"
            exit 1
        ;;
    esac

    echo "drivescout -v -y -w 100  --region=$region --mount-prefix=$mount_prefix -r $ip_addr -p $port -z $zone /etc/swift/$x.builder"
done

printf "\nPlease remember to rebalance all *.builder files"
exit 0

