#!/bin/bash
#
# Info:
#       Installs and setup the drivescout utilities from github
#

git_repo="https://github.com/pandemicsyn/swiftscout"

if [ $EUID -ne 0 ]; then
    echo "Error: Must run as root or sudo privilege"
    exit 1
fi

cd /usr/local/src/
printf " - Cloning git repo : ${git_repo}"
git clone ${git_repo}

cd swiftscout
echo " - Installing"
python setup.py install
