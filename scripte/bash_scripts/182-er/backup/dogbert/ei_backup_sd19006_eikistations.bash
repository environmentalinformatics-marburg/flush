#!/bin/bash
# This script creates a 15 day long rotating backup of the
# SOURCEPATH directory to the BACKUPPATH directory.
# Crontab entry: 0 0 * * * bash /home/dogbert/administration/backup/ei_backup_sd19006_eikistations.bash >> /home/dogbert/administration/backup/log_error_sd19006_eikistations.log 2>&1 &

SOURCEPATH='/home/eikistations/ei_data_kilimanjaro/' 
BACKUPPATH='/mnt/sd19003/sd19006_backup_kilimanjaro/'
BACKUPNAME='sd19006_backup_kilimanjaro'
LOGPATH='/home/dogbert/administration/backup/'


# Get date for log file
date

if ping -qc 20 192.168.191.180 >/dev/null; then
	if mount | grep /mnt/sd19003 > /dev/null; then
		# Check to make sure the folders exist, if not creates them.
		/bin/mkdir -p ${BACKUPPATH}backup_${BACKUPNAME}.{0..7}

		# Delete the oldest backup folder.
		/bin/rm -rf ${BACKUPPATH}backup_${BACKUPNAME}.7

		# Shift all the backup folders up a day.
		for i in {7..1}
		do
		/bin/mv ${BACKUPPATH}backup_${BACKUPNAME}.$[${i}-1] ${BACKUPPATH}backup_${BACKUPNAME}.${i}
		done

		# Create the new backup hard linking with the previous backup.
		# This allows for the least amount of data possible to be
		# transfered while maintaining a complete backup.
		/usr/bin/rsync -a -e --copy-links --copy-unsafe-links --delete --exclude=".*" --link-dest=${BACKUPPATH}backup_${BACKUPNAME}.1 --log-file=${LOGPATH}log_rsync_${BACKUPNAME}.log ${SOURCEPATH} ${BACKUPPATH}backup_${BACKUPNAME}.0/

		ln -nsf ${BACKUPPATH}backup_${BACKUPNAME}.0 ${BACKUPPATH}backup_${BACKUPNAME}.1


		# Check if backup errors
		if less  ${LOGPATH}log_rsync_sd19006_backup_kilimanjaro.log | grep error ; then 
				java -jar ${LOGPATH}sender.jar spaska.forteva@geo.uni-marburg.de forteva@staff.uni-marburg.de smtp.staff.uni-marburg.de Backup "Backup sd19006_backup_kilimanjaro: Error messages" 
		fi
	else 
		 java -jar ${LOGPATH}sender.jar spaska.forteva@geo.uni-marburg.de forteva@staff.uni-marburg.de smtp.staff.uni-marburg.de Backup "/mnt/sd19003 not mount" 
	fi
else
   java -jar ${LOGPATH}sender.jar spaska.forteva@geo.uni-marburg.de forteva@staff.uni-marburg.de smtp.staff.uni-marburg.de Backup "Cannot ping host 180" 
   java -jar ${LOGPATH}sender.jar spaska.forteva@geo.uni-marburg.de stephan.woellauer@geo.uni-marburg.de smtp.staff.uni-marburg.de Backup "Cannot ping host 180"  
fi

echo 'END ' 

date
