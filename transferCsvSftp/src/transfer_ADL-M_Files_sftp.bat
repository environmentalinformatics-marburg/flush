

javaw -Xmx2048m -jar backup_Files_sftp.jar 137.248.191.83 /media/data/ei_data_exploratories/incoming_GSM/HEG C:/ADL-M/csv/HEG
javaw -Xmx2048m -jar backup_Files_sftp.jar 137.248.191.83 /media/data/ei_data_exploratories/incoming_GSM/HEW C:/ADL-M/csv/HEW
javaw -Xmx2048m -jar backup_Files_sftp.jar 137.248.191.83 /media/data/ei_data_exploratories/incoming_GSM/SEG C:/ADL-M/csv/SEG
javaw -Xmx2048m -jar backup_Files_sftp.jar 137.248.191.83 /media/data/ei_data_exploratories/incoming_GSM/SEW C:/ADL-M/csv/SEW
javaw -Xmx2048m -jar backup_Files_sftp.jar 137.248.191.83 /media/data/ei_data_exploratories/incoming_GSM/AEG C:/ADL-M/csv/AEG
javaw -Xmx2048m -jar backup_Files_sftp.jar 137.248.191.83 /media/data/ei_data_exploratories/incoming_GSM/AEW C:/ADL-M/csv/AEW


cd C:\ADL-M\csv

for /D %%i in (C:\ADL-M\csv\*) do (
REM   	echo %%i  %%~ni %%~dpi %%~nxi
	REN %%i %%~ni_%date%
        move %%~ni_%date% ..\backup_moved
	mkdir %%~ni
)