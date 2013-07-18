#!/bin/bash

# Author: Marcelo Martins
# Date: 2013-04-01
# Version: 0.10
# 
# Info:
#       This is a simple script to help on generating udev rules
#       for the devices. It's very stupid at the moment so please
#       pay good attention when creating it and double check
#       the generated file for any possible mistakes
#
#
# Helpful commands:
#   lspci -vmm -nn 
#   lspci  -vmm -d "1000:005b" 
#        Slot:   02:00.0
#        Class:  RAID bus controller
#        Vendor: LSI Logic / Symbios Logic
#        Device: MegaRAID SAS 2208 [Thunderbolt]
#        SVendor:        Dell
#        SDevice:        PERC H710P Mini (for monolithics)
#        Rev:    05
#
#   udevadm info -a -p $(udevadm info -q path -n sdc) | grep "ATTRS{model}"
#   udevadm info -a -p $(udevadm info -q path -n sdc) | grep -m 1 "KERNELS"
#   http://pci-ids.ucw.cz/

# ARGUMENTS
num_of_args=$#
args_sarray=("$@")

usage_display (){
cat << USAGE

Syntax:
       sudo ./udev_drive_rules.sh -c CONTROLLER_NUMBER -d FIRST_DEVICE -n NUMBER_OF_VIRTUAL_DISKS [-o OUTFILE]
        -c  The controller number 
        -d  This should be the first device attached to a controller 
        -n  The number of virtual disks that this controller manages 
        -o  Generated udev rules file output (defaul: /tmp/10_swift.rules.EPOCH-TIMESTAMP)
        -h  For this usage screen

    NOTE: The number of disks starts from Zero, so a controller that manages 60 disk
          would have -n 59 

USAGE
exit 1
}


# Parsing arguments
while getopts "c:d:n:h" opts
do
    case $opts in
        c)
            controller_num="${OPTARG}"
            if [[ $controller_num -gt 5 ]]; then
                printf "\n\t Error: controller nummber too high (max=5)\n"
                usage_display
            fi
        ;;
        d)
            first_device="${OPTARG}"
        ;;
        n)
            number_of_disks="${OPTARG}"
        ;;
        o)
            output_file="${OPTARG}".$(date +"%s")
        ;;
        *)
            usage_display
        ;;
    esac
done

if [[ -z "$controller_num" ]] || [[ -z "$first_device" ]] || [[ -z "$number_of_disks" ]]; then
    printf "\n\t Error: All following options must be declared -c/-d/-n\n"
    usage_display
fi

if [[ -z "$output_file" ]]; then 
    ts=$(date +"%s")
    output_file="10_swift.rules."$ts
fi

controller_model=$(udevadm info -a -p $(udevadm info -q path -n $first_device) | grep "ATTRS{model}" | tr -d " ")
udev_kernels_info=$(udevadm info -a -p $(udevadm info -q path -n $first_device) | grep -m 1 "KERNELS" | tr -d " ")

tmp=$(echo $udev_kernels_info | sed 's/KERNELS=="//' - | sed 's/"//' -)
host_num=$(echo $tmp | cut -d ":" -f 1)
bus_num=$(echo $tmp | cut -d ":" -f 2)
target_num=$(echo $tmp | cut -d ":" -f 3)
lun_num=$(echo $tmp | cut -d ":" -f 4)

for ((i=0;i<number_of_disks;i++)); do
    printf "KERNELS==\"%s:%s:%s:%s\", %s, KERNEL==\"sd*\", SYMLINK+=\"c%su%sp%%n\"\n" "$host_num" "$bus_num" "$i" "$lun_num" "$controller_model" "$controller_num" "$i" >> /tmp/$output_file
done

printf "\nGenerated file with udev rules: /tmp/%s\n\n" "$output_file"

exit 0
