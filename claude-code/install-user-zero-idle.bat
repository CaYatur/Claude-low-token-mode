@echo off
setlocal EnableExtensions
title Low Token Mode - Zero-Idle Edition (User)

for %%I in ("%~dp0..") do set "ROOT=%%~fI"
set "ACTION=%~1"
set "SOURCE=%ROOT%\skill\zero-idle\low-token-mode-zero-idle"
set "TARGET=%USERPROFILE%\.claude\skills\low-token-mode-zero-idle"
set "EXIT_CODE=1"
set "MESSAGE=An unexpected error occurred."
set "DETAIL="

if not defined ACTION call :select_action
if /I "%ACTION%"=="/install" set "ACTION=install"
if /I "%ACTION%"=="/remove" set "ACTION=remove"
if /I "%ACTION%"=="uninstall" set "ACTION=remove"

if /I "%ACTION%"=="install" goto :install
if /I "%ACTION%"=="remove" goto :remove

set "MESSAGE=Invalid action. Use install or remove."
set "DETAIL=Example: %~nx0 install"
goto :finish

:select_action
echo.
echo Zero-Idle Edition - User Installation
echo User profile: %USERPROFILE%
echo.
echo [1] Install or update
echo [2] Remove
echo.
choice /C 12 /N /M "Select an option [1/2]: "
set "MENU_CHOICE=%ERRORLEVEL%"
if "%MENU_CHOICE%"=="1" set "ACTION=install"
if "%MENU_CHOICE%"=="2" set "ACTION=remove"
exit /b 0

:install
if not exist "%SOURCE%\SKILL.md" (
  set "MESSAGE=Zero-Idle Edition SKILL.md was not found."
  set "DETAIL=Expected file: %SOURCE%\SKILL.md"
  goto :finish
)

if not exist "%TARGET%\" mkdir "%TARGET%" >nul 2>&1
if errorlevel 1 (
  set "MESSAGE=The target directory could not be created."
  set "DETAIL=Target: %TARGET%"
  goto :finish
)

copy /Y "%SOURCE%\SKILL.md" "%TARGET%\SKILL.md" >nul 2>&1
if errorlevel 1 (
  set "MESSAGE=Installation failed while copying SKILL.md."
  set "DETAIL=Target: %TARGET%\SKILL.md"
  goto :finish
)

set "EXIT_CODE=0"
set "MESSAGE=Zero-Idle Edition was installed successfully for this user."
set "DETAIL=Installed file: %TARGET%\SKILL.md"
goto :finish

:remove
if not exist "%TARGET%\" (
  set "EXIT_CODE=0"
  set "MESSAGE=Zero-Idle Edition is not installed for this user. Nothing needed to be removed."
  set "DETAIL=Checked location: %TARGET%"
  goto :finish
)

rmdir /S /Q "%TARGET%" >nul 2>&1
if exist "%TARGET%\" (
  set "MESSAGE=Removal failed. The target directory still exists."
  set "DETAIL=Target: %TARGET%"
  goto :finish
)

set "EXIT_CODE=0"
set "MESSAGE=Zero-Idle Edition was removed successfully for this user."
set "DETAIL=Removed location: %TARGET%"
goto :finish

:finish
echo.
if "%EXIT_CODE%"=="0" (
  echo SUCCESS: %MESSAGE%
) else (
  echo ERROR: %MESSAGE%
)
if defined DETAIL echo %DETAIL%
if "%EXIT_CODE%"=="0" if /I "%ACTION%"=="install" echo Invoke with: /low-token-mode-zero-idle basic
echo.
echo Press any key to close this window...
pause >nul
endlocal & exit /b %EXIT_CODE%
