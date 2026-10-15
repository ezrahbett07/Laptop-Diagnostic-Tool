# Laptop Diagnostic Tool

A free, portable PowerShell-based diagnostic tool for testing laptop hardware health before buying.

## Features

- **System Information** - CPU, RAM, OS, model details
- **CPU Diagnostic** - Load, clock speed, optional stress test
- **RAM Diagnostic** - Size, speed, errors, available memory
- **Storage Diagnostic** - SSD health, write speed, disk space
- **Battery Diagnostic** - Health %, cycle count, wear level
- **GPU Diagnostic** - Status, VRAM, driver age
- **Network Diagnostic** - Adapter status, WiFi stability
- **System Health** - BSOD events, uptime, Windows license
- **Security Status** - Antivirus, firewall check
- **Health Score** - Overall score 0-100

## Quick Start

### Option 1: Double-click
- `Run-Diagnostic-Quick.bat` - Fast test (~1 min)
- `Run-Diagnostic-Full.bat` - Full stress test (~2 min)

### Option 2: PowerShell
```powershell
# Quick test
.\LaptopDiagnosticTool.ps1 -QuickTest

# Full stress test
.\LaptopDiagnosticTool.ps1 -StressTest
```

## Output

- Console shows Pass/Warn/Fail for each test
- HTML report saved to Desktop with health score

## Requirements

- Windows 10/11
- PowerShell 5.1+
- Run as Administrator for full results

## Use Case

Perfect for checking refurbished/used laptops before purchase:
- Battery degradation
- Storage health
- RAM errors
- WiFi stability
- Overall system health

## License

Free to use and modify.
