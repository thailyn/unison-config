@echo off
rem	fix ssh args to be compatible with plink (putty)
rem	Required for Unison synchronisation over ssh.
rem	Following options are probably compatible:
rem	-l name, -[1246AaCiNstTvVxX]
rem	incompatible:
rem	-p nnn (replaced by P); -e none (no equivalent)

setlocal

rem set INIFILE="C:\Users\Charles\.unison\settings.ini"
set INIFILE="%~dp0settings.ini"
call:getvalue %INIFILE% "plinkexe" "" PLINKEXE
call:getvalue %INIFILE% "username" "" USERNAME
call:getvalue %INIFILE% "servername" "" SERVERNAME

rem echo plinkexe: %PLINKEXE%
rem echo username: %USERNAME%
rem echo servername: %SERVERNAME%
rem goto:eof

rem set ARGLIST=-ssh
set ARGLIST=%SERVERNAME% -l %USERNAME%

:nextarg

if "x%1" == "x" goto doneargs

if NOT "%1" == "-p" goto checkesc
	rem plink uses upper case P to flag port number
	set ARGLIST=%ARGLIST% -P %2
	shift
	shift
	goto nextarg

:checkesc

if "%1" == "%SERVERNAME%" goto skiparg

if NOT "%1" == "-e" goto useit
	rem unison likes to include "-e none" which plink does not support.
	shift
	shift
	goto nextarg

:useit

	set ARGLIST=%ARGLIST%  %1
	shift

goto nextarg

:skiparg
	shift
	goto nextarg

endlocal

:doneargs
%PLINKEXE%  %ARGLIST%

goto:eof

:getvalue
rem %1 = name of ini file to search in.
rem %2 = search term to look for
rem %3 = group name (not currently used)
rem %4 = variable to place search result
FOR /F "eol=; eol=[ tokens=1,2,3* delims==" %%i in ('findstr /b /l /i %~2= %1') DO set %~4=%%~j
rem replace last part with %%~j to take surrounding " out of j
goto:eof
