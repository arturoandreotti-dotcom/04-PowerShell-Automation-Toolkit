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
