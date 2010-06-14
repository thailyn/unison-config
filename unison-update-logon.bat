@echo off
echo This script will sync against the rsync partner on atheneum-caelestis.dynalias.net.  Set up Pageant before continuing.
pause

rem set /P password=Password:
rem echo passwrd:%password%
rem c:/cygwin/bin/unison-2.27.exe driver-logon -fastcheck yes -sshargs "-pw %password%"
c:/cygwin/bin/unison-2.27.exe driver-logon -fastcheck yes
pause
