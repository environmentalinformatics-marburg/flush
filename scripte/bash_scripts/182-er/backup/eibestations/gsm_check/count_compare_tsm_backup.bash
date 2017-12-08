#!/bin/bash

PATH='/mnt/pc175/download/'
LOGPATH='/home/dogbert/administration/'


first=1
# Beginning of first loop.
for a in SEG SEW
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
				 
				
				b=($(/usr/bin/find ${PATH}${a}"0"${i}/backup/ -type f | /usr/bin/wc -l));
				t=($(/usr/bin/find ${PATH}${a}"0"${i}/tsm/ -type f | /usr/bin/wc -l));

				if [ $b -ne $t ]; then
					echo /usr/bin/diff ${PATH}${a}"0"${i}/backup 
					echo $b
					echo $t
					echo "ERROR - number files conflict:" ;


					#java -jar ${LOGPATH}sender.jar spaska.forteva@geo.uni-marburg.de forteva@staff.uni-marburg.de smtp.staff.uni-marburg.de Backup "Counts conflict tsm backup:  Error messages" 	    
				fi
				
			fi
		else 
			# Check to make sure the gsm source folders exist
			
			if [ -d  ${PATH}${a}${i}/backup ]; then
				
				
			      	b=($(/usr/bin/find ${PATH}${a}${i}/backup/ -type f | /usr/bin/wc -l));
			      	t=($(/usr/bin/find ${PATH}${a}${i}/tsm/ -type f | /usr/bin/wc -l));

				if [ $b -ne $t ]; then
			      		echo /usr/bin/diff ${PATH}${a}${i}/backup
			      		echo $b
					echo $t
					echo "ERROR - number files conflict:" ;
					#java -jar ${LOGPATH}sender.jar spaska.forteva@geo.uni-marburg.de forteva@staff.uni-marburg.de smtp.staff.uni-marburg.de Backup "Counts conflict tsm backup: Error messages"    
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


