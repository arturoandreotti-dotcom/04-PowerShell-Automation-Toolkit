param (
    [string]$LogName = "Application",
    [ValidateRange(1, 1000)]
    [int]$MaxEvents = 10,
    [ValidateRange(1, 5)]
    [int[]]$Level,
    [datetime]$StartTime,
    [datetime]$EndTime,
    [switch]$ExportCsv
)

if (
    $PSBoundParameters.ContainsKey("StartTime") -and
    $PSBoundParameters.ContainsKey("EndTime") -and
    $StartTime -gt $EndTime
) {
    Write-Host "StartTime cannot be later than EndTime"
    return
}

$Filter = @{
    LogName = $LogName
}
if ($PSBoundParameters.ContainsKey("Level")) {
    $Filter["Level"] = $Level
}
if ($PSBoundParameters.ContainsKey("StartTime")) {
    $Filter["StartTime"] = $StartTime
}
if ($PSBoundParameters.ContainsKey("EndTime")) {
    $Filter["EndTime"] = $EndTime
}

try {
    $Events = Get-WinEvent -FilterHashtable $Filter -MaxEvents $MaxEvents -ErrorAction Stop
}
catch {
    if ($_.FullyQualifiedErrorId -eq "NoMatchingEventsFound,Microsoft.PowerShell.Commands.GetWinEventCommand") {
        Write-Host "No events found matching the specified filters."
    }
    else {
        Write-Host "Failed to retrieve events: $($_.Exception.Message)"
    }
    return
}

$Report = $Events | Select-Object TimeCreated, Id, LevelDisplayName, ProviderName

$Report

if ($ExportCsv) {
    $ReportsDirectory = Join-Path $PSScriptRoot "..\reports"
    if (-not (Test-Path -Path $ReportsDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $ReportsDirectory | Out-Null
    }
    $ReportFilePath = Join-Path $ReportsDirectory "EventLog.csv"
    
    $Report | Export-Csv -Path $ReportFilePath
}
