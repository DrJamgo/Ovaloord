::
:: zipme batch script for 'Overloord'
::

SET LOVE_PATH=C:\LOVE
SET ZIPEXE="C:\Program Files (x86)\WinRAR\WinRAR.exe"
SET GAMENAME=Overloord
SET PACKAGE_DIR=%GAMENAME%
SET ZIPFILE=%GAMENAME%.zip
SET LOVEFILE=%GAMENAME%.love
SET GIT=
SET GAMEPACKAGE=%GAMENAME%_%GIT%.7z


IF EXIST %GAMEPACKAGE% DEL /F %GAMEPACKAGE%

%ZIPEXE% a -y -afzip %ZIPFILE% lua assets *.lua
::tar -cvf %ZIPFILE% lua assets *.lua  <<-- doesn't support zip
copy %ZIPFILE% %LOVEFILE%

mkdir %PACKAGE_DIR%
copy /b %LOVE_PATH%\love.exe+%GAMENAME% %PACKAGE_DIR%\%GAMENAME%.exe
copy /b %LOVE_PATH%\*.dll %PACKAGE_DIR%
copy /b %LOVE_PATH%\license.txt %PACKAGE_DIR%

tar -cvf %GAMEPACKAGE% %PACKAGE_DIR%

IF EXIST %ZIPFILE% DEL /F %ZIPFILE%
IF EXIST %PACKAGE_DIR% DEL /F %PACKAGE_DIR%
IF EXIST %LOVEFILE% DEL /F %LOVEFILE%

pause