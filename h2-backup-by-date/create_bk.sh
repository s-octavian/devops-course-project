#!/bin/bash

toBackup=$1
backuptime=$(date +"%Y-%m-%d_%H-%M-%S")

backup_by_date() {
 if [[ -e "$1" ]]; then
 name=$(basename "$1")
 #cp -ar "$1" "backup_$name_$backuptime" #only copy
 tar -czvf "backup_$name_$backuptime.tgz" "$1" #archive
 else
 echo "No $name found!"
 fi
}

backup_by_date $1

##tar -xzvf [arhiva].tgz [-C folder/ = extracting in directory]
