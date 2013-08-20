#!/bin/bash


# Info: 
#       Installs and setup the swift-ring-master from source. This script
#       will setup the Ring Master server that normally runs on the admin box only.
#       
#       NOTE: services are not started up at boot time unless you enable it
#


git_repo="https://github.com/pandemicsyn/swift-ring-master.git"

id=$(whoami)
if [[ "$id" != "root" ]]; then 
    printf "\n Error: Must run as root or sudo privilege \n"
    exit 1
fi

printf "\n ---- Swift Ring Master Install ---- \n"
cd /usr/local/src/
printf "\n - Cloning git repo : %s \n" "$git_repo"
git clone $git_repo

cd swift-ring-master
printf "\n - Installing Ring Master \n"
python setup.py -q install
cp /usr/local/src/swift-ring-master/etc/swift/ring-master.conf-sample /etc/swift/ring-master.conf
cp /usr/local/src/swift-ring-master/etc/init.d/swift-ring-master-init /etc/init.d/
cp /usr/local/src/swift-ring-master/etc/init.d/swift-ring-master-wsgi-init /etc/init.d/
chown -R swift.swift /etc/swift

if [[ ! -e /var/log/ring-master ]]; then 
    mkdir /var/log/ring-master
fi
chown swift.swift /var/log/ring-master

printf "\n - Starting up Ring Master services \n"
/etc/init.d/swift-ring-master-init start && /etc/init.d/swift-ring-master-wsgi-init start

exit 0 

