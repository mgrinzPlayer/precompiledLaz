@echo off
cd /d "%~dp0"

set CPU_OS=i386-win32
set LAZREVSTR=62944

REM get current directory (without \ at the end)
set CurrentDir=%__CD__%
set CurrentDir=%CurrentDir:~0,-1%

set FPCINSTALLPATH=%CurrentDir%\fpc\3.2.0
set NEWFPC=%FPCINSTALLPATH%\bin\%CPU_OS%\fpc.exe
set      compOpts="OPT=-vw-n-h-l-d-u-t-p-c- -g- -Xs -O3 -CX -XX -OoREGVAR"
set fpcmakeppumove=FPCMAKE=%FPCINSTALLPATH%\bin\%CPU_OS%\fpcmake.exe PPUMOVE=%FPCINSTALLPATH%\bin\%CPU_OS%\ppumove.exe





REM COMPILE LAZARUS
:dolazarus
cd lazarus208





set path=%FPCINSTALLPATH%\bin\%CPU_OS%\

"%FPCINSTALLPATH%\bin\%CPU_OS%\fpcmkcfg.exe" -d "basepath=%FPCINSTALLPATH%" -d "sharepath=%FPCINSTALLPATH%" -o "%FPCINSTALLPATH%\bin\%CPU_OS%\fpc.cfg"
echo --primary-config-path=%CD%\config>lazarus.cfg

echo // Created by Svn2RevisionInc>ide\revision.inc
echo const RevisionStr = '%LAZREVSTR%';>>ide\revision.inc

rem compile lazbuild, registration, lazutils, lcl, basecomponents and starter
echo Compiling Lazbuild
title Compiling Lazbuild
make FPC=%NEWFPC% --directory=. %fpcmakeppumove% INSTALL_PREFIX=. USESVN2REVISIONINC=0 %compOpts% lazbuild 1>>..\LOG.txt 2>&1

echo Compiling registration lazutils lcl basecomponents
title Compiling registration lazutils lcl basecomponents
make FPC=%NEWFPC% --directory=. %fpcmakeppumove% INSTALL_PREFIX=. USESVN2REVISIONINC=0 %compOpts% registration lazutils lcl basecomponents 1>>..\LOG.txt 2>&1

echo Compiling starter
title Compiling starter
make FPC=%NEWFPC% --directory=. %fpcmakeppumove% INSTALL_PREFIX=. USESVN2REVISIONINC=0 %compOpts% starter 1>>..\LOG.txt 2>&1

rem compile Lazarus
echo Compiling Lazarus
title Compiling Lazarus
lazbuild.exe --compiler=%NEWFPC% --add-package components\sqldb\sqldblaz.lpk 1>>..\LOG.txt 2>&1
lazbuild.exe --compiler=%NEWFPC% "--build-ide=-dKeepInstalledPackages -g- -Xs -O3 -CX -XX -OoREGVAR" 1>>..\LOG.txt 2>&1

pause
pause
