param(
    [string[]]$SkillFiles = @()
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot

if ($SkillFiles.Count -eq 0) {
    $SkillFiles = @(
        (Join-Path $repoRoot "skill\automatic\low-token-mode-auto\SKILL.md"),
        (Join-Path $repoRoot "skill\zero-idle\low-token-mode-zero-idle\SKILL.md")
    )
}

foreach ($SkillFile in $SkillFiles) {
    if (-not (Test-Path -LiteralPath $SkillFile -PathType Leaf)) {
        throw "SKILL.md not found: $SkillFile"
    }

    $text = Get-Content -LiteralPath $SkillFile -Raw -Encoding UTF8
    if (-not $text.StartsWith("---")) { throw "SKILL.md must start with YAML frontmatter: $SkillFile" }

    $parts = $text -split "(?m)^---\s*$", 3
    if ($parts.Count -lt 3) { throw "SKILL.md frontmatter is not closed: $SkillFile" }

    $frontmatter = $parts[1]
    $nameMatch = [regex]::Match($frontmatter, "(?m)^name:\s*(.+?)\s*$")
    $descriptionMatch = [regex]::Match($frontmatter, "(?m)^description:\s*(.+?)\s*$")
    if (-not $nameMatch.Success) { throw "Missing required name field: $SkillFile" }
    if (-not $descriptionMatch.Success) { throw "Missing required description field: $SkillFile" }

    $name = $nameMatch.Groups[1].Value.Trim(' ', '"', "'")
    $description = $descriptionMatch.Groups[1].Value.Trim(' ', '"', "'")

    if ($name.Length -gt 64) { throw "Skill name exceeds 64 characters: $($name.Length) in $SkillFile" }
    if ($description.Length -gt 200) { throw "Skill description exceeds 200 characters: $($description.Length) in $SkillFile" }
    if ($text -notmatch "(?i)Basic Cheap Mode") { throw "Basic Cheap Mode section is missing: $SkillFile" }
    if ($text -notmatch "(?i)Advanced Cheap Mode") { throw "Advanced Cheap Mode section is missing: $SkillFile" }
    if ($text -notmatch "(?i)Language invariant") { throw "Language invariant section is missing: $SkillFile" }
    if ($text -notmatch "(?i)Tool-call minimization") { throw "Tool-call minimization section is missing: $SkillFile" }

    if ($name -eq "low-token-mode-zero-idle" -and $frontmatter -notmatch "(?m)^disable-model-invocation:\s*true\s*$") {
        throw "Zero-Idle edition must set disable-model-invocation: true."
    }
    if ($name -eq "low-token-mode-auto" -and $frontmatter -match "(?m)^disable-model-invocation:\s*true\s*$") {
        throw "Automatic edition must remain model-invocable."
    }

    Write-Host "Valid: $name"
    Write-Host "Name length: $($name.Length)"
    Write-Host "Description length: $($description.Length)"
}
