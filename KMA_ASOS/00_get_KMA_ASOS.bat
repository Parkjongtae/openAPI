rem @echo off
rem 기상청 지상자료 / 종관기상관측자료
rem ######################################
rem # VARIABLES                          #
rem # ---------------------------------- #
rem # cDATE  : Date of yesterday         # 
rem # STNID  : Station ID                # 
rem ######################################
call 01_chkday1.bat
set /p Wday=<ymd.dat
set cDATE=%Wday:~0,8%
set STNID=108

rem set SKey=VqiOgHQ69nSztT32yg3%2BlWlqKEvWF%2Bx8OKWzhW5N7nVht%2BlraEw4LSVbDodJTs7r

echo %date% %time% GET_START > log_%cDATE%.txt 2>&1
echo +++++++++++++++++++++++++++++++ >> log_%cDATE%.txt 2>&1

rem #################################################
rem # Download KMA ASOS                             #
rem #################################################
C:\Python27\python.exe 02_get_KMA_ASOS.py %cDATE% %STNID% >> log_%cDATE%.txt 2>&1
echo. >> log_%cDATE%.txt 2>&1

echo ----------------------------- >> log_%cDATE%.txt 2>&1
echo %date% %time% GET_END >> log_%cDATE%.txt 2>&1

pause