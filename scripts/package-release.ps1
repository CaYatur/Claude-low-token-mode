param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^v?\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?$')]
    [string]$Version
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$versionClean = $Version.TrimStart('v')
$dist = Join-Path $repoRoot "dist"
$validator = Join-Path $PSScriptRoot "validate-skill.ps1"

& $validator
if ($LASTEXITCODE -ne 0) { throw "Skill validation failed." }

if (Test-Path -LiteralPath $dist) { Remove-Item -LiteralPath $dist -Recurse -Force }
New-Item -ItemType Directory -Path $dist | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem

function New-SkillZip {
    param(
        [Parameter(Mandatory = $true)][string]$SourceDirectory,
        [Parameter(Mandatory = $true)][string]$DestinationZip,
        [Parameter(Mandatory = $true)][string]$RootFolderName
    )

    $stagingRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("claude-low-token-" + [guid]::NewGuid())
    $stagingFolder = Join-Path $stagingRoot $RootFolderName
    New-Item -ItemType Directory -Path $stagingFolder -Force | Out-Null
    Copy-Item -Path (Join-Path $SourceDirectory '*') -Destination $stagingFolder -Recurse -Force
    [System.IO.Compression.ZipFile]::CreateFromDirectory($stagingRoot, $DestinationZip, [System.IO.Compression.CompressionLevel]::Optimal, $false)
    Remove-Item -LiteralPath $stagingRoot -Recurse -Force
}

$autoSource = Join-Path $repoRoot "skill\automatic\low-token-mode-auto"
$zeroSource = Join-Path $repoRoot "skill\zero-idle\low-token-mode-zero-idle"
$autoZip = Join-Path $dist "claude-low-token-mode-auto-skill-v$versionClean.zip"
$zeroZip = Join-Path $dist "claude-low-token-mode-zero-idle-skill-v$versionClean.zip"
New-SkillZip -SourceDirectory $autoSource -DestinationZip $autoZip -RootFolderName "low-token-mode-auto"
New-SkillZip -SourceDirectory $zeroSource -DestinationZip $zeroZip -RootFolderName "low-token-mode-zero-idle"

$sourceZip = Join-Path $dist "claude-low-token-mode-source-v$versionClean.zip"
$sourceStaging = Join-Path ([System.IO.Path]::GetTempPath()) ("claude-low-token-source-" + [guid]::NewGuid())
$sourceRoot = Join-Path $sourceStaging "claude-low-token-mode-v$versionClean"
New-Item -ItemType Directory -Path $sourceRoot -Force | Out-Null
$excludedNames = @('.git', 'dist')
Get-ChildItem -LiteralPath $repoRoot -Force | Where-Object { $excludedNames -notcontains $_.Name } | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $sourceRoot -Recurse -Force
}
[System.IO.Compression.ZipFile]::CreateFromDirectory($sourceStaging, $sourceZip, [System.IO.Compression.CompressionLevel]::Optimal, $false)
Remove-Item -LiteralPath $sourceStaging -Recurse -Force

Write-Host "Created: $autoZip"
Write-Host "Created: $zeroZip"
Write-Host "Created: $sourceZip"
