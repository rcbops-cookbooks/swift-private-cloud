#!/bin/bash 

# Author: Marcelo Martins
# Date : 2012-10-19
#
# Info: A simple script to deploy some ring changes
#


###################
# STATIC VARIABLES 
###################
ring_path="/srv/ring"
ring_scripts="/srv/ring/scripts"
ring_md5="/srv/ring/ring.md5sum"
ring_builder="/usr/bin/swift-ring-builder"
acctbuilder_file="/srv/ring/account.builder"
contbuilder_file="/srv/ring/container.builder"
objtbuilder_file="/srv/ring/object.builder"
logfile=$ring_path/ring_builder.log

if [[ ! -e $logfile ]]; then
   touch $logfile
fi


#########
# INIT
#########
num_of_args=$#
arg_sarray=("$@")
args=$@


usage_display (){
cat << USAGE
Syntax
    ring_add.sh -i IP/IP-RANGE -r RING -z ZONE_NUMBER -w WEIGHT -l "LIST_OF_DRIVES"
    -i  The IP of the box or a range such as x.x.x.X-Y
    -r  The ring to be updated (account, container, object)
    -z  Zone number 
    -w  The weight 
    -l  List of devices to be setup e.g: "xvdb xvdd xvdf xvdg" (USE double quotes)
    -h  For this usage screen

    NOTE: Device blocks must have UDEV format of cXuYp

USAGE
exit 1
}


# Process Command Line
while getopts "hi:r:z:w:l:" OPTION
do 
    case $OPTION in
        h)  
            usage_display
            ;;
        i)  
            ip_spec="${OPTARG}"
            ;;
        r)  
            ring_type="${OPTARG}"
            case "$ring_type" in 
                "account")
                    fbuilder=$acctbuilder_file
                    node_port="6002"
                    ;;
                "container")
                    fbuilder=$contbuilder_file
                    node_port="6001"
                    ;;
                "object")
                    fbuilder=$objtbuilder_file
                    node_port="6000"
                    ;;
                *)
                    printf '\t %s \n' "Error: Invalid ring type provided"
                    usage_display
                    ;;
            esac
            ;;
        z)  
            zone="${OPTARG}"
            ;;
        w)
            weight="${OPTARG}"
            ;;
        l)
            drive_list="${OPTARG}"
            ;;
        *)
            usage_display
            ;;
    esac
done


if [[ $num_of_args -eq 0 ]]; then
    echo -e "No arguments provided \n"
    usage_display
fi

if [[ -z $zone || -z $weight ]]; then 
    echo -e "Zone and Weight are required"
    usage_display
fi 


setup_range (){
    start_ip="${ip_spec%-*}"
    prefix="${ip_spec%.*}"
    last_byte_start="${start_ip##*.}"
    if [[ "$ip_spec" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        last_byte_end="$last_byte_start"
    else
        last_byte_end="${ip_spec#*-}"
    fi
}


add_to_swiftring (){
    setup_range
    echo -e "\n------------- "`date`" ----------------" >> $logfile
    echo -e "Adding $ring_type nodes " >> $logfile
    for (( last_byte = last_byte_start; last_byte <= last_byte_end; last_byte++ )); do 
        node_ip="$prefix.$last_byte"
        for dev in $drive_list; do 
            $ring_builder $fbuilder add z$zone-$node_ip:$node_port/$dev $weight >> $logfile
        done
    done
}


rebalance_ring (){
    rtype="$1"
    rfile="$2"
    printf "#"
    printf "\n# NOTE: Only rebalance when all $rtype ring changes are done"
    printf "\n# Rebalance $rtype ring ? [y/n]: "
    confirm="n"
    if [[ "$confirm" == "y" ]]; then
        $ring_builder $rfile rebalance
        update_md5 "$rtype"
    else
        printf "#"
        printf "\n# Remember to: "
        printf "\n#  - Rebalance the ring"
        printf "\n#     $ring_builder $rfile rebalance"
        printf "\n#  - Run $ring_scripts/updatemd5.sh"
    fi
}


update_md5 (){
    rtype="$1"

    printf "#"
    printf "\n# Updating md5 hash for $rtype ring"
    case "$rtype" in
        "account")
            rmd5=`/usr/bin/md5sum $ring_path/account.ring.gz | awk '{print $1}'`
            /bin/sed -i "1 c\\$rmd5  account.ring.gz" $ring_md5 
        ;;
        "container")
            rmd5=`/usr/bin/md5sum $ring_path/container.ring.gz | awk '{print $1}'`
            /bin/sed -i "2 c\\$rmd5  container.ring.gz" $ring_md5 
        ;;
        "object")
            rmd5=`/usr/bin/md5sum $ring_path/object.ring.gz | awk '{print $1}'`
            /bin/sed -i "3 c\\$rmd5  object.ring.gz" $ring_md5 
        ;;
    esac

    printf "\n# Verifying all md5 ring hashes:\n"
    /usr/bin/md5sum -c $ring_md5
    if [[ $? -eq 0 ]]; then
        printf "#"
        printf "\n# Copying new rings to /etc/swift"
        sudo /bin/cp $ring_path/$rtype.ring.gz /etc/swift/ 
        sudo /bin/chown -R swift.swift /etc/swift
    elif [[ $? -eq 1 ]]; then 
        printf "\n# Ring hash has failed verification, please check it manually"
        printf "\n# before deploying the new ring file to other systems"
        printf "\n#######################################################################\n\n"
        exit 1
    fi
}


########
# MAIN 
########

case $ring_type in 
    "account")
        printf "\n############################### Account ###############################"
        printf "\n# Node(s): $ip_spec, Zone: $zone, Weight: $weight"
        printf "\n#"
        printf "\n# Would you like to proceed adding the node(s) above "
        printf "\n# within the Zone and Weight shown into the $ring_type ring ? [y/n]: "
        confirm="y"
        if [[ "$confirm" == "y" ]]; then
            add_to_swiftring
            rebalance_ring "$ring_type" "$acctbuilder_file"
            printf "\n#"
            printf "\n# How to deploy over DSH: "
            printf "\n#  dsh -Mc -g GROUP 'w3m -dump http://admin_ip/ring/scripts/retrievering.sh | bash' "
            printf "\n############################### Account ###############################\n\n"
        else
            printf "#"
            printf "\n# Quitting ..."
            printf "\n############################### Account ###############################\n\n"
        fi
        ;;

    "container")
        printf "\n############################### Container ###############################"
        printf "\n# Node(s): $ip_spec, Zone: $zone, Weight: $weight"
        printf "\n#"
        printf "\n# Would you like to proceed adding the node(s) above "
        printf "\n# within the Zone and Weight shown into the $ring_type ring ? [y/n]: "
        confirm="y"
        if [[ "$confirm" == "y" ]]; then
            add_to_swiftring
            rebalance_ring "$ring_type" "$contbuilder_file"
            printf "\n#"
            printf "\n# How to deploy over DSH: "
            printf "\n#  dsh -Mc -g GROUP 'w3m -dump http://admin_ip/ring/scripts/retrievering.sh | bash' "
            printf "\n############################### Container ###############################\n\n"
        else
            printf "#"
            printf "\n# Quitting ..."
            printf "\n############################### Container ###############################\n\n"
        fi
        ;;

    "object")
        printf "\n############################### Object ###############################"
        printf "\n# Node(s): $ip_spec, Zone: $zone, Weight: $weight"
        printf "\n#"
        printf "\n# Would you like to proceed adding the node(s) above "
        printf "\n# within the Zone and Weight shown into the $ring_type ring ? [y/n]: "
        confirm="y"
        if [[ "$confirm" == "y" ]]; then
            add_to_swiftring
            rebalance_ring "$ring_type" "$objtbuilder_file"
            printf "\n#"
            printf "\n# How to deploy over DSH: "
            printf "\n#  dsh -Mc -g GROUP 'w3m -dump http://admin_ip/ring/scripts/retrievering.sh | bash' "
            printf "\n############################### Object ###############################\n\n"
        else
            printf "#"
            printf "\n# Quitting ..."
            printf "\n############################### Object ###############################\n\n"
        fi
        ;;
esac

exit 0 
