@echo off
setlocal EnableExtensions
title Claude Code - Strict Low-Cost Profile

for %%I in ("%~dp0..") do set "ROOT=%%~fI"
set "PROFILE=%ROOT%\claude-code\profiles\strict-low-cost.settings.json"
set "PROJECT_DIR=%~1"
set "EXIT_CODE=1"
set "MESSAGE=An unexpected error occurred."
set "DETAIL="

where claude >nul 2>&1
if errorlevel 1 (
  set "MESSAGE=Claude Code was not found in PATH."
  set "DETAIL=Install Claude Code or add the claude command to PATH, then try again."
  goto :finish
)

if not exist "%PROFILE%" (
  set "MESSAGE=The strict low-cost settings profile was not found."
  set "DETAIL=Expected file: %PROFILE%"
  goto :finish
)

if not defined PROJECT_DIR call :select_project_directory
call :validate_project_directory
if errorlevel 1 goto :finish

pushd "%PROJECT_DIR%" >nul 2>&1
if errorlevel 1 (
  set "MESSAGE=The project directory could not be opened."
  set "DETAIL=Project directory: %PROJECT_DIR%"
  goto :finish
)

for %%I in (.) do set "PROJECT_DIR=%%~fI"

echo.
echo Starting Claude Code with the strict low-cost profile...
echo Project directory: %PROJECT_DIR%
echo Profile: %PROFILE%
echo.

call claude --effort low --settings "%PROFILE%"
set "CLAUDE_EXIT_CODE=%ERRORLEVEL%"
popd

if not "%CLAUDE_EXIT_CODE%"=="0" (
  set "MESSAGE=Claude Code exited with an error."
  set "DETAIL=Claude Code exit code: %CLAUDE_EXIT_CODE%"
  goto :finish
)

set "EXIT_CODE=0"
set "MESSAGE=Claude Code closed successfully."
set "DETAIL=The strict low-cost profile was used in project directory: %PROJECT_DIR%"
goto :finish

:select_project_directory
echo.
echo Select the project directory to open with Claude Code.
echo Current directory: %CD%
echo.
echo [1] Use the current directory
echo [2] Choose a different project directory
echo.
choice /C 12 /N /M "Select an option [1/2]: "
if errorlevel 2 goto :enter_project_directory
set "PROJECT_DIR=%CD%"
exit /b 0

:enter_project_directory
set "PROJECT_DIR="
echo.
echo Enter the full path of the project directory.
echo You can also drag and drop the project folder into this window.
set /p "PROJECT_DIR=Project directory: "
set "PROJECT_DIR=%PROJECT_DIR:"=%"
if not defined PROJECT_DIR (
  echo.
  echo ERROR: No project directory was entered.
  goto :enter_project_directory
)
if not exist "%PROJECT_DIR%\" (
  echo.
  echo ERROR: The project directory does not exist.
  echo Path: %PROJECT_DIR%
  goto :enter_project_directory
)
exit /b 0

:validate_project_directory
set "PROJECT_DIR=%PROJECT_DIR:"=%"
if not defined PROJECT_DIR (
  set "MESSAGE=No project directory was selected."
  set "DETAIL=Select or enter a valid project directory."
  exit /b 1
)
if not exist "%PROJECT_DIR%\" (
  set "MESSAGE=The project directory does not exist."
  set "DETAIL=Project directory: %PROJECT_DIR%"
  exit /b 1
)
for %%I in ("%PROJECT_DIR%") do set "PROJECT_DIR=%%~fI"
exit /b 0

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
