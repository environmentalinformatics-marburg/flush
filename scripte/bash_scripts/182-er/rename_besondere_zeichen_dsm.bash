#!/bin/bash

#find -name "*[äöüÄÖÜß]*" -exec rename 's/ä/ae/g;s/ö/oe/g' {} \; 
#sudo find /media/memory01/ -name "*.[äö]*"  -exec rename 's/ä/ae/g;s/ö/oe/g' {} \;
# sudo find /media/memory01/ -name "*.[ÄÖ]*"  -exec rename 's/Ä/Ae/g;s/Ö/Oe/g' {} \;
#sudo find /media/memory01/ -name "*[ßÜ]*"  -exec rename 's/ß/Ss/g;s/Ü/Ue/g' {} \;
# sudo find /media/memory01/ -name "*.[ßü]*"  -exec rename 's/ß/ss/g;s/ü/ue/g' {} \;

# sudo find /media/memory01/data/casestudies/bis-fogo/data/fogo_national_park/PG-PNF/Shapes/AVES/AVES pc antigo/ -name "*.[çã]*"  -exec rename 's/çã/ca/g' {} \;

for file in /media/memory01/data/users/hmeyer/backup_Laptop_HM/Documents_20170630/Presentations/Paper/published/LudwigEtAl2015_GoogleImages/*.*
do
	d=$( dirname "$file" )
	f=$( basename "$file" )
	new=${f//’/_}
	new=${f//®/_}
	new=${f// /_}
	new=${f//,/_}
	new=${f//__/_}
	new=${f// -/-}
	new=${f//_-_/-}
	new=${new//ä/ae}
	new=${new//ü/ue}
	new=${new//õ/o}
	new=${new//ö/oe}
	new=${new//ß/ss}
	new=${new//Á/A}
	new=${new//á/a}
	new=${new//ó/o}
	new=${new//ã/a}
	new=${new//é/e}
	new=${new//Ü/Ue}
	new=${new//Д/d}
	new=${new//Ф/oe}
	new=${new//Ã³/A}
	new=${new//Ã/A}
	new=${new//Ã¼/ue}
	new=${new//ê/e}
	new=${new//í/i}
	new=${new//Б/ue}
	new=${new//§/ir}
	new=${new///a}
	new=${new//—/-}
	new=${new//–/-}
	new=${new/[çã*|!*|˜*]}
	
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


