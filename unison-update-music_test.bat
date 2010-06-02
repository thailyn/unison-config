@echo off
echo This script will sync against the rsync partner on atheneum-caelestis.dynalias.net.


setlocal

rem cd c:/cygwin/bin
set INIFILE="%~dp0settings.ini"
call:getvalue %INIFILE% "outputlevel" "" OUTPUTLEVEL
call:getvalue %INIFILE% "fastcheck" "" FASTCHECKVAL
call:getvalue %INIFILE% "profilefile" "" PROFILEFILE

rem c:/cygwin/bin/unison-2.32.exe mirror-music -fastcheck yes
c:/cygwin/bin/unison-2.27.exe %PROFILEFILE% -fastcheck %FASTCHECKVAL% %OUTPUTLEVEL%
rem pause

endlocal


:getvalue
rem %1 = name of ini file to search in.
rem %2 = search term to look for
rem %3 = group name (not currently used)
rem %4 = variable to place search result
FOR /F "eol=; eol=[ tokens=1,2,3* delims==" %%i in ('findstr /b /l /i %~2= %1') DO set %~4=%%~j
rem replace last part with %%~j to take surrounding " out of j
goto:eof