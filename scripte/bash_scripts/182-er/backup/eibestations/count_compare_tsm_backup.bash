#!/bin/bash

PATH='/mnt/pc175/download/'
PATH83='/mnt/sd19460/incoming_ftp/adl-m/'
PATH182='/home/eibestations/ei_data_exploratories/tsm/'
LOGPATH='/home/dogbert/administration/'


first=1
# Beginning of first loop.
for a in AEG AEW HEG HEW SEG SEW HET SET
do
	echo "---------------------------------------------------------"
	echo "Start of $a"
	second=1
	#====================================== Beginning of second loop.
	for i in {50..1}
	do
	 
		if (($i<10)); then
		
			# Check to make sure the gsm source folders exist
			if [ -d  ${PATH}${a}"0"${i}/tsm ]; then
				 
		
				b=($(/usr/bin/find ${PATH}${a}"0"${i}/tsm/ -type f | /usr/bin/wc -l));
				t=($(/usr/bin/find ${PATH182}${a}"0"${i}/ -type f | /usr/bin/wc -l));
				ftp=($(/usr/bin/find ${PATH83}$a/${a}"0"${i}/tsm/ -type f | /usr/bin/wc -l));
				if  ((($b+$ftp)<$t)); then
					echo /usr/bin/diff ${PATH182}${a}"0"${i}/
					echo $b+$ftp
					echo $t
						    
				fi
				
			fi
		else 
			# Check to make sure the gsm source folders exist
			
			if [ -d  ${PATH}${a}${i}/tsm ]; then
			
			      	b=($(/usr/bin/find ${PATH}${a}${i}/tsm/ -type f | /usr/bin/wc -l));
			      	t=($(/usr/bin/find ${PATH182}${a}${i}/ -type f | /usr/bin/wc -l));
			      	ftp=($(/usr/bin/find ${PATH83}$a/${a}${i}/tsm/ -type f | /usr/bin/wc -l));
				if  ((($b+$ftp)<$t)); then
					echo /usr/bin/diff ${PATH182}${a}${i}/
					echo $b+$ftp
					echo $t	    
				fi
			fi
		fi
				
	done
	#====================================== End of second the loop.
		
done

echo "---------------------------------------------------------"
echo 'END of the check' 

/bin/date
exit=0


