#!/bin/bash


# Info: 
#       Installs swift-ring-master from source. This script is for setting up
#       the ring-minion in order to pull the ring down from the ring master server.
#       The Ring minion should be setup on any node that needs the swift ring with
#       exception of the admin server that should be the ring master.
#

git_repo="https://github.com/pandemicsyn/swift-ring-master.git"

id=$(whoami)
if [[ "$id" != "root" ]]; then 
    printf "\n Error: Must run as root or sudo privilege \n"
    exit 1
fi

usage_display (){
cat << USAGE

Syntax:
    sudo ringminion_setup.sh -i ip_addr_of_ringmaster_server
        -i  IP address of the ring master server 
        -h For this usage screen

USAGE
exit 1
}

# Parsing arguments
while getopts "i:h" opts
do
    case $opts in         
        i)
            ip_addr="${OPTARG}"
        ;;
        *)
            usage_display
        ;;
    esac           
done

if [[ -z $ip_addr ]]; then
    printf "\n\t Error: No ip address provided ! \n"
    usage_display
fi

printf "\n ---- Swift Ring Master Install ---- \n"
cd /usr/local/src/
printf "\n - Cloning git repo : %s \n" "$git_repo"
git clone $git_repo

cd swift-ring-master
printf "\n - Installing Ring Master \n"
python setup.py -q install

printf "\n - Setting up Ring Minion files \n"

cp /usr/local/src/swift-ring-master/etc/swift/ring-minion.conf-sample /etc/swift/ring-minion.conf
sed -i "s;^#ring_master =.*;ring_master = http://$ip_addr:8090/;" /etc/swift/ring-minion.conf 
chown -R swift.swift /etc/swift

if [[ ! -e /var/log/ring-master ]]; then 
    mkdir /var/log/ring-master
fi
chown swift.swift /var/log/ring-master

printf "\n - Pulling swift rings from Ring Master server \n"
swift-ring-minion-server -f -o 
chown -R swift.swift /etc/swift

exit 0

