<#
run-all.ps1 - Unified task runner for tasks/ directory

Usage examples:
  # list tasks
  powershell -ExecutionPolicy Bypass -File .\tasks\scripts\run-all.ps1 -Action list

  # run all tasks in order (does not modify code, only appends a run log)
  powershell -ExecutionPolicy Bypass -File .\tasks\scripts\run-all.ps1 -Action run

  # bump versions for specific tasks
  powershell -ExecutionPolicy Bypass -File .\tasks\scripts\run-all.ps1 -Action bump -TaskIds task-002,task-003

  # run and auto-bump then auto-archive when done
  powershell -ExecutionPolicy Bypass -File .\tasks\scripts\run-all.ps1 -Action run -AutoBump -AutoArchive
#>
param(
    [string]$CurrentRoot = "./tasks/current",
    [string]$ArchiveRoot = "./tasks/archive",
    [string[]]$TaskIds = @(),
    [ValidateSet("list","run","bump","archive")] [string]$Action = "list",
    [switch]$AutoBump,
    [switch]$AutoArchive
)

$ErrorActionPreference = 'Stop'

function Read-Manifest($manifestPath){
    if (-not (Test-Path $manifestPath)) { return $null }
    $content = Get-Content -Path $manifestPath -Raw
    return $content
}

function Get-Tasks(){
    if ($TaskIds -and $TaskIds.Count -gt 0) {
        return $TaskIds | ForEach-Object { Get-Item -LiteralPath (Join-Path $CurrentRoot $_) -ErrorAction SilentlyContinue } | Where-Object { $_ }
    }
    return Get-ChildItem -Path $CurrentRoot -Directory | Sort-Object Name
}

function Parse-Order($yaml){
    $m = [regex]::Match($yaml, "(?m)^order:\s*(\d+)")
    if ($m.Success) { return [int]$m.Groups[1].Value }
    return [int]::MaxValue
}

function Bump-Version($taskPath){
    $versionFile = Join-Path $taskPath 'version.txt'
    if (-not (Test-Path $versionFile)) { Write-Host "no version.txt for $taskPath"; return $null }
    $cur = (Get-Content $versionFile -Raw).Trim()
    $parts = $cur.Split('.')
    if ($parts.Count -ne 3) { Write-Host "invalid version format: $cur"; return $null }
    $major = [int]$parts[0]; $minor=[int]$parts[1]; $patch=[int]$parts[2]
    $patch = $patch + 1
    $new = "$major.$minor.$patch"
    $logDir = Join-Path (Join-Path $taskPath 'logs') $new
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null
    Set-Content -Path $versionFile -Value ("$new`n")
    $changeNote = @"
# Change note
- version: $new
- timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
- reason: bumped by run-all.ps1
"@
    Set-Content -Path (Join-Path $logDir 'change-note.md') -Value $changeNote
    Set-Content -Path (Join-Path $logDir 'run.log') -Value ("[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] version bumped to $new`n")
    Write-Host "Bumped $taskPath -> $new"
    return $new
}

function Append-RunLog($taskPath, $message){
    $version = (Get-Content (Join-Path $taskPath 'version.txt') -Raw).Trim()
    $logDir = Join-Path (Join-Path $taskPath 'logs') $version
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Force -Path $logDir | Out-Null }
    $runLog = Join-Path $logDir 'run.log'
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content -Path $runLog -Value "[$ts] $message"
    Write-Host "Appended run log: $taskPath (v$version)"

    # Ensure a global run id exists and write a per-run log copy for centralized tracing
    if (-not $Script:RunId) { $Script:RunId = (Get-Date -Format 'yyyyMMddHHmmss') + '-' + (Get-Random -Maximum 10000) }
    $runsRoot = Join-Path $PSScriptRoot '..\runs'
    $runDir = Join-Path $runsRoot $Script:RunId
    if (-not (Test-Path $runDir)) { New-Item -ItemType Directory -Force -Path $runDir | Out-Null }
    $safeTaskName = ($taskPath -replace '[\\/:]','_')
    $runFile = Join-Path $runDir ("$safeTaskName-v$version-run.log")
    Add-Content -Path $runFile -Value "[$ts] $message"
    Write-Host "Wrote run-level log: $runFile"
}

function Archive-Task($taskPath){
    $taskId = Split-Path $taskPath -Leaf
    $version = (Get-Content (Join-Path $taskPath 'version.txt') -Raw).Trim()
    $dest = Join-Path (Join-Path $ArchiveRoot $taskId) $version
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    # copy whole task into archive version folder
    Copy-Item -Path (Join-Path $taskPath '*') -Destination $dest -Recurse -Force
    # remove original task directory
    Remove-Item -Path $taskPath -Recurse -Force
    Write-Host "Archived $taskId -> $dest"
}

# Main
# create runs directory and run id
$runsRoot = Join-Path $PSScriptRoot '..\runs'
New-Item -ItemType Directory -Force -Path $runsRoot | Out-Null
$Script:RunId = (Get-Date -Format 'yyyyMMddHHmmss') + '-' + (Get-Random -Maximum 10000)
$runMetaDir = Join-Path $runsRoot $Script:RunId
New-Item -ItemType Directory -Force -Path $runMetaDir | Out-Null
$meta = @{
    run_id = $Script:RunId
    action = $Action
    started_at = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
}
$meta | ConvertTo-Json | Set-Content -Path (Join-Path $runMetaDir 'meta.json')

$tasks = Get-Tasks | ForEach-Object {
    $m = Read-Manifest (Join-Path $_.FullName 'manifest.yaml')
    [PSCustomObject]@{ Name = $_.Name; FullName = $_.FullName; Order = Parse-Order($m); Manifest = $m }
} | Sort-Object Order, Name

if ($Action -eq 'list'){
    Write-Host "Tasks (in execution order):" -ForegroundColor Cyan
    $tasks | ForEach-Object { Write-Host "[$($_.Order)] $($_.Name)" }
    return
}

foreach ($t in $tasks){
    $taskPath = $t.FullName
    Write-Host "Processing $($t.Name) (order: $($t.Order))" -ForegroundColor Yellow
    if ($Action -eq 'bump'){
        Bump-Version $taskPath | Out-Null
        continue
    }
    if ($Action -eq 'run'){
        if ($AutoBump) { Bump-Version $taskPath | Out-Null }
        # Guidance for Copilot/human executor
        Write-Host "--- Run Guidance for $($t.Name) ---" -ForegroundColor Green
        Write-Host "1. Read: $($taskPath)\manifest.yaml and $($taskPath)\task.md"
        Write-Host "2. Execute required code changes or tests"
        Write-Host "3. Append execution details to logs/<version>/run.log"
        Write-Host "4. Write summary to logs/<version>/summary.md"
        # Append an automated note to run.log so the run is traceable
        Append-RunLog $taskPath "run-all invoked (Action=run, AutoBump=$AutoBump, AutoArchive=$AutoArchive)"
        if ($AutoArchive) { Archive-Task $taskPath }
        continue
    }
    if ($Action -eq 'archive'){
        Archive-Task $taskPath
        continue
    }
}

Write-Host "Action $Action completed." -ForegroundColor Cyan
