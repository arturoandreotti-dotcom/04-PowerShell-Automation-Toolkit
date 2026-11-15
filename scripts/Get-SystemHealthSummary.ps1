Write-Host "`n========== DISK SPACE =========="
& (Join-Path $PSScriptRoot "Get-DiskSpaceReport.ps1")
Write-Host "`n========== SERVICE HEALTH =========="
& (Join-Path $PSScriptRoot "Get-ServiceHealthReport.ps1") -ServiceName "Spooler", "Winmgmt", "EventLog"
Write-Host "`n========== EVENT LOGS =========="
& (Join-Path $PSScriptRoot "Get-EventLogReport.ps1") -MaxEvents 5
Write-Host "`n========== TOP PROCESSES =========="
& (Join-Path $PSScriptRoot "Get-ProcessReport.ps1") -First 5
