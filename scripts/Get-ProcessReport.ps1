param(
    [ValidateRange(1, 100)]
    [int]$First = 10,
    [switch]$ExportCsv
)

$Report = Get-Process |
Sort-Object WorkingSet64 -Descending |
Select-Object ProcessName, Id, @{
    Name       = "MemoryMiB"
    Expression = {
        [math]::Round($_.WorkingSet64 / 1MB, 2)
    }
} -First $First

$Report

if ($ExportCsv) {
    $ReportsDirectory = Join-Path $PSScriptRoot "..\reports"
    if (-not (Test-Path -Path $ReportsDirectory -PathType Container)) {
        New-Item -ItemType Directory -Path $ReportsDirectory | Out-Null
    }
    $ReportFilePath = Join-Path $ReportsDirectory "Processes.csv"
    $Report | Export-Csv -Path $ReportFilePath
}
