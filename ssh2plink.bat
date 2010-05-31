@echo off
rem	fix ssh args to be compatible with plink (putty)
rem	Required for Unison synchronisation over ssh.
rem	Following options are probably compatible:
rem	-l name, -[1246AaCiNstTvVxX]
rem	incompatible:
rem	-p nnn (replaced by P); -e none (no equivalent)

setlocal

rem	Edit this to point to your location for plink.exe
rem set PLINKEXE="C:\Program Files (x86)\PuTTY\plink.exe"
set PLINKEXE=plink

rem set ARGLIST=-ssh
set ARGLIST=atheneum-caelestis.dynalias.net -l charles

:nextarg

if "x%1" == "x" goto doneargs

if NOT "%1" == "-p" goto checkesc
	rem plink uses upper case P to flag port number
	set ARGLIST=%ARGLIST% -P %2
	shift
	shift
	goto nextarg

:checkesc

if "%1" == "atheneum-caelestis.dynalias.net" goto skiparg

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
