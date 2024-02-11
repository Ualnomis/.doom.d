@echo off
setlocal

:: Get the full path of the file
set "winFilePath=%~1"
for /f "tokens=*" %%i in ('wsl wslpath "%winFilePath%" ') do set "wslFilePath=%%i"

:: Run the command in Pengwin
"%LOCALAPPDATA%\Microsoft\WindowsApps\pengwinw.exe" run cd ~;env PENGWIN_COMMAND='/usr/bin/emacs \"%wslFilePath%\"' bash -l -c echo

endlocal
