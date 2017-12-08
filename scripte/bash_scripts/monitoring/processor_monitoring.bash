#!/bin/bash
data=`date --date=-1day +%Y%m%d%s`
fileshort=/home/dogbert/administration/monitoring/proc_$data.csv
 
Rscript /home/dogbert/administration/monitoring/processor_monitoring.R $fileshort --save
