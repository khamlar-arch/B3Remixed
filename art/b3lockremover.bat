@echo off
color 03
echo WAIT!!! this will clear all of your b3 savedata!!
echo If you wish to continue, press enter, or else, exit this program
pause
setlocal enableDelayedExpansion
rmdir /s /q "%ProgramData%\nothingtoseehere"
rmdir /s /q "%LOCALAPPDATA%\nothingtoseehere"
rmdir /s /q "%APPDATA%\nothingtoseehere"
rmdir /s /q "%APPDATA%\ShadowMario\B3EXEmixed"
echo DONE!! it's now safe to exit this program
pause