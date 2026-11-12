<#
.SYNOPSIS
    Retrieves disk space information for local fixed drives.

.DESCRIPTION
    Queries Windows logical disks using CIM and filters for fixed drives.

    Displays the drive letter, total capacity, available free space,
    and percentage of disk space used.

    Disk capacities are converted from bytes to GiB and rounded
    to two decimal places.

.EXAMPLE
    .\Get-DiskSpaceReport.ps1

    Displays disk space information for all local fixed drives.

.PARAMETER WarningThreshold
    Specifies the disk usage percentage at which a warning is triggered.
    Accepts an integer value. Defaults to 80.
#>

param(
    [ValidateRange(1, 100)]
    [int]$WarningThreshold = 80
)

Get-CimInstance Win32_LogicalDisk |
Where-Object DriveType -eq 3 |
ForEach-Object {
    if ($null -eq $_.Size -or $_.Size -le 0) {
        Write-Error "Invalid disk size detected on drive $($_.DeviceID)"
    }

    $_
} |
Select-Object DeviceID, @{
    Name       = "SizeGiB"
    Expression = {
        [math]::Round($_.Size / 1GB, 2)
    }
}, @{
    Name       = "FreeSpaceGiB"
    Expression = {
        [math]::Round($_.FreeSpace / 1GB, 2)
    }
}, @{
    Name       = "UsedPercent"
    Expression = {
        if ($null -eq $_.Size -or $_.Size -le 0) {
            $null
        }
        else {
            [math]::Round((($_.Size - $_.FreeSpace) / $_.Size) * 100, 2)
        }
    }
}, @{
    Name       = "Status"
    Expression = {
        if ($null -eq $_.Size -or $_.Size -le 0) {
            "UNKNOWN"
        }
        elseif (((($_.Size - $_.FreeSpace) / $_.Size) * 100) -ge $WarningThreshold) {
            "WARNING"
        }
        else {
            "OK"
        }
    }
}
