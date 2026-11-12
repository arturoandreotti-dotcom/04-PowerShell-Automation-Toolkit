<#
.SYNOPSIS
    Generates a health report for Windows services.

.DESCRIPTION
    Retrieves Windows services and evaluates their status.

    Services configured for automatic startup that are currently
    stopped are classified as WARNING. All other services are
    classified as OK.

    Supports optional summary statistics and CSV export.

.PARAMETER ServiceName
    Specifies one or more services to monitor.
    If omitted, all services are checked.

.PARAMETER ShowSummary
    Displays the total number of services checked and the
    number of services classified as WARNING.

.PARAMETER ExportCsv
    Exports the service health report to
    reports/ServiceHealth.csv.

.EXAMPLE
    .\Get-ServiceHealthReport.ps1

    Checks all Windows services.

.EXAMPLE
    .\Get-ServiceHealthReport.ps1 -ServiceName Spooler,WinRM

    Checks the specified services.

.EXAMPLE
    .\Get-ServiceHealthReport.ps1 -ShowSummary -ExportCsv

    Displays summary statistics and exports the report.
#>

param(
    [string[]]$ServiceName,
    [switch]$ShowSummary,
    [switch]$ExportCsv
)

function Get-ServiceHealth {
    param(
        # Parameter can select a specific service
        [String[]]$ServiceName
    )


    if ($ServiceName.Count -eq 0) {
        $Services = Get-Service
    }
    else {
        $Services = Get-Service -Name $ServiceName 
    }

    $Services |
    Select-Object Name, StartType, Status, @{
        Name       = "Health"
        Expression = {
            if ( $_.StartType -eq "Automatic" -and $_.Status -eq "Stopped" ) {
                "WARNING"
            }
            else {
                "OK"           
            }
        }
    }
}

$Report = Get-ServiceHealth -ServiceName $ServiceName

$Warnings = $Report |
Where-Object {
    $_.Health -eq "WARNING"
}

$Report

$WarningCount = $Warnings.Count
$ReportCount = $Report.Count

if ( $ShowSummary -eq $true ) {
    Write-Host "Total services checked: $ReportCount"
    Write-Host "Services with warnings: $WarningCount"
}

if ( $ExportCsv ) {
    $ReportsPath = Join-Path $PSScriptRoot "..\reports"
    $CsvPath = Join-Path $ReportsPath "ServiceHealth.csv"
    if ( (Test-Path $ReportsPath) -eq $false) {
        New-Item -ItemType Directory -Path $ReportsPath | Out-Null
    }
    $Report | Export-Csv -Path $CsvPath -NoTypeInformation
}
