param(
    [string]$TaskDir = "./tasks/current/task-001"
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $TaskDir)) {
    throw "Task directory not found: $TaskDir"
}

$versionFile = Join-Path $TaskDir 'version.txt'
if (-not (Test-Path $versionFile)) {
    throw "version.txt not found in $TaskDir"
}

$currentVersion = (Get-Content -Path $versionFile -Raw).Trim()
$parts = $currentVersion.Split('.')
if ($parts.Count -ne 3) {
    throw "Version format must be MAJOR.MINOR.PATCH: $currentVersion"
}

$major = [int]$parts[0]
$minor = [int]$parts[1]
$patch = [int]$parts[2]

$newPatch = $patch + 1
$newVersion = "$major.$minor.$newPatch"

$targetLogDir = Join-Path (Join-Path $TaskDir 'logs') $newVersion
New-Item -ItemType Directory -Force -Path $targetLogDir | Out-Null

Set-Content -Path $versionFile -Value "$newVersion`n"

$changeNotePath = Join-Path $targetLogDir 'change-note.md'
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$logText = @"
# Change note

- version: $newVersion
- timestamp: $timestamp
- reason: update task version and create a new execution log
- status: created
"@
Set-Content -Path $changeNotePath -Value $logText

Set-Content -Path (Join-Path $targetLogDir 'run.log') -Value "[$timestamp] version bump to $newVersion`n"

Write-Host "Version updated: $currentVersion -> $newVersion"
Write-Host "New log directory: $targetLogDir"
