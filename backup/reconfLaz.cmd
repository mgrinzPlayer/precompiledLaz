@echo off
cd /d "%~dp0"
set CurrentDir=%__CD__%
set CurrentDir=%CurrentDir:~0,-1%
echo --primary-config-path=%CurrentDir%\config>lazarus.cfg

pause
pause
pause
