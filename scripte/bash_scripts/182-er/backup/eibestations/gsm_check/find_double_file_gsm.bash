#!/bin/bash

PATH='/mnt/pc175/download/'
LOGPATH='/home/dogbert/administration/'


first=1
# Beginning of first loop.
for a in AEG AEW HEG HEW SEG SEW
do
	echo "---------------------------------------------------------"
	echo "Start of $a"
	second=1
	#====================================== Beginning of second loop.
	for i in {50..1}
	do
	 
		if (($i<10)); then
		
			# Check to make sure the gsm source folders exist
			if [ -d  ${PATH}${a}"0"${i}/backup ]; then
				 
				/usr/bin/find ${PATH}${a}"0"${i}/backup/ -name '2*.*.dat' -type f
				
			fi
		else 
			# Check to make sure the gsm source folders exist
			
			if [ -d  ${PATH}${a}${i}/backup ]; then
				
				
			      /usr/bin/find ${PATH}${a}${i}/backup/ -name '2*.*.dat' -type f
				
			fi
		fi
				
	done
	#====================================== End of second the loop.
		
done

echo "---------------------------------------------------------"
echo 'END of the check' 

/bin/date
exit=0


