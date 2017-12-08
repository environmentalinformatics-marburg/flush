#!/bin/bash

for file in /media/memory01/data/casestudies/bis-fogo/data/fogo_national_park/PG-PNF/Shapes_Lambert_Cabo_Verde/Zonas/*.*
do
	d=$( dirname "$file" )
	f=$( basename "$file" )
	#echo $f
	new=${f/[ä*|ö*|ü*|çã*|ã*|é*|ó*|á*]}
	#echo $new
	if [ "$f" != "$new" ]      # if equal, name is already clean, so leave alone
	then
		if [ -e "$d/$new" ]
		then
			echo "Notice: \"$new\" and \"$f\" both exist in "$d":"
			ls -ld "$d/$new" "$d/$f"
		else
			echo mv "$file" "$d/$new"      # remove "echo" to actually rename things
			mv "$file" "$d/$new"      # remove "echo" to actually rename things
		fi
	fi
done
