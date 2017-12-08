#!/bin/bash

chmod -R 755 /media/memory01/*
chgrp -R ei_processors /media/memory01/*
bash /home/dogbert/administration/backup/ei_backup_sd19006_data.bash >> /home/dogbert/administration/backup/log_error_sd19006_data.log 2>&1 &
