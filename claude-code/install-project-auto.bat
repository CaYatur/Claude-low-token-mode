@echo off
setlocal EnableExtensions
title Low Token Mode - Automatic Edition (Project)

for %%I in ("%~dp0..") do set "ROOT=%%~fI"
set "PROJECT=%~1"
set "ACTION=%~2"
set "EXIT_CODE=1"
set "MESSAGE=An unexpected error occurred."
set "DETAIL="

if /I "%~1"=="install" (
  set "ACTION=install"
  set "PROJECT="
)
if /I "%~1"=="/install" (
  set "ACTION=install"
  set "PROJECT="
)
if /I "%~1"=="remove" (
  set "ACTION=remove"
  set "PROJECT="
)
if /I "%~1"=="/remove" (
  set "ACTION=remove"
  set "PROJECT="
)
if /I "%~1"=="uninstall" (
  set "ACTION=remove"
  set "PROJECT="
)

if not defined PROJECT call :select_project_directory
call :validate_project_directory
if errorlevel 1 goto :finish

set "SOURCE=%ROOT%\skill\automatic\low-token-mode-auto"
set "TARGET=%PROJECT%\.claude\skills\low-token-mode-auto"

if not defined ACTION call :select_action
if /I "%ACTION%"=="/install" set "ACTION=install"
if /I "%ACTION%"=="/remove" set "ACTION=remove"
if /I "%ACTION%"=="uninstall" set "ACTION=remove"

if /I "%ACTION%"=="install" goto :install
if /I "%ACTION%"=="remove" goto :remove

set "MESSAGE=Invalid action. Use install or remove."
set "DETAIL=Example: %~nx0 ""%PROJECT%"" install"
goto :finish

:select_project_directory
echo.
echo Automatic Edition - Project Directory
echo Current directory: %CD%
echo.
echo [1] Use the current directory
echo [2] Choose a different project directory
echo.
choice /C 12 /N /M "Select an option [1/2]: "
if errorlevel 2 goto :enter_project_directory
set "PROJECT=%CD%"
exit /b 0

:enter_project_directory
set "PROJECT="
echo.
echo Enter the full path of the project directory.
echo You can also drag and drop the project folder into this window.
set /p "PROJECT=Project directory: "
set "PROJECT=%PROJECT:"=%"
if not defined PROJECT (
  echo.
  echo ERROR: No project directory was entered.
  goto :enter_project_directory
)
if not exist "%PROJECT%\" (
  echo.
  echo ERROR: The project directory does not exist.
  echo Path: %PROJECT%
  goto :enter_project_directory
)
exit /b 0

:validate_project_directory
set "PROJECT=%PROJECT:"=%"
if not defined PROJECT (
  set "MESSAGE=No project directory was selected."
  set "DETAIL=Select or enter a valid project directory."
  exit /b 1
)
if not exist "%PROJECT%\" (
  set "MESSAGE=The project directory does not exist."
  set "DETAIL=Project: %PROJECT%"
  exit /b 1
)
for %%I in ("%PROJECT%") do set "PROJECT=%%~fI"
exit /b 0

:select_action
echo.
echo Automatic Edition - Project Installation
echo Project: %PROJECT%
echo.
echo [1] Install or update
echo [2] Remove
echo.
choice /C 12 /N /M "Select an option [1/2]: "
if errorlevel 2 set "ACTION=remove"
if errorlevel 1 if not defined ACTION set "ACTION=install"
exit /b 0

:install
if not exist "%SOURCE%\SKILL.md" (
  set "MESSAGE=Automatic Edition SKILL.md was not found."
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
set "MESSAGE=Automatic Edition was installed successfully for this project."
set "DETAIL=Installed file: %TARGET%\SKILL.md"
goto :finish

:remove
if not exist "%TARGET%\" (
  set "EXIT_CODE=0"
  set "MESSAGE=Automatic Edition is not installed for this project. Nothing needed to be removed."
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
set "MESSAGE=Automatic Edition was removed successfully from this project."
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
echo.
echo Press any key to close this window...
pause >nul
endlocal & exit /b %EXIT_CODE%
