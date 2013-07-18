#!/bin/bash

#
# Info:
#	A simple wrapper for recon reports which collects and stores
#   the swift-recon runs and emails a weekly report on sundays
#



### Variables ###
info_base="/var/www/nginx-default/swift_info"
recon_reports="/var/www/nginx-default/swift_info/recon_reports"
past_reports="/var/www/nginx-default/swift_info/recon_reports/previous_reports"
cur_wday=$(date +"%A" | tr [A-Z] [a-z])
cur_date=$(date +"%Y-%m-%d")
filename="recon_report_${cur_wday}_${cur_date}.txt"
retention=45
weekold=7


### Email Section ###
email_subj="[BOARDREADER] - Swift Recon Weekly Report"
email_from="swift_reporter@swift.zeroaccess.org"
email_to="swiftops"

if [[ -e /usr/bin/bsd-mailx ]]; then 
    mail_client="/usr/bin/bsd-mailx"
    mail_opts=( -a "From: ${email_from}" )
elif [[ -e /usr/bin/heirloom-mailx ]]; then 
    mail_client="/usr/bin/heirloom-mailx"
    mail_opts=( -r "${email_from}" )
else
    mail_client="None"
fi


### Options Passed to Recon ###
# If provided it will be passed over to recon
recon_bin="/usr/bin/swift-recon"
recon_options=($1)


### Checks ###
if [[ ! -d "${recon_reports}" ]]; then
    mkdir ${recon_reports}
    mkdir ${past_reports}
    chown -R www-data.www-data ${recon_reports}
fi

if [[ ! -d ${past_reports} ]]; then 
    mkdir ${past_reports}
    chown -R www-data.www-data ${past_reports}
fi

if [[ -z ${recon_options} ]]; then 
    recon_options=("--all")
fi


### Retention ###
/usr/bin/find ${past_reports} -type f -mtime +${retention} -exec rm -f {} \;
/usr/bin/find ${recon_reports} -type f -mtime +${weekold} -exec mv -f {} ${past_reports}/ \;


### Main Work ###
if [[ "${recon_options[@]}" == "--all" ]]; then 
    if [[ "${cur_wday}" == "sunday" ]]; then 
        if [[ "${mail_client}" != "None" ]]; then
            ${recon_bin} ${recon_options[@]} | tee ${recon_reports}/${filename} | ${mail_client} \
            "${mail_opts[@]}" -s "${email_subj}" ${email_to}
        else
            ${recon_bin} ${recon_options[@]} | tee ${recon_reports}/${filename} &> /dev/null
        fi
    else
        ${recon_bin} ${recon_options[@]} | tee ${recon_reports}/${filename} &> /dev/null
    fi
    chown www-data.www-data ${recon_reports}/${filename} 
else
    ${recon_bin} ${recon_options[@]} | ${mail_client} "${mail_opts[@]}" -s "${email_subj}" ${email_to}
fi

exit 0
