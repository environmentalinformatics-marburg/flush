#!/bin/bash
# This script checks the error.logs
# SOURCEPATH directory to the BACKUPPATH directory.


# Get date for log file
date

# Check if backup errors
if less error_tsm_sync.log | grep 'error' ; then 
	java -jar /home/dogbert/administration/backup/sender.jar spaska.forteva@geo.uni-marburg.de forteva@staff.uni-marburg.de smtp.staff.uni-marburg.de Backup "tsm_backup: Error messages" 
	fi

if less backup_incoming_gsm.log | grep 'error' ; then 
	java -jar /home/eibestations/administration/sender.jar spaska.forteva@geo.uni-marburg.de forteva@staff.uni-marburg.de smtp.staff.uni-marburg.de Backup "gsm_backup: Error messages" 
	fi
echo 'END ' date
