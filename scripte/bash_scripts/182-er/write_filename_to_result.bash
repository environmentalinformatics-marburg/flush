#!/bin/bash
PFAD="/home/eikistations/ei_data_kilimanjaro/processing/tlc/processing/"


for n in 2012 2013 2014
do 
for i in {1..12} 
	do  
		if [ -e $PFAD ]; then

			z=$PFAD$n/\0$i

			if (( $i>9)) ; then z=$PFAD$n/$i 
				if [ -d $z ] ; then 
				cd $z

				ls  >> /home/eikistations/ei_data_kilimanjaro/processing/tlc/result_number_images$n.txt   
			
			   
				fi  
			fi
			
			
			if [ -d $z ] ; then 
				cd $z

				ls  >> /home/eikistations/ei_data_kilimanjaro/processing/tlc/result_number_images$n.txt   
			
			   
			fi
	fi
done 
done


