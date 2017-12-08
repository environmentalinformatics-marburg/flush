#!/bin/bash
# This script checks the error.logs
# SOURCEPATH directory to the BACKUPPATH directory.


# Get date for log file
date

# Check if backup errors
if less log_rsync_sd19006_backup_south_africa.log | grep error ; then 
	java -jar /home/dogbert/administration/backup/sender.jar spaska.forteva@geo.uni-marburg.de forteva@staff.uni-marburg.de smtp.staff.uni-marburg.de Backup "Backup sd19006_backup_south_africa: Error messages" 
	fi
else
   java -jar /home/dogbert/administration/backup/sender.jar spaska.forteva@geo.uni-marburg.de forteva@staff.uni-marburg.de smtp.staff.uni-marburg.de Backup "Cannot ping host 180" 
fi

echo 'END ' date
