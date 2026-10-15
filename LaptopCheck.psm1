# LAPTOP CHECK - Custom Command
# Run this on ANY Windows laptop to diagnose hardware before buying

function Invoke-LaptopCheck {
    [CmdletBinding()]
    param(
        [switch]$Stress,
        [switch]$Quick
    )
    
    $baseUrl = "https://raw.githubusercontent.com/ezrahbett07/Laptop-Diagnostic-Tool/main"
    $tempDir = "$env:TEMP\LaptopCheck_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    
    Write-Host ""
    Write-Host "  +========================================+" -ForegroundColor Cyan
    Write-Host "  |   LAPTOP CHECK - Quick Diagnostic      |" -ForegroundColor Cyan
    Write-Host "  +========================================+" -ForegroundColor Cyan
    Write-Host ""
    
    # Create temp directory
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    
    # Download tool files
    Write-Host "  Downloading diagnostic tool..." -ForegroundColor Yellow
    
    try {
        Invoke-WebRequest -Uri "$baseUrl/LaptopDiagnosticTool.ps1" -OutFile "$tempDir\LaptopDiagnosticTool.ps1" -UseBasicParsing
        Invoke-WebRequest -Uri "$baseUrl/HardwareDatabase.psm1" -OutFile "$tempDir\HardwareDatabase.psm1" -UseBasicParsing
        Write-Host "  Download complete!" -ForegroundColor Green
    } catch {
        Write-Host "  Download failed: $($_.Exception.Message)" -ForegroundColor Red
        return
    }
    
    # Run the tool
    Write-Host ""
    Write-Host "  Running diagnostic..." -ForegroundColor Yellow
    Write-Host ""
    
    $arguments = @()
    if ($Stress) { $arguments += "-StressTest" }
    elseif ($Quick) { $arguments += "-QuickTest" }
    else { $arguments += "-QuickTest" }
    
    & "$tempDir\LaptopDiagnosticTool.ps1" @arguments
    
    # Cleanup
    Start-Sleep -Seconds 2
    Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}

# Export function
Export-ModuleMember -Function Invoke-LaptopCheck -ErrorAction SilentlyContinue
