# ============================================================
# LAPTOP CHECK - Quick Diagnostic Command
# Run on any Windows laptop before buying
# ============================================================

param(
    [switch]$Stress,
    [switch]$Quick
)

$baseUrl = "https://raw.githubusercontent.com/ezrahbett07/Laptop-Diagnostic-Tool/main"
$tempDir = "$env:TEMP\LaptopCheck"

# Banner
Write-Host ""
Write-Host "  ========================================" -ForegroundColor Cyan
Write-Host "     LAPTOP CHECK - Hardware Diagnostic    " -ForegroundColor Cyan
Write-Host "  ========================================" -ForegroundColor Cyan
Write-Host ""

# Create temp directory
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Download tool
Write-Host "  [1/3] Downloading diagnostic tool..." -ForegroundColor Yellow

try {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri "$baseUrl/LaptopDiagnosticTool.ps1" -OutFile "$tempDir\LaptopDiagnosticTool.ps1" -UseBasicParsing -TimeoutSec 30
    Invoke-WebRequest -Uri "$baseUrl/HardwareDatabase.psm1" -OutFile "$tempDir\HardwareDatabase.psm1" -UseBasicParsing -TimeoutSec 30
    Write-Host "         OK - Files downloaded" -ForegroundColor Green
} catch {
    Write-Host "         FAILED - $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Check your internet connection and try again." -ForegroundColor Yellow
    return
}

# Verify download
if (-not (Test-Path "$tempDir\LaptopDiagnosticTool.ps1")) {
    Write-Host "         ERROR - Download incomplete" -ForegroundColor Red
    return
}

# Run diagnostic
Write-Host ""
Write-Host "  [2/3] Running diagnostic tests..." -ForegroundColor Yellow
Write-Host ""

$arguments = @()
if ($Stress) { 
    $arguments += "-StressTest"
    Write-Host "  Mode: Full stress test (30 sec CPU test)" -ForegroundColor Cyan
} else {
    $arguments += "-QuickTest"
    Write-Host "  Mode: Quick test" -ForegroundColor Cyan
}
Write-Host ""

& "$tempDir\LaptopDiagnosticTool.ps1" @arguments

# Cleanup
Write-Host ""
Write-Host "  [3/3] Cleaning up..." -ForegroundColor Yellow
Start-Sleep -Seconds 1
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "  ========================================" -ForegroundColor Green
Write-Host "     DONE! Check your browser for report  " -ForegroundColor Green
Write-Host "  ========================================" -ForegroundColor Green
Write-Host ""
