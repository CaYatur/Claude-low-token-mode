@echo off
setlocal EnableExtensions
cd /d "%~dp0.."

set "VERSION=%~1"
if not defined VERSION set "VERSION=1.0.0"

where powershell >nul 2>&1
if errorlevel 1 (
  echo ERROR: PowerShell was not found.
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%CD%\scripts\package-release.ps1" -Version "%VERSION%"
exit /b %ERRORLEVEL%
