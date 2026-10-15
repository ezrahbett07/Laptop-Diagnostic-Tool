# ============================================================
# LAPTOP PRE-PURCHASE CHECK - One-Line Command
# ============================================================
# Copy this entire block and paste into PowerShell on any laptop
# you're considering buying. It will run all tests and open a report.
# ============================================================

# Download and run the diagnostic tool
$toolUrl = "https://github.com/ezrahbett07/Laptop-Diagnostic-Tool/raw/main/LaptopDiagnosticTool.ps1"
$dbUrl = "https://github.com/ezrahbett07/Laptop-Diagnostic-Tool/raw/main/HardwareDatabase.psm1"
$tempDir = "$env:TEMP\LaptopCheck"

Write-Host "`n  Downloading Diagnostic Tool..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

try {
    Invoke-WebRequest -Uri $toolUrl -OutFile "$tempDir\LaptopDiagnosticTool.ps1" -UseBasicParsing
    Invoke-WebRequest -Uri $dbUrl -OutFile "$tempDir\HardwareDatabase.psm1" -UseBasicParsing
    
    Write-Host "  Running Diagnostic..." -ForegroundColor Green
    & "$tempDir\LaptopDiagnosticTool.ps1" -QuickTest
    
} catch {
    Write-Host "  Download failed. Running offline version..." -ForegroundColor Yellow
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`n  Please copy LaptopDiagnosticTool.ps1 and HardwareDatabase.psm1 to this device manually." -ForegroundColor Yellow
}
