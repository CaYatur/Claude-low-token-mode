@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0.."

set "VERSION=%~1"
if not defined VERSION set /p "VERSION=Version (example 1.0.0): "
if not defined VERSION (echo ERROR: A version is required.& exit /b 1)
if /I "%VERSION:~0,1%"=="v" set "VERSION=%VERSION:~1%"

where powershell >nul 2>&1
if errorlevel 1 (echo ERROR: PowerShell was not found.& exit /b 1)
where gh >nul 2>&1
if errorlevel 1 (echo ERROR: GitHub CLI was not found. Install gh and run: gh auth login& exit /b 1)
gh auth status >nul 2>&1
if errorlevel 1 (echo ERROR: GitHub CLI is not authenticated. Run: gh auth login& exit /b 1)

powershell -NoProfile -ExecutionPolicy Bypass -File "%CD%\scripts\package-release.ps1" -Version "%VERSION%"
if errorlevel 1 exit /b 1

set "AUTO_ZIP=%CD%\dist\claude-low-token-mode-auto-skill-v%VERSION%.zip"
set "ZERO_ZIP=%CD%\dist\claude-low-token-mode-zero-idle-skill-v%VERSION%.zip"
set "SOURCE_ZIP=%CD%\dist\claude-low-token-mode-source-v%VERSION%.zip"
set "TAG=v%VERSION%"

for /f "usebackq delims=" %%R in (`gh repo view --json nameWithOwner -q .nameWithOwner 2^>nul`) do set "REPO=%%R"
if not defined REPO (echo ERROR: Could not detect the GitHub repository. Ensure this folder has a GitHub remote.& exit /b 1)

gh release view "%TAG%" --repo "%REPO%" >nul 2>&1
if errorlevel 1 (
  gh release create "%TAG%" "%AUTO_ZIP%" "%ZERO_ZIP%" "%SOURCE_ZIP%" --repo "%REPO%" --title "%TAG%" --generate-notes
) else (
  gh release upload "%TAG%" "%AUTO_ZIP%" "%ZERO_ZIP%" "%SOURCE_ZIP%" --repo "%REPO%" --clobber
)
if errorlevel 1 (echo ERROR: GitHub release upload failed.& exit /b 1)
echo Released %TAG% to %REPO%.
