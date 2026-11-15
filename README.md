# PowerShell Automation Toolkit

A collection of reusable PowerShell scripts for automating Windows system administration, monitoring system health, and generating structured reports.

## Overview

This project demonstrates practical PowerShell scripting for common IT infrastructure monitoring tasks.

The toolkit provides individual scripts for monitoring disk space, Windows services, event logs, and running processes. It also includes a centralized system health summary that combines these tools into a single workflow.

The project emphasizes parameterized scripts, input validation, error handling, code reuse, and professional Git and GitHub development practices.

## Objectives

- Automate routine Windows system monitoring tasks.
- Develop reusable and parameterized PowerShell scripts.
- Implement input validation and error handling where appropriate.
- Generate structured reports using PowerShell objects.
- Export monitoring results to CSV files.
- Reuse existing scripts without duplicating functionality.
- Follow a professional Git workflow using feature branches, commits, and pull requests.

## Technologies

- Windows 11
- PowerShell 7
- Visual Studio Code
- Git and GitHub
- Windows Management Instrumentation (WMI/CIM)
- Windows Event Logs

## Repository Structure

```text
04-PowerShell-Automation-Toolkit/
├── scripts/
│   ├── Get-DiskSpaceReport.ps1
│   ├── Get-ServiceHealthReport.ps1
│   ├── Get-EventLogReport.ps1
│   ├── Get-ProcessReport.ps1
│   └── Get-SystemHealthSummary.ps1
├── reports/
├── functions/
├── tests/
├── docs/
├── .gitignore
└── README.md
```

The `scripts/` directory contains the monitoring tools.

The `reports/` directory stores generated CSV reports and is excluded from Git tracking through `.gitignore`.

The `functions/`, `tests/`, and `docs/` directories are reserved for future development. No automated test suite or shared function library has been implemented.

## Monitoring Tools

| Script | Purpose | CSV Export |
|---|---|---|
| `Get-DiskSpaceReport.ps1` | Monitor local disk utilization | No |
| `Get-ServiceHealthReport.ps1` | Check Windows service health | Yes |
| `Get-EventLogReport.ps1` | Retrieve and filter Windows events | Yes |
| `Get-ProcessReport.ps1` | Identify processes using the most memory | Yes |
| `Get-SystemHealthSummary.ps1` | Combine monitoring tools into one report | No |

## 1. Disk Space Monitoring

**Script:** `Get-DiskSpaceReport.ps1`

Retrieves information about local fixed drives and evaluates disk utilization against a configurable warning threshold.

### Features

- Retrieves disk information using CIM.
- Displays total capacity and free space in GiB.
- Calculates disk utilization percentages.
- Supports a configurable warning threshold.
- Validates threshold values between 1 and 100.
- Classifies drives as `OK`, `WARNING`, or `UNKNOWN`.

### Usage

Run with the default warning threshold of 80%:

```powershell
.\scripts\Get-DiskSpaceReport.ps1
```

Set a custom threshold:

```powershell
.\scripts\Get-DiskSpaceReport.ps1 -WarningThreshold 90
```

Display only drives classified as warnings:

```powershell
.\scripts\Get-DiskSpaceReport.ps1 |
    Where-Object Status -eq "WARNING"
```

### Status Classification

| Status | Meaning |
|---|---|
| `OK` | Disk utilization is below the warning threshold. |
| `WARNING` | Disk utilization meets or exceeds the threshold. |
| `UNKNOWN` | Disk capacity information is missing or invalid. |

## 2. Service Health Monitoring

**Script:** `Get-ServiceHealthReport.ps1`

Retrieves Windows services and evaluates their health based on startup configuration and current status.

### Features

- Monitors all services or selected services.
- Identifies stopped services configured for automatic startup.
- Supports optional summary statistics.
- Exports structured results to CSV.
- Creates the reports directory when necessary.

### Usage

Check all services:

```powershell
.\scripts\Get-ServiceHealthReport.ps1
```

Check specific services:

```powershell
.\scripts\Get-ServiceHealthReport.ps1 -ServiceName Spooler,Winmgmt,EventLog
```

Display summary statistics:

```powershell
.\scripts\Get-ServiceHealthReport.ps1 -ShowSummary
```

Export results:

```powershell
.\scripts\Get-ServiceHealthReport.ps1 -ExportCsv
```

Combine parameters:

```powershell
.\scripts\Get-ServiceHealthReport.ps1 -ServiceName Spooler,Winmgmt,EventLog -ShowSummary -ExportCsv
```

**CSV output:** `reports/ServiceHealth.csv`

A `WARNING` indicates that a service configured for automatic startup is stopped. This does not necessarily indicate a system failure.

## 3. Event Log Reporting

**Script:** `Get-EventLogReport.ps1`

Retrieves Windows event log entries using configurable filters.

### Features

- Selects a Windows event log.
- Limits the number of returned events.
- Filters events by severity level.
- Supports start and end time filtering.
- Validates event limits and severity levels.
- Uses error handling for event retrieval.
- Exports results to CSV.

### Parameters

| Parameter | Description | Default |
|---|---|---|
| `-LogName` | Windows event log to query | `Application` |
| `-MaxEvents` | Maximum number of events to retrieve (1–1000) | `10` |
| `-Level` | Optional event severity filter (1–5) | Not specified |
| `-StartTime` | Optional start of the time range | Not specified |
| `-EndTime` | Optional end of the time range | Not specified |
| `-ExportCsv` | Export results to CSV | Disabled |

### Usage

Retrieve recent Application events:

```powershell
.\scripts\Get-EventLogReport.ps1
```

Retrieve five recent System events:

```powershell
.\scripts\Get-EventLogReport.ps1 -LogName System -MaxEvents 5
```

Retrieve error events:

```powershell
.\scripts\Get-EventLogReport.ps1 -Level 2
```

Filter events by date:

```powershell
.\scripts\Get-EventLogReport.ps1 -StartTime (Get-Date).AddDays(-1)
```

Export events to CSV:

```powershell
.\scripts\Get-EventLogReport.ps1 -ExportCsv
```

**CSV output:** `reports/EventLog.csv`

The report includes event timestamps, event IDs, severity descriptions, and event providers.

## 4. Process Monitoring

**Script:** `Get-ProcessReport.ps1`

Identifies running processes consuming the most physical memory.

### Features

- Retrieves running processes using `Get-Process`.
- Sorts processes by memory consumption.
- Converts memory usage from bytes to MiB.
- Supports a configurable number of results.
- Validates the requested result count.
- Exports results to CSV.

### Usage

Display the ten processes consuming the most memory:

```powershell
.\scripts\Get-ProcessReport.ps1
```

Display the top five processes:

```powershell
.\scripts\Get-ProcessReport.ps1 -First 5
```

Export the results:

```powershell
.\scripts\Get-ProcessReport.ps1 -First 5 -ExportCsv
```

**CSV output:** `reports/Processes.csv`

### Report Properties

| Property | Description |
|---|---|
| `ProcessName` | Name of the running process |
| `Id` | Process identifier |
| `MemoryMiB` | Physical memory usage in MiB |

## 5. System Health Summary

**Script:** `Get-SystemHealthSummary.ps1`

Combines the four monitoring scripts into a centralized system health overview.

Instead of duplicating their functionality, the script executes existing tools using the PowerShell call operator (`&`), `Join-Path`, and `$PSScriptRoot`.

### Features

- Displays local disk utilization.
- Checks the health of selected Windows services.
- Retrieves five recent Application event log entries.
- Displays the five processes consuming the most memory.
- Organizes output into clearly labeled sections.
- Demonstrates script orchestration and code reuse.

### Usage

```powershell
.\scripts\Get-SystemHealthSummary.ps1
```

### Report Sections

```text
========== DISK SPACE ==========

========== SERVICE HEALTH ==========

========== EVENT LOGS ==========

========== TOP PROCESSES ==========
```

The summary provides a convenient way to run multiple monitoring checks from a single command.

## CSV Reporting

Scripts that support CSV export save their results in the `reports/` directory.

| Script | Output File |
|---|---|
| Service Health Monitoring | `ServiceHealth.csv` |
| Event Log Reporting | `EventLog.csv` |
| Process Monitoring | `Processes.csv` |

CSV files can be inspected directly in PowerShell.

Example:

```powershell
Import-Csv .\reports\ServiceHealth.csv
```

Generated reports are excluded from version control to keep the repository focused on source code and documentation.

## Testing and Validation

The scripts were tested manually in a Windows 11 environment using PowerShell 7.

Testing included:

- Running scripts with default parameters.
- Testing custom parameter values.
- Checking input validation with invalid values.
- Verifying service health classifications.
- Retrieving Windows event log entries.
- Confirming process sorting and memory calculations.
- Exporting reports and inspecting them with `Import-Csv`.
- Executing all monitoring scripts through the system health summary.

Automated Pester tests have not been implemented.

## Skills Demonstrated

- PowerShell scripting and parameter handling.
- Working with Windows services, processes, and event logs.
- System information retrieval using CIM.
- PowerShell pipelines and object manipulation.
- Calculated properties and data formatting.
- Input validation and error handling.
- CSV reporting and filesystem operations.
- Script orchestration and code reuse.
- Git branching, commits, pull requests, and merges.
- Technical documentation.

## Project Status

**Completed — Labs 0–5**

| Lab | Description | Status |
|---|---|---|
| Lab 0 | Repository Setup | Completed |
| Lab 1 | Disk Space Monitoring | Completed |
| Lab 2 | Service Health Monitoring | Completed |
| Lab 3 | Event Log Reporting | Completed |
| Lab 4 | Process Monitoring | Completed |
| Lab 5 | System Health Summary | Completed |

All planned labs in the finalized project scope have been implemented and manually tested.

---

This repository is part of a **10-project IT Infrastructure and Cloud portfolio**, documenting a practical learning path from IT Support and System Administration toward Cloud Engineering and DevOps.
