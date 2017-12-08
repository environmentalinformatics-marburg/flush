#!/bin/bash
# This script creates a 18 day long rotating backup of the
# SOURCEPATH directory to the BACKUPPATH directory.
# Crontab entry: 0 2 * * * bash /home/dogbert/administration/backup/ei_backup_sd19006_data.bash >> /home/dogbert/administration/backup/log_error_sd19006_data.log 2>&1 &

SOURCEPATH='/media/memory01/data/' 
BACKUPPATH='/mnt/sd19003/sd19006_backup_data/'
BACKUPNAME='sd19006_backup_data'
LOGPATH='/home/dogbert/administration/backup/'

# Get date for log file
date

# Check to make sure the folders exist, if not creates them.
/bin/mkdir -p ${BACKUPPATH}backup_${BACKUPNAME}.{0..18}

# Delete the oldest backup folder.
/bin/rm -rf ${BACKUPPATH}backup_${BACKUPNAME}.18

# Shift all the backup folders up a day.
for i in {18..1}
do
/bin/mv ${BACKUPPATH}backup_${BACKUPNAME}.$[${i}-1] ${BACKUPPATH}backup_${BACKUPNAME}.${i}
done

# Create the new backup hard linking with the previous backup.
# This allows for the least amount of data possible to be
# transfered while maintaining a complete backup.
/usr/bin/rsync -a -e --copy-links --copy-unsafe-links --delete --exclude=".*" --link-dest=${BACKUPPATH}backup_${BACKUPNAME}.1 --log-file=${LOGPATH}log_rsync_${BACKUPNAME}.log ${SOURCEPATH} ${BACKUPPATH}backup_${BACKUPNAME}.0/

ln -nsf ${BACKUPPATH}backup_${BACKUPNAME}.0 ${BACKUPPATH}backup_${BACKUPNAME}.1

