#!/bin/bash

#Моніторинг використання диска
#Напишіть сценарій і налаштуйте crontab для запуску цього сценарію, який перевірятиме використання 
#вашого обсягу /, і якщо воно перевищує X відсотків (налаштовується в crontab), він записуватиме 
#попереджувальне повідомлення у файл журналу /var/log/disk.log .


#записати переміну при запуску скрипта

limit=$1
mount_disk="/"


#перевірити обєм диску

#usage=$( /bin/df -h "$mount_point" | /bin/grep -E '^[^Filesystem]' | /usr/bin/awk '{print $5}' | /bin/sed 's/%//g' )

usage=$(df -h "$mount_disk" | grep -E '^[^Filesystem]' | awk '{print $5}' | sed 's/%//g' )
#test usage
echo 	"usage is $usage"

if [ "$usage" -ge "$limit" ]; then
echo "Waring: disk usage on disk $mount_disk is at ${usage}% as of $(date)" >> /var/log/disk.log
fi 

