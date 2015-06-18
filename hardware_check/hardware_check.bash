#!/bin/bash

date

/home/dogbert/administration/hardware_check/MegaCli/MegaCli64 -PDList -aAll >> /home/dogbert/administration/hardware_check/pdlist.log 

grep "Predictive Failure Count:" /home/dogbert/administration/hardware_check/pdlist.log  >> /home/dogbert/administration/hardware_check/hardware_error.txt
DATE=`date +%Y-%m-%d` ;
echo $DATE >> /home/dogbert/administration/hardware_check/hardware_error.txt

