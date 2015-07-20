#!/bin/bash


first=1
# Beginning of first loop.
for a in AEW AEG HEW HEG SEW SEG
do
	echo "initial/$a"
	second=1
	#======================================
	# Beginning of second loop.
	for b in _0005
	do
		echo "processed/$a/$b"
		let "second+=1"
	#======================================
		# Beginning of third loop.
		for c in _2013
		do
			#echo "$a/be/000$a*/ca*$b/*$c*.dat"
			#zip -e "initial/$a/$b/$a$b$c" "$a/be/000$a*/*$b/*$c*.dat"
			echo zip "initial/$a.zip"  "$a/be/000$a*/ca*0005/*"

			let "third+=1"
		done
	let "first+=1"
	done
done

#scp -r initial eibestations@137.248.191.83:/media/data/ei_data_exploratories/download/
exit=0
