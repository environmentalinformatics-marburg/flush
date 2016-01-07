#!/bin/bash
# This script creates a 30 day long rotating backup of the
# SOURCEPATH directory to the BACKUPPATH directory.
# Crontab entry: 0 5 * * * bash /home/dogbert/administration/backup/ei_backup_sd19006_south_africa.bash >> /home/dogbert/administration/backup/log_error_sd19006_south_africa.log 2>&1 

SOURCEPATH='/home/south_africa/ei_data_south_africa/' 
BACKUPPATH='/mnt/sd19003/sd19006_backup_south_africa/'
BACKUPNAME='sd19006_backup_south_africa'
LOGPATH='/home/dogbert/administration/backup/'

# Get date for log file
date

# Check to make sure the folders exist, if not creates them.
/bin/mkdir -p ${BACKUPPATH}backup_${BACKUPNAME}.{0..3}

# Delete the oldest backup folder.
/bin/rm -rf ${BACKUPPATH}backup_${BACKUPNAME}.3

# Shift all the backup folders up a day.
for i in {3..1}
do
/bin/mv ${BACKUPPATH}backup_${BACKUPNAME}.$[${i}-1] ${BACKUPPATH}backup_${BACKUPNAME}.${i}
done

# Create the new backup hard linking with the previous backup.
# This allows for the least amount of data possible to be
# transfered while maintaining a complete backup.
/usr/bin/rsync -a -e --copy-links --copy-unsafe-links --delete --exclude=".*" --link-dest=${BACKUPPATH}backup_${BACKUPNAME}.1 --log-file=${LOGPATH}log_rsync_${BACKUPNAME}.log ${SOURCEPATH} ${BACKUPPATH}backup_${BACKUPNAME}.0/

ln -nsf ${BACKUPPATH}backup_${BACKUPNAME}.0 ${BACKUPPATH}backup_${BACKUPNAME}.1

