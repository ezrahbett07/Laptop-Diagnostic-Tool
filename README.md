# Laptop Diagnostic Tool

A free, portable PowerShell-based diagnostic tool for testing laptop hardware health before buying.

## Quick One-Liner Command

**Run this on ANY Windows laptop to diagnose hardware:**

```powershell
iex (irm "https://raw.githubusercontent.com/ezrahbett07/Laptop-Diagnostic-Tool/main/QuickCheck.ps1")
```

**For stress test:**

```powershell
iex (irm "https://raw.githubusercontent.com/ezrahbett07/Laptop-Diagnostic-Tool/main/QuickCheck.ps1") -Stress
```

Just copy the command, open PowerShell on any laptop, paste it, and press Enter. The report will open automatically in your browser.

---

## Features

- **System Information** - CPU, RAM, OS, model details
- **CPU Verification** - Checks against database of 50+ known processors
- **RAM Verification** - Part number, speed, capacity validation
- **Storage Verification** - SSD model, health, interface check
- **Battery Diagnostic** - Health %, cycle count, wear level
- **GPU Diagnostic** - Status, VRAM, driver age
- **Network Diagnostic** - Adapter status, WiFi stability
- **Laptop Model Verification** - Checks specs against 80+ known models
- **Health Score** - Overall score 0-100
- **Two-Column Report** - Green (PASS) vs Red/Yellow (Issues)
- **Detailed Explanations** - What each issue means and what to do

## Supported Laptop Models

| Brand | Series |
|-------|--------|
| **HP** | EliteBook 745/840/850 G5-G8 |
| **Dell** | Latitude 5400-5430, 7490 |
| **Lenovo ThinkPad** | X1 Carbon, T14/T16, L14/L15, E14/E15, X13, P series, Z13/Z16 |
| **Lenovo ThinkBook** | 13s, 14, 15, 16 series |
| **Lenovo IdeaPad** | 3, 5, Flex 5 series |
| **Lenovo Yoga** | 7, 7i, 9, 9i, Slim 7 |
| **Lenovo Legion** | 5, 5 Pro, 7, Slim 7 |

## Hardware Database

- **50+ CPUs** verified (AMD Ryzen, Intel Core, etc.)
- **80+ Laptop Models** with expected specs
- **17+ SSDs** (Micron, Samsung, SK Hynix, WD, Intel, Kingston)
- **9+ RAM Modules** (Hynix, Samsung, Crucial, Kingston, ADATA)

## Quick Start Options

### Option 1: One-Liner (Recommended)
```powershell
iex (irm "https://raw.githubusercontent.com/ezrahbett07/Laptop-Diagnostic-Tool/main/QuickCheck.ps1")
```

### Option 2: Double-click
- `Run-Diagnostic-Quick.bat` - Fast test (~1 min)
- `Run-Diagnostic-Full.bat` - Full stress test (~2 min)

### Option 3: PowerShell (Local files)
```powershell
# Quick test
.\LaptopDiagnosticTool.ps1 -QuickTest

# Full stress test
.\LaptopDiagnosticTool.ps1 -StressTest

# Deep scan
.\LaptopDiagnosticTool.ps1 -DeepScan
```

## Output Report

The HTML report shows:
- **Health Score** (0-100) with color coding
- **Left Column (Green)** - All passing tests
- **Right Column (Red/Yellow)** - Issues with detailed explanations:
  - What the issue means
  - How it affects daily use
  - What to do about it (with cost estimates)

## Requirements

- Windows 10/11
- PowerShell 5.1+ (built into Windows)
- Internet connection (for one-liner command)
- Run as Administrator for full results

## Use Case

Perfect for checking refurbished/used laptops before purchase:
- Verify CPU matches advertised specs
- Check battery health before buying
- Detect fake or mismatched hardware
- Find WiFi, RAM, or storage issues
- Get a fair price by knowing the real condition

## File Structure

```
Laptop-Diagnostic-Tool/
├── LaptopDiagnosticTool.ps1    # Main diagnostic tool
├── HardwareDatabase.psm1       # CPU/Laptop/Storage database
├── QuickCheck.ps1              # One-liner downloader
├── Run-Diagnostic-Quick.bat    # Quick test launcher
├── Run-Diagnostic-Full.bat     # Stress test launcher
├── Command.txt                 # Copy-paste commands
└── README.md                   # This file
```

## License

Free to use and modify.
