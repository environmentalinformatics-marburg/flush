#!/bin/bashs 
# This script creates a backup of the
# SOURCEPATE directory to a BACKUPPATH directory
FTPSOURCEPATH='/home/dogbert/data/incoming_ftp' 
GSMSOURCEPATH='/home/dogbert/data/gsm'
BACKUPPATH='/home/dogbert/data/tsm'
tsm='tsm'
LOGPATH='/home/dogbert/'

# Get date for log file
date

first=1
# Beginning of first loop.
for a in AEG AEW
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
				/usr/bin/rsync -avhe --progress --partial --log-file=${LOGPATH}log_rsync_tsm.log ${GSMSOURCEPATH}/${a}"0"${i}/tsm/* ${BACKUPPATH}/${a}"0"${i}
			fi
			# Check to make sure the ftp source folders exist
			if [ -d  ${FTPSOURCEPATH}/${a}/${a}"0"${i}/${tsm} ]; then
			        
				# Check to make sure the backup folders exist, if not creates them.
				/bin/mkdir -p ${BACKUPPATH}/${a}"0"${i}
				/usr/bin/rsync -avhe --progress --partial --log-file=${LOGPATH}log_rsync_tsm.log ${FTPSOURCEPATH}/$a/${a}"0"${i}/tsm/* ${BACKUPPATH}/${a}"0"${i}
			fi	
		
		else 
			# Check to make sure the gsm source folders exist
			if [ -d ${GSMSOURCEPATH}/${a}${i}/${tsm} ]; then
				
				# Check to make sure the folders exist, if not creates them.
				/bin/mkdir -p ${BACKUPPATH}/${a}${i}
				/usr/bin/rsync -avhe --progress --partial --log-file=${LOGPATH}log_rsync_tsm.log ${GSMSOURCEPATH}/${a}${i}/tsm/* ${BACKUPPATH}/${a}${i}
			fi
			# Check to make sure the gsm source folders exist
			if [ -d ${FTPSOURCEPATH}/${a}/${a}${i}/${tsm} ]; then
				
				# Check to make sure the folders exist, if not creates them.
				/bin/mkdir -p ${BACKUPPATH}/${a}${i}
				/usr/bin/rsync -avhe --progress --partial --log-file=${LOGPATH}log_rsync_tsm.log ${FTPSOURCEPATH}/$a/${a}${i}/tsm/* ${BACKUPPATH}/${a}${i}
			fi
		fi
	done
	#====================================== End of second the loop.
		
done

#scp -r initial eibestations@137.248.191.83:/media/data/ei_data_exploratories/download/
exit=0
