javaw -Xmx2048m -jar transferLocal.jar 

cd C:\ADL-M\download

for /D %%i in (C:\ADL-M\download\*) do (
    	echo %%i  %%~ni %%~dpi %%~nxi
	del %%~ni\csv\*.csv
)