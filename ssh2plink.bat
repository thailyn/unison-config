@echo off
rem	fix ssh args to be compatible with plink (putty)
rem	Required for Unison synchronisation over ssh.
rem	Following options are probably compatible:
rem	-l name, -[1246AaCiNstTvVxX]
rem	incompatible:
rem	-p nnn (replaced by P); -e none (no equivalent)

setlocal

set INIFILE="%~dp0settings.ini"
call:getvalue %INIFILE% "fullplinkexe" "" PLINKEXE
call:getvalue %INIFILE% "username" "" USERNAME
call:getvalue %INIFILE% "servername" "" SERVERNAME

rem  To test reading from the ini file:
rem echo plinkexe: %PLINKEXE%
rem echo username: %USERNAME%
rem echo servername: %SERVERNAME%
rem goto:eof

rem  Initialize the argument list based on the ini file contents.
set ARGLIST=%SERVERNAME% -l %USERNAME%

rem  On Windows XP this file can be run with the path to itself, and if there 
rem are spaces in the path it will take the place of multiple arguments.  The
rem first parameter we care about starts with the server name, so throw out 
rem arguments until we get to that point.
:filterpath
if "%1" == "%SERVERNAME%" goto nextarg
   shift
   goto filterpath

rem  Start of loop for parsing arguments.
:nextarg

rem  Exit out of the loop if we are out of arguments.
if "[%1]" == "[]" goto doneargs

rem  Handle arguments that require nontrivial consideration.
if "%1" == "-p" goto setport
if "%1" == "-pw" goto setpassword
if "%1" == "%SERVERNAME%" goto setserver
if "%1" == "-e" goto droparge

rem  Absorb other arguments (trivially add them).
:useit
        set ARGLIST=%ARGLIST% %1
        shift

rem  Loop to the next argument.
goto nextarg

endlocal

:doneargs
rem echo %PLINKEXE% %ARGLIST%
"%PLINKEXE%" %ARGLIST%

goto:eof

rem ---------------------------------------------------
rem ---------------------------------------------------
rem Helper Functions:

:setport
rem plink uses upper case P to flag port number
set ARGLIST=%ARGLIST% -P %2
shift
shift
goto nextarg

:setserver
rem we actually don't need the server from the command line.  remove it
shift
goto nextarg

:setpassword
set ARGLIST=%ARGLIST% -pw %2
shift
shift
goto nextarg

:droparge
rem unison likes to include "-e none" which plink does not support.
shift
shift
goto nextarg


:getvalue
rem %1 = name of ini file to search in.
rem %2 = search term to look for
rem %3 = group name (not currently used)
rem %4 = variable to place search result
FOR /F "eol=; eol=[ tokens=1,2,3* delims==" %%i in ('findstr /b /l /i %~2= %1') DO set %~4=%%~j
rem replace last part with %%~j to take surrounding " out of j
goto:eof

