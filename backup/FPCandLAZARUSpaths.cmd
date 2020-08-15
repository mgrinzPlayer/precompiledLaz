@echo off
cd /d "%~dp0"
set CurrentDir=%__CD__%
set CurrentDir=%CurrentDir:~0,-1%
echo --primary-config-path=%CurrentDir%\config>lazarus.cfg
set FPCINSTALLPATH=%CurrentDir%\fpc\3.2.0
"%FPCINSTALLPATH%\bin\i386-win32\fpcmkcfg.exe" -d "basepath=%FPCINSTALLPATH%" -d "sharepath=%FPCINSTALLPATH%" -o "%FPCINSTALLPATH%\bin\i386-win32\fpc.cfg"
