#!/bin/bash

#
# Info:
#	A simple wrapper for swift dispersion report tool
#



### Variables ###
info_base="/var/www/nginx-default/swift_info"
dispersion_reports="/var/www/nginx-default/swift_info/dispersion_reports"
dispersion_bin="/usr/bin/swift-dispersion-report"
past_reports="/var/www/nginx-default/swift_info/dispersion_reports/previous_reports"
cur_wday=$(date +"%A" | tr [A-Z] [a-z])
cur_date=$(date +"%Y-%m-%d")
filename="dispersion_report_${cur_wday}_${cur_date}.txt"
retention=15
weekold=7


### Checks ###
if [[ ! -d "${dispersion_reports}" ]]; then
    mkdir ${dispersion_reports}
    mkdir ${past_reports}
    chown -R www-data.www-data ${dispersion_reports}
fi

if [[ ! -d ${past_reports} ]]; then 
    mkdir ${past_reports}
    chown -R www-data.www-data ${past_reports}
fi


### Retention ###
/usr/bin/find ${past_reports} -type f -mtime +${retention} -exec rm -f {} \;
/usr/bin/find ${dispersion_reports} -type f -mtime +${weekold} -exec mv -f {} ${past_reports}/ \;


### Main Work ###
${dispersion_bin} | tee ${dispersion_reports}/${filename} &> /dev/null
chown www-data.www-data ${dispersion_reports}/${filename} 

exit 0
