@echo off
cd /d "%~dp0"

rem 32bit Laz and FPC
set CPU_OS=i386-win32

set FPCREVSTR=45643

REM get current directory (without \ at the end)
set CurrentDir=%__CD__%
set CurrentDir=%CurrentDir:~0,-1%

set FPCINSTALLPATH=%CurrentDir%\fpc\3.2.0

set FPCSRC=%CurrentDir%\fpcsrc
set FPCMAKEPPUMOVE=FPCMAKE=%FPCINSTALLPATH%\bin\%CPU_OS%\fpcmake.exe PPUMOVE=%FPCINSTALLPATH%\bin\%CPU_OS%\ppumove.exe
set OLDFPC32=%CurrentDir%\bootstrap\ppc386.exe
set OLDFPC64=%CurrentDir%\bootstrap\ppcx64.exe
set NEWFPC=%FPCINSTALLPATH%\bin\%CPU_OS%\fpc.exe
set CROSS32=%FPCINSTALLPATH%\bin\%CPU_OS%\ppcross386.exe
set CROSS64=%FPCINSTALLPATH%\bin\%CPU_OS%\ppcrossx64.exe

set SOURCE32_TARGET32=CPU_SOURCE=i386   OS_SOURCE=win32 CPU_TARGET=i386   OS_TARGET=win32
set SOURCE32_TARGET64=CPU_SOURCE=i386   OS_SOURCE=win32 CPU_TARGET=x86_64 OS_TARGET=win64
set SOURCE64_TARGET32=CPU_SOURCE=x86_64 OS_SOURCE=win64 CPU_TARGET=i386   OS_TARGET=win32
set SOURCE64_TARGET64=CPU_SOURCE=x86_64 OS_SOURCE=win64 CPU_TARGET=x86_64 OS_TARGET=win64

set fpc_common=--directory=%FPCSRC% %FPCMAKEPPUMOVE% PREFIX=%FPCINSTALLPATH% INSTALL_PREFIX=%FPCINSTALLPATH%

set   compOpts="OPT=-vw-n-h-l-d-u-t-p-c- -g- -b- -Xs -O3 -CX -XX -OoREGVAR"
set compOpts64="OPT=-vw-n-h-l-d-u-t-p-c- -g- -b- -Xs -O3 -CX -XX -OoREGVAR -dFPC_SOFT_FPUX80"
set      Env32bit=%fpc_common% %SOURCE32_TARGET32%                          REVINC=force REVSTR=%FPCREVSTR%
set Env32bitCross=%fpc_common% %SOURCE32_TARGET64% CROSSINSTALL=1 NOGDBMI=1 REVINC=force REVSTR=%FPCREVSTR%
set      Env64bit=%fpc_common% %SOURCE64_TARGET64%                          REVINC=force REVSTR=%FPCREVSTR%
set Env64bitCross=%fpc_common% %SOURCE64_TARGET32% CROSSINSTALL=1 NOGDBMI=1 REVINC=force REVSTR=%FPCREVSTR%

md %FPCINSTALLPATH%\bin\%CPU_OS% 2>nul
copy /Y bootstrap\*  %FPCINSTALLPATH%\bin\%CPU_OS% 1>nul
rem remove old compiler
del /f /q "%FPCINSTALLPATH%\bin\%CPU_OS%\ppc386.exe" 2>nul
del /f /q "%FPCINSTALLPATH%\bin\%CPU_OS%\ppcx64.exe" 2>nul
del /f /q "%FPCINSTALLPATH%\bin\%CPU_OS%\ppcross386.exe" 2>nul
del /f /q "%FPCINSTALLPATH%\bin\%CPU_OS%\ppcrossx64.exe" 2>nul

set path=%CurrentDir%\bootstrap

if "%CPU_OS%"=="i386-win32" (
echo all install
make --jobs=4 FPC=%OLDFPC32% %Env32bit%       %compOpts% all install          1>LOG.txt 2>&1
echo cross compiler
make --jobs=4 FPC=%NEWFPC%   %Env32bitCross%  %compOpts% compiler_cycle      1>>LOG.txt 2>&1
make --jobs=4 FPC=%NEWFPC%   %Env32bitCross%  %compOpts% compiler_install    1>>LOG.txt 2>&1
echo rtl cross compiler
make --jobs=4 FPC=%CROSS64%  %Env32bitCross%  %compOpts% rtl                 1>>LOG.txt 2>&1
make --jobs=4 FPC=%CROSS64%  %Env32bitCross%  %compOpts% rtl_install         1>>LOG.txt 2>&1
echo packages cross compiler
make --jobs=4 FPC=%CROSS64%  %Env32bitCross%  %compOpts% packages            1>>LOG.txt 2>&1
make --jobs=4 FPC=%CROSS64%  %Env32bitCross%  %compOpts% packages_install    1>>LOG.txt 2>&1
) else if "%CPU_OS%"=="x86-win64" (
echo all install
make --jobs=4 FPC=%OLDFPC64% %Env64bit%       %compOpts64% all install        1>LOG.txt 2>&1
echo cross compiler
make --jobs=4 FPC=%NEWFPC%   %Env64bitCross%  %compOpts64% compiler_cycle    1>>LOG.txt 2>&1
make --jobs=4 FPC=%NEWFPC%   %Env64bitCross%  %compOpts64% compiler_install  1>>LOG.txt 2>&1
echo rtl cross compiler
make --jobs=4 FPC=%CROSS32%  %Env64bitCross%  %compOpts% rtl                 1>>LOG.txt 2>&1
make --jobs=4 FPC=%CROSS32%  %Env64bitCross%  %compOpts% rtl_install         1>>LOG.txt 2>&1
echo packages cross compiler
make --jobs=4 FPC=%CROSS32%  %Env64bitCross%  %compOpts% packages            1>>LOG.txt 2>&1
make --jobs=4 FPC=%CROSS32%  %Env64bitCross%  %compOpts% packages_install    1>>LOG.txt 2>&1
)

set path=%FPCINSTALLPATH%\bin\%CPU_OS%\

fpcmkcfg -d "basepath=%FPCINSTALLPATH%" -d "sharepath=%FPCINSTALLPATH%" -o "%FPCINSTALLPATH%\bin\%CPU_OS%\fpc.cfg"

pause
pause


