rem without .svn
7za.exe a fpcsrc.7z -y -mm=lzma2 -mx=1 -xr!".svn" fpcsrc

rem with .svn
7za.exe a fpcsrcsvn.7z -y -mm=lzma2 -mx=1 fpcsrc\.svn
