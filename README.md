
# PowerShell Automation Toolkit

## Overview

A collection of reusable PowerShell scripts designed to automate common Windows system administration tasks.

This project focuses on developing reliable, maintainable, and safe automation tools for real-world IT infrastructure environments.

## Objectives

- Automate routine Windows administration tasks.
- Develop reusable and parameterized PowerShell scripts.
- Implement input validation, error handling, and logging.
- Generate structured reports for system monitoring.
- Apply safe automation practices and automated testing.
- Follow professional Git and GitHub development workflows.

## Repository Structure

| Directory | Purpose |
|-----------|---------|
| `scripts/` | PowerShell scripts for administrative automation. |
| `reports/` | Generated CSV reports from monitoring scripts. |
| `functions/` | Reusable PowerShell functions shared across scripts. |
| `tests/` | Automated tests for validating script behavior. |
| `docs/` | Documentation, usage examples, and testing procedures. |

## Planned Automation Tools

1. Disk Space Monitoring
2. Windows Service Health Checks
3. Event Log Reporting
4. Safe File Archiving
5. Reusable Logging and Error Handling
6. Scheduled Monitoring and Reporting

## Disk Space Monitoring

The `Get-DiskSpaceReport.ps1` script monitors disk usage on local fixed drives and identifies drives approaching their configured usage threshold.

### Features

- Retrieve disk information using CIM.
- Display total capacity and available space in GiB.
- Calculate disk usage percentages.
- Classify drives as `OK`, `WARNING`, or `UNKNOWN`.
- Configure the warning threshold (default: 80%).
- Validate the warning threshold to accept values from 1 to 100.

### Usage

Check disk usage with the default warning threshold:

```powershell
.\scripts\Get-DiskSpaceReport.ps1
```

Set a custom warning threshold of 90%:

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
| `OK` | Disk usage is below the warning threshold. |
| `WARNING` | Disk usage is equal to or above the warning threshold. |
| `UNKNOWN` | Disk size information is missing or invalid. |

## Service Health Monitoring

The `Get-ServiceHealthReport.ps1` script checks Windows services and generates a structured health report.

### Features

- Monitor all services or select specific services.
- Classify stopped services configured for automatic startup as `WARNING`.
- Display optional summary statistics.
- Export results to CSV.
- Automatically create the reports directory when necessary.

### Usage

Check all services:

```powershell
.\scripts\Get-ServiceHealthReport.ps1
```

Check specific services:

```powershell
.\scripts\Get-ServiceHealthReport.ps1 -ServiceName Spooler,WinRM
```

Display summary statistics:

```powershell
.\scripts\Get-ServiceHealthReport.ps1 -ShowSummary
```

Export results to CSV:

```powershell
.\scripts\Get-ServiceHealthReport.ps1 -ExportCsv
```

Filter warning services:

```powershell
.\scripts\Get-ServiceHealthReport.ps1 |
    Where-Object Health -eq "WARNING"
```

**Note:** A `WARNING` indicates that a service configured for automatic startup is stopped. This does not necessarily indicate a failure.

## Technologies

- PowerShell 7
- Windows 11
- Visual Studio Code
- Git and GitHub
- Windows Task Scheduler
- Pester (PowerShell testing framework)

## Project Status

**In Progress — Labs 0–2 Completed**

### Completed Labs

- **Lab 0 — Repository Setup:** Initialized the project structure and Git workflow.
- **Lab 1 — Disk Space Monitoring:** Developed a parameterized disk space reporting script.
- **Lab 2 — Service Health Monitoring:** Developed a script to inspect Windows services, classify their health, display optional summaries, and export CSV reports.

### Upcoming Labs

- Event Log Reporting
- Safe File Archiving
- Reusable Logging and Error Handling
- Scheduled Monitoring and Reporting

This repository is part of a 10-project IT Infrastructure and Cloud portfolio focused on progressing from IT Support to System Administration, Cloud Engineering, and DevOps.
