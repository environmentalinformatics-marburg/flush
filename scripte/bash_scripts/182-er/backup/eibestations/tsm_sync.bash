#!/bin/bashs 
# This script creates a backup of the
# SOURCEPATE directory to a BACKUPPATH directory bash /home/dogbert/administration/backup/tsm_sync.bash >> /home/dogbert/administration/backup/tsm_update.log 2>&1 &

FTPSOURCEPATH='/mnt/sd19460/incoming_ftp/adl-m' 
GSMSOURCEPATH='/mnt/pc175/download'
BACKUPPATH='/media/memory01/ei_data_exploratories/tsm/'
TSMHDPATH='/home/eibestations/ei_data_exploratories/tsm_hd_add'
tsm='tsm'
LOGPATH='/home/eibestations/administration/'

# Get date for log file
date

first=1
# Beginning of first loop.
for a in AEG AEW HEG HEW SEG SEW SET AET
do
	echo "initial/$a"
	second=1
	#====================================== Beginning of second loop.
	for i in {50..1}
	do
		if (($i<10)); then
			# Check to make sure the gsm source folders exist
			if [ -d  ${GSMSOURCEPATH}/${a}"0"${i}/${tsm} ]; then
			        
				# Check to make sure the backup folders exist, if not creates them.
				/bin/mkdir -p ${BACKUPPATH}/${a}"0"${i}
				/usr/bin/rsync -av --progress --partial --exclude="*.2*.dat" --log-file=${LOGPATH}log_rsync_tsm.log ${GSMSOURCEPATH}/${a}"0"${i}/tsm/* ${BACKUPPATH}/${a}"0"${i}
			fi
			# Check to make sure the ftp source folders exist
			if [ -d  ${FTPSOURCEPATH}/${a}/${a}"0"${i}/${tsm} ]; then
			        
				# Check to make sure the backup folders exist, if not creates them.
				/bin/mkdir -p ${BACKUPPATH}/${a}"0"${i}
				/usr/bin/rsync -av --progress --partial --exclude="*.2*.dat" --log-file=${LOGPATH}log_rsync_tsm.log ${FTPSOURCEPATH}/$a/${a}"0"${i}/tsm/* ${BACKUPPATH}/${a}"0"${i}
			fi
			# Check to make sure the hd source folders exist
			if [ -d  ${TSMHDPATH}/${a}"0"${i} ]; then
			        
				# Check to make sure the backup folders exist, if not creates them.
				/bin/mkdir -p ${BACKUPPATH}/${a}"0"${i}
				/usr/bin/rsync -av --progress --partial --exclude="*.2*.dat" --log-file=${LOGPATH}log_rsync_tsm.log ${TSMHDPATH}/${a}"0"${i}/* ${BACKUPPATH}/${a}"0"${i}
			fi	
		
		else 
			# Check to make sure the gsm source folders exist
			if [ -d ${GSMSOURCEPATH}/${a}${i}/${tsm} ]; then
				
				# Check to make sure the backup folders exist, if not creates them.
				/bin/mkdir -p ${BACKUPPATH}/${a}${i}
				/usr/bin/rsync -av --progress --partial --exclude="*.2*.dat" --log-file=${LOGPATH}log_rsync_tsm.log ${GSMSOURCEPATH}/${a}${i}/tsm/* ${BACKUPPATH}/${a}${i}
			fi
			# Check to make sure the gsm source folders exist
			if [ -d ${FTPSOURCEPATH}/${a}/${a}${i}/${tsm} ]; then
				
				# Check to make sure the backup folders exist, if not creates them.
				/bin/mkdir -p ${BACKUPPATH}/${a}${i}
				/usr/bin/rsync -av --progress --partial --exclude="*.2*.dat" --log-file=${LOGPATH}log_rsync_tsm.log ${FTPSOURCEPATH}/$a/${a}${i}/tsm/* ${BACKUPPATH}/${a}${i}
			fi
			# Check to make sure the  hd source folders exist
			if [ -d ${TSMHDPATH}/${a}${i} ]; then
				
				# Check to make sure the backup folders exist, if not creates them.
				/bin/mkdir -p ${BACKUPPATH}/${a}${i}
				/usr/bin/rsync -av --progress --partial --exclude="*.2*.dat" --log-file=${LOGPATH}log_rsync_tsm.log ${TSMHDPATH}/${a}${i}/* ${BACKUPPATH}/${a}${i}
			fi
		fi
	done
	#====================================== End of second the loop.
		
done

chown eibestations:ei_processors -R ${BACKUPPATH}
chmod 755 -R ${BACKUPPATH}
#scp -r initial eibestations@137.248.191.83:/media/data/ei_data_exploratories/download/
exit=0
