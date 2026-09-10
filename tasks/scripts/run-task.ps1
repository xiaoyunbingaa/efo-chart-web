param(
    [string]$CurrentRoot = "./tasks/current"
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $CurrentRoot)) {
    throw "Task root not found: $CurrentRoot"
}

$taskDirs = Get-ChildItem -Path $CurrentRoot -Directory | Sort-Object Name

if ($taskDirs.Count -eq 0) {
    Write-Host "No tasks found under $CurrentRoot"
    return
}

Write-Host "Sequential task order:"

foreach ($task in $taskDirs) {
    $manifest = Join-Path $task.FullName 'manifest.yaml'
    if (-not (Test-Path $manifest)) {
        Write-Host "[$($task.Name)] missing manifest.yaml"
        continue
    }

    $yaml = Get-Content -Path $manifest -Raw
    $orderMatch = [regex]::Match($yaml, "(?m)^order:\s*(\d+)")
    $order = if ($orderMatch.Success) { $orderMatch.Groups[1].Value } else { 'unknown' }

    Write-Host "[$order] $($task.Name)"
}

Write-Host ""
Write-Host "Copilot execution guidance:"
Write-Host "1. Open Copilot Chat"
Write-Host "2. Read the manifest.yaml and task.md in the first task directory"
Write-Host "3. Execute the task in order"
Write-Host "4. Write logs to logs/<version>/run.log and summary.md"
Write-Host "5. If task is complete, move it to tasks/archive"
