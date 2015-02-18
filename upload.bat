@echo off

for /f  "tokens=2-4 delims=-/ " %%h in ('date /t') do set newdate=%%j%%h%%i
for /F "tokens=1-2 delims=: " %%l in ('time /t') do set hhmm=%%l%%m
set logFilePath=D:\sdc\Tools\call_center_upload_logs\call_center_upload_%newdate%_%hhmm%.log
set robocopyLog=D:\sdc\Tools\call_center_upload_logs\call_center_upload_copy_%newdate%_%hhmm%.log
set scanfile=D:\sdc\tools\call_center_upload_scan\scan_output_%newdate%_%hhmm%.txt

C:\"Program Files (x86)"\Sophos\"Sophos Anti-Virus"\sav32cli.exe -f D:\ftproot\call_center_uploads\*.* -P=%scanfile%
rem blat "%scanfile%" -to "rajagopalanr@support.com,dinesh.bandaru@support.com" -Subject "Call center uploads scan result" -from "audiosavvis@support.com"

tail -2 D:\sdc\tools\call_center_upload_scan\scan_output_%newdate%.txt > D:\sdc\Tools\temp.txt
set /p texte=< D:\sdc\Tools\temp.txt  
if "%texte%" == No viruses were discovered. ( 
echo Following files are copied into media folder > "%logfilepath%
for /f %%i in ('dir /b "D:\ftproot\call_center_uploads\*.*"') DO (
    if exist \\321538-FL-Clus\File03\assets\assets\www\media\%%i (
		rem xcopy /Y \\321538-FL-Clus\File03\assets\assets\www\media\%%i  D:\sdc\Tools\call_center_uploads\media_backup_%newdate%_%hhmm%\
	) else ( echo does not exist )
	echo %%i  >> "%logFilePath%"
	 rem robocopy \\172.16.40.215\d$\ftproot\call_center_uploads\%%i \\321538-FL-Clus\File03\assets\assets\www\media\ /MOV /COPY:DT /LOG+:%robocopyLog%
)
	echo script name : update.bat >> %logFilePath%
	echo server: 172.16.40.215 >> %logfilePath%
	( dir /b /a "D:\ftproot\call_center_uploads\" | findstr . ) > nul && (
      blat "%robocopyLog%" -to "rajagopalanr@support.com,dinesh.bandaru@support.com" -f "ftpupload@support.com" -Subject "Call center uploads to media folder" 
	  blat "%logFilePath%" -to "rajagopalanr@support.com,dinesh.bandaru@support.com,callcenterupdates@support.com" -f "ftpupload@support.com" -Subject "Call center uploads to media folder" 
    )|| (
      echo  empty
    )
	rem robocopy \\172.16.40.215\d$\ftproot\call_center_uploads \\321538-FL-Clus\File03\assets\assets\www\media\ /MOV /FP /LOG:%robocopyLog%
) else ( blat "%scanfile%" -to "rajagopalanr@support.com,dinesh.bandaru@support.com" -f "ftpupload@support.com" -Subject "Malicious files found in call center uploads" )