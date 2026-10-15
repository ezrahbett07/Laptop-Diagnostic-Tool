#Requires -Version 5.1
<#
.SYNOPSIS
    Laptop Hardware Diagnostic Tool
.DESCRIPTION
    Tests CPU, RAM, SSD, Battery, GPU, Network & generates health report.
.NOTES
    Author: Diagnostic Tool v1.0
    Run as Administrator for full results
#>

param(
    [switch]$StressTest,
    [switch]$QuickTest,
    [string]$OutputPath = "$env:USERPROFILE\Desktop\LaptopReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
)

# ============================================================
# INITIALIZATION
# ============================================================
$ErrorActionPreference = "SilentlyContinue"
$report = @()
$issues = @()
$passes = @()

function Write-Section($title) {
    Write-Host "`n" -NoNewline
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host "  $title" -ForegroundColor Yellow
    Write-Host "=" * 60 -ForegroundColor Cyan
}

function Add-Pass($test, $detail) {
    $script:passes += [PSCustomObject]@{Test=$test; Detail=$detail}
    Write-Host "  [PASS] $test - $detail" -ForegroundColor Green
}

function Add-Warn($test, $detail) {
    $script:issues += [PSCustomObject]@{Test=$test; Detail=$detail; Severity="WARN"}
    Write-Host "  [WARN] $test - $detail" -ForegroundColor Yellow
}

function Add-Fail($test, $detail) {
    $script:issues += [PSCustomObject]@{Test=$test; Detail=$detail; Severity="FAIL"}
    Write-Host "  [FAIL] $test - $detail" -ForegroundColor Red
}

# ============================================================
# ADMIN CHECK
# ============================================================
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "`n  [WARNING] Run as Administrator for complete results!" -ForegroundColor Red
    Write-Host "  Some tests will be skipped.`n" -ForegroundColor Yellow
}

Write-Host @"

    ╔═══════════════════════════════════════════════════╗
    ║     LAPTOP HARDWARE DIAGNOSTIC TOOL v1.0         ║
    ║     Testing System Health & Components           ║
    ╚═══════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

$startTime = Get-Date

# ============================================================
# 1. SYSTEM INFORMATION
# ============================================================
Write-Section "SYSTEM INFORMATION"

$sys = Get-CimInstance -ClassName Win32_ComputerSystem
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$cpu = Get-CimInstance -ClassName Win32_Processor

$systemInfo = [PSCustomObject]@{
    Manufacturer = $sys.Manufacturer
    Model = $sys.Model
    SerialNumber = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber
    OS = $os.Caption
    OSVersion = $os.Version
    OSBuild = $os.BuildNumber
    Architecture = $os.OSArchitecture
    CPU = $cpu.Name
    CPUCores = $cpu.NumberOfCores
    CPULogical = $cpu.NumberOfLogicalProcessors
    MaxClockMHz = $cpu.MaxClockSpeed
    RAM_GB = [math]::Round($sys.TotalPhysicalMemory/1GB, 2)
}

Write-Host "  Manufacturer: $($systemInfo.Manufacturer)"
Write-Host "  Model: $($systemInfo.Model)"
Write-Host "  Serial: $($systemInfo.SerialNumber)"
Write-Host "  OS: $($systemInfo.OS) (Build $($systemInfo.OSBuild))"
Write-Host "  CPU: $($systemInfo.CPU)"
Write-Host "  Cores: $($systemInfo.CPUCores)C / $($systemInfo.CPULogical)T"
Write-Host "  RAM: $($systemInfo.RAM_GB) GB"

$report += $systemInfo

# ============================================================
# 2. CPU TEST
# ============================================================
Write-Section "CPU DIAGNOSTIC"

$cpuLoad = (Get-CimInstance -ClassName Win32_Processor).LoadPercentage
if ($cpuLoad -gt 90) {
    Add-Warn "CPU Load" "High current load: $cpuLoad%"
} else {
    Add-Pass "CPU Load" "Normal: $cpuLoad%"
}

if ($cpu.CurrentClockSpeed -ge ($cpu.MaxClockSpeed * 0.8)) {
    Add-Pass "CPU Clock" "$($cpu.CurrentClockSpeed) MHz (Max: $($cpu.MaxClockSpeed) MHz)"
} else {
    Add-Warn "CPU Clock" "Throttled: $($cpu.CurrentClockSpeed)/$($cpu.MaxClockSpeed) MHz"
}

if ($StressTest) {
    Write-Host "`n  Running 30-second CPU stress test..." -ForegroundColor Cyan
    $jobs = @()
    1..[Environment]::ProcessorCount | ForEach-Object {
        $jobs += Start-Job -ScriptBlock {
            $end = (Get-Date).AddSeconds(30)
            while((Get-Date) -lt $end) {
                $result = 1
                for($i=1; $i -lt 1000000; $i++) { $result = $result * $i / $i }
            }
        }
    }
    $jobs | Wait-Job | Out-Null
    $jobs | Remove-Job -Force
    Add-Pass "CPU Stress" "30s stress test - No crashes"
}

# ============================================================
# 3. RAM DIAGNOSTIC
# ============================================================
Write-Section "MEMORY (RAM) DIAGNOSTIC"

$ram = Get-CimInstance -ClassName Win32_PhysicalMemory
$ramInfo = @()
foreach ($stick in $ram) {
    $ramInfo += [PSCustomObject]@{
        Bank = $stick.BankLabel
        SizeGB = [math]::Round($stick.Capacity/1GB, 2)
        SpeedMHz = $stick.Speed
        Manufacturer = $stick.Manufacturer
        PartNumber = $stick.PartNumber.Trim()
    }
    Write-Host "  $($stick.BankLabel): $([math]::Round($stick.Capacity/1GB,2)) GB $($stick.Speed) MHz ($($stick.Manufacturer))"
}

$mem = Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Memory
$availableMB = $mem.AvailableMBytes
$totalMB = [math]::Round($sys.TotalPhysicalMemory/1MB)
$usedPercent = [math]::Round((($totalMB - $availableMB) / $totalMB) * 100)

if ($availableMB -gt 1024) {
    Add-Pass "Available RAM" "$availableMB MB free ($usedPercent% used)"
} else {
    Add-Warn "Available RAM" "Low: Only $availableMB MB free"
}

# Check pagefile
$pagefile = Get-CimInstance -ClassName Win32_PageFileUsage
if ($pagefile) {
    Add-Pass "Pagefile" "$($pagefile.AllocatedBaseSize) MB allocated"
}

# Memory test (quick - checks for obvious errors via event log)
$memErrors = Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-MemoryDiagnostics-Results'} -MaxEvents 5 -ErrorAction SilentlyContinue
if ($memErrors) {
    Add-Fail "Memory Errors" "Memory diagnostics errors found in event log"
} else {
    Add-Pass "Memory Errors" "No memory errors in event log"
}

# ============================================================
# 4. STORAGE (SSD/HDD) DIAGNOSTIC
# ============================================================
Write-Section "STORAGE DIAGNOSTIC"

$disks = Get-PhysicalDisk
foreach ($disk in $disks) {
    $sizeGB = [math]::Round($disk.Size/1GB, 2)
    Write-Host "  Disk: $($disk.FriendlyName)"
    Write-Host "  Type: $($disk.MediaType) | Bus: $($disk.BusType) | Size: $sizeGB GB"
    
    if ($disk.HealthStatus -eq "Healthy") {
        Add-Pass "Disk Health" "$($disk.FriendlyName) - Healthy"
    } else {
        Add-Fail "Disk Health" "$($disk.FriendlyName) - $($disk.HealthStatus)"
    }
    
    if ($disk.BusType -eq "NVMe") {
        Add-Pass "Disk Interface" "NVMe (Fast)"
    } elseif ($disk.BusType -eq "SATA") {
        Add-Pass "Disk Interface" "SATA"
    } else {
        Add-Warn "Disk Interface" "$($disk.BusType)"
    }
}

# Disk space check
$logicalDisks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
foreach ($drive in $logicalDisks) {
    $sizeGB = [math]::Round($drive.Size/1GB, 2)
    $freeGB = [math]::Round($drive.FreeSpace/1GB, 2)
    $percentFree = [math]::Round(($drive.FreeSpace/$drive.Size)*100, 1)
    
    Write-Host "  $($drive.DeviceID): $freeGB GB free / $sizeGB GB ($percentFree%)"
    
    if ($percentFree -lt 10) {
        Add-Warn "Disk Space" "$($drive.DeviceID) Only $percentFree% free"
    } else {
        Add-Pass "Disk Space" "$($drive.DeviceID) $percentFree% free"
    }
}

# Disk speed test
Write-Host "`n  Running disk write speed test..." -ForegroundColor Cyan
$testfile = "$env:TEMP\diag_disktest.bin"
try {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $fs = [System.IO.File]::Create($testfile)
    $buffer = New-Object byte[] (1MB)
    $rnd = New-Object System.Random
    for($i=0; $i -lt 200; $i++) { $rnd.NextBytes($buffer); $fs.Write($buffer,0,$buffer.Length) }
    $fs.Flush(); $fs.Close(); $sw.Stop()
    $writeSpeed = [math]::Round(200 / $sw.Elapsed.TotalSeconds, 2)
    Remove-Item $testfile -Force -ErrorAction SilentlyContinue
    
    if ($writeSpeed -gt 100) {
        Add-Pass "Write Speed" "$writeSpeed MB/s (Excellent)"
    } elseif ($writeSpeed -gt 50) {
        Add-Pass "Write Speed" "$writeSpeed MB/s (Good)"
    } elseif ($writeSpeed -gt 20) {
        Add-Warn "Write Speed" "$writeSpeed MB/s (Slow)"
    } else {
        Add-Fail "Write Speed" "$writeSpeed MB/s (Very Slow)"
    }
} catch {
    Add-Warn "Write Speed" "Test failed: $($_.Exception.Message)"
}

# ============================================================
# 5. BATTERY DIAGNOSTIC
# ============================================================
Write-Section "BATTERY DIAGNOSTIC"

$battery = Get-CimInstance -ClassName Win32_Battery
if ($battery) {
    $batteryReportPath = "$env:TEMP\battery_report.html"
    powercfg /batteryreport /output $batteryReportPath 2>$null | Out-Null
    
    if (Test-Path $batteryReportPath) {
        $html = Get-Content $batteryReportPath -Raw
        
        # Extract design capacity
        if ($html -match 'DESIGN CAPACITY.*?([\d,]+)\s*mWh') {
            $designCapacity = [int]($matches[1] -replace ',', '')
        }
        # Extract full charge capacity
        if ($html -match 'FULL CHARGE CAPACITY.*?([\d,]+)\s*mWh') {
            $fullChargeCapacity = [int]($matches[1] -replace ',', '')
        }
        # Extract cycle count
        if ($html -match 'CYCLE COUNT.*?(\d+)') {
            $cycleCount = [int]$matches[1]
        }
        
        if ($designCapacity -and $fullChargeCapacity) {
            $batteryHealth = [math]::Round(($fullChargeCapacity / $designCapacity) * 100, 1)
            $charge = $battery.EstimatedChargeRemaining
            
            Write-Host "  Design Capacity: $designCapacity mWh"
            Write-Host "  Full Charge: $fullChargeCapacity mWh"
            Write-Host "  Health: $batteryHealth%"
            Write-Host "  Cycle Count: $cycleCount"
            Write-Host "  Current Charge: $charge%"
            
            $batteryResult = [PSCustomObject]@{
                DesignCapacity = $designCapacity
                FullChargeCapacity = $fullChargeCapacity
                Health = $batteryHealth
                CycleCount = $cycleCount
                CurrentCharge = $charge
            }
            $report += $batteryResult
            
            if ($batteryHealth -ge 80) {
                Add-Pass "Battery Health" "$batteryHealth% (Good)"
            } elseif ($batteryHealth -ge 60) {
                Add-Warn "Battery Health" "$batteryHealth% (Degraded - consider replacement)"
            } else {
                Add-Fail "Battery Health" "$batteryHealth% (Poor - replace soon)"
            }
            
            if ($cycleCount -lt 300) {
                Add-Pass "Battery Cycles" "$cycleCount (Good)"
            } elseif ($cycleCount -lt 500) {
                Add-Warn "Battery Cycles" "$cycleCount (Moderate usage)"
            } else {
                Add-Warn "Battery Cycles" "$cycleCount (High usage)"
            }
        }
    }
    Remove-Item $batteryReportPath -Force -ErrorAction SilentlyContinue
} else {
    Add-Warn "Battery" "No battery detected (Desktop?)"
}

# ============================================================
# 6. GPU DIAGNOSTIC
# ============================================================
Write-Section "GPU DIAGNOSTIC"

$gpus = Get-CimInstance -ClassName Win32_VideoController
foreach ($gpu in $gpus) {
    $vramGB = [math]::Round($gpu.AdapterRAM/1GB, 2)
    Write-Host "  GPU: $($gpu.Name)"
    Write-Host "  VRAM: $vramGB GB | Driver: $($gpu.DriverVersion)"
    Write-Host "  Resolution: $($gpu.VideoModeDescription)"
    
    if ($gpu.Status -eq "OK") {
        Add-Pass "GPU" "$($gpu.Name) - OK"
    } else {
        Add-Fail "GPU" "$($gpu.Name) - $($gpu.Status)"
    }
    
    # Check driver age
    if ($gpu.DriverDate) {
        $driverAge = (Get-Date) - $gpu.DriverDate
        if ($driverAge.Days -gt 365) {
            Add-Warn "GPU Driver" "Old driver ($([math]::Round($driverAge.Days/30)) months old) - Consider updating"
        } else {
            Add-Pass "GPU Driver" "Recent ($([math]::Round($driverAge.Days/30)) months old)"
        }
    }
}

# ============================================================
# 7. NETWORK DIAGNOSTIC
# ============================================================
Write-Section "NETWORK ADAPTERS DIAGNOSTIC"

$adapters = Get-CimInstance -ClassName Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $true}
foreach ($adapter in $adapters) {
    Write-Host "  Adapter: $($adapter.Name)"
    Write-Host "  MAC: $($adapter.MACAddress) | Status: $($adapter.Status)"
    
    if ($adapter.Status -eq "Up") {
        Add-Pass "Network" "$($adapter.Name) - Connected"
    } else {
        Add-Warn "Network" "$($adapter.Name) - $($adapter.Status)"
    }
}

# Check for WiFi errors
$wifiErrors = Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2,3; StartTime=(Get-Date).AddDays(-7)} -MaxEvents 100 -ErrorAction SilentlyContinue | 
    Where-Object { $_.Message -match "Wi-Fi|WiFi|WLAN|Network" }

if ($wifiErrors.Count -gt 10) {
    Add-Warn "WiFi Stability" "$($wifiErrors.Count) network errors in last 7 days"
} elseif ($wifiErrors.Count -gt 0) {
    Add-Warn "WiFi Stability" "$($wifiErrors.Count) network errors in last 7 days"
} else {
    Add-Pass "WiFi Stability" "No network errors in last 7 days"
}

# ============================================================
# 8. THERMAL / SYSTEM EVENTS
# ============================================================
Write-Section "SYSTEM HEALTH CHECK"

# Check for critical errors
$criticalEvents = Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2; StartTime=(Get-Date).AddDays(-30)} -MaxEvents 50 -ErrorAction SilentlyContinue
if ($criticalEvents) {
    Write-Host "  Last 30 days: $($criticalEvents.Count) critical/error events"
    
    # Categorize errors
    $bsodEvents = $criticalEvents | Where-Object { $_.Id -eq 41 -or $_.Id -eq 1001 }
    if ($bsodEvents) {
        Add-Fail "System Stability" "Possible BSOD/crash events found"
    } else {
        Add-Pass "System Stability" "No BSOD/crash events"
    }
    
    $powerEvents = $criticalEvents | Where-Object { $_.ProviderName -eq 'Microsoft-Windows-Kernel-Power' }
    if ($powerEvents.Count -gt 5) {
        Add-Warn "Power Events" "$($powerEvents.Count) power events (check sleep/wake)"
    }
} else {
    Add-Pass "System Errors" "No critical errors in last 30 days"
}

# Check uptime
$uptime = (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
Write-Host "  Uptime: $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m"

# Check Windows activation
$license = Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.PartialProductKey -and $_.LicenseStatus -eq 1 }
if ($license) {
    Add-Pass "Windows License" "Activated"
} else {
    Add-Warn "Windows License" "Not activated or unknown"
}

# ============================================================
# 9. SECURITY CHECK
# ============================================================
Write-Section "SECURITY STATUS"

# Windows Defender
$defender = Get-MpComputerStatus -ErrorAction SilentlyContinue
if ($defender) {
    if ($defender.RealTimeProtectionEnabled) {
        Add-Pass "Antivirus" "Windows Defender - Real-time protection ON"
    } else {
        Add-Warn "Antivirus" "Real-time protection OFF"
    }
    
    if ($defender.AntivirusEnabled) {
        Add-Pass "Antivirus Status" "Enabled"
    }
    
    Write-Host "  Last scan: $($defender.FullScanEndTime)"
    Write-Host "  Definitions: $($defender.AntivirusSignatureLastUpdated)"
}

# Firewall
$firewall = Get-NetFirewallProfile | Where-Object { $_.Enabled -eq $true }
if ($firewall.Count -ge 3) {
    Add-Pass "Firewall" "All profiles enabled"
} else {
    Add-Warn "Firewall" "Some profiles disabled"
}

# ============================================================
# GENERATE REPORT
# ============================================================
Write-Section "DIAGNOSTIC COMPLETE"

$endTime = Get-Date
$duration = $endTime - $startTime

Write-Host "`n  Test Duration: $([math]::Round($duration.TotalSeconds, 1)) seconds"
Write-Host "  Passes: $($passes.Count)" -ForegroundColor Green
Write-Host "  Warnings: $(($issues | Where-Object {$_.Severity -eq 'WARN'}).Count)" -ForegroundColor Yellow
Write-Host "  Failures: $(($issues | Where-Object {$_.Severity -eq 'FAIL'}).Count)" -ForegroundColor Red

# Calculate health score
$score = 100
$failCount = ($issues | Where-Object {$_.Severity -eq 'FAIL'}).Count
$warnCount = ($issues | Where-Object {$_.Severity -eq 'WARN'}).Count
$score -= ($failCount * 15) + ($warnCount * 5)
if ($score -lt 0) { $score = 0 }

Write-Host "`n  ╔═══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║  OVERALL HEALTH SCORE: $score / 100     ║" -ForegroundColor $(if($score -ge 80){"Green"}elseif($score -ge 60){"Yellow"}else{"Red"})
Write-Host "  ╚═══════════════════════════════════════╝" -ForegroundColor Cyan

# Summary of issues
if ($issues.Count -gt 0) {
    Write-Host "`n  ISSUES FOUND:" -ForegroundColor Yellow
    foreach ($issue in $issues) {
        $color = if ($issue.Severity -eq 'FAIL') { "Red" } else { "Yellow" }
        Write-Host "    [$($issue.Severity)] $($issue.Test): $($issue.Detail)" -ForegroundColor $color
    }
}

# ============================================================
# EXPORT HTML REPORT
# ============================================================
$css = 'body { font-family: Arial, sans-serif; margin: 20px; background: #1a1a2e; color: #eee; }'
$css += 'h1 { color: #00d4ff; }'
$css += 'h2 { color: #ff6b6b; border-bottom: 2px solid #333; padding-bottom: 10px; }'
$css += 'table { border-collapse: collapse; width: 100%; margin: 10px 0; }'
$css += 'th, td { border: 1px solid #444; padding: 10px; text-align: left; }'
$css += 'th { background: #16213e; }'
$css += '.score { font-size: 48px; font-weight: bold; text-align: center; padding: 20px; }'
$css += '.score-good { color: #00ff88; }'
$css += '.score-warn { color: #ffdd00; }'
$css += '.score-bad { color: #ff4444; }'
$css += '.badge { padding: 3px 10px; border-radius: 3px; font-weight: bold; }'
$css += '.badge-pass { background: #00ff88; color: black; }'
$css += '.badge-warn { background: #ffdd00; color: black; }'
$css += '.badge-fail { background: #ff4444; color: white; }'

$scoreClass = if ($score -ge 80) { 'score-good' } elseif ($score -ge 60) { 'score-warn' } else { 'score-bad' }
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

$htmlReport = '<!DOCTYPE html><html><head><title>Laptop Diagnostic Report</title><style>' + $css + '</style></head><body>'
$htmlReport += '<h1>Laptop Diagnostic Report</h1>'
$htmlReport += '<p>Generated: ' + $timestamp + '</p>'
$htmlReport += '<h2>System Information</h2><table>'
$htmlReport += '<tr><th>Property</th><th>Value</th></tr>'
$htmlReport += '<tr><td>Manufacturer</td><td>' + $systemInfo.Manufacturer + '</td></tr>'
$htmlReport += '<tr><td>Model</td><td>' + $systemInfo.Model + '</td></tr>'
$htmlReport += '<tr><td>Serial Number</td><td>' + $systemInfo.SerialNumber + '</td></tr>'
$htmlReport += '<tr><td>Operating System</td><td>' + $systemInfo.OS + '</td></tr>'
$htmlReport += '<tr><td>CPU</td><td>' + $systemInfo.CPU + '</td></tr>'
$htmlReport += '<tr><td>Cores/Threads</td><td>' + $systemInfo.CPUCores + '/' + $systemInfo.CPULogical + '</td></tr>'
$htmlReport += '<tr><td>RAM</td><td>' + $systemInfo.RAM_GB + ' GB</td></tr>'
$htmlReport += '</table>'

$htmlReport += '<h2>Health Score</h2>'
$htmlReport += '<div class="score ' + $scoreClass + '">' + $score + ' / 100</div>'

$htmlReport += '<h2>Test Results</h2><table>'
$htmlReport += '<tr><th>Test</th><th>Status</th><th>Details</th></tr>'

foreach ($p in $passes) {
    $htmlReport += '<tr><td>' + $p.Test + '</td><td><span class="badge badge-pass">PASS</span></td><td>' + $p.Detail + '</td></tr>'
}
foreach ($i in $issues) {
    $badgeClass = if ($i.Severity -eq 'FAIL') { 'badge-fail' } else { 'badge-warn' }
    $htmlReport += '<tr><td>' + $i.Test + '</td><td><span class="badge ' + $badgeClass + '">' + $i.Severity + '</span></td><td>' + $i.Detail + '</td></tr>'
}

$htmlReport += '</table>'
$htmlReport += '<h2>Summary</h2>'
$htmlReport += '<p>Passed: ' + $passes.Count + ' | Warnings: ' + $warnCount + ' | Failures: ' + $failCount + '</p>'
$htmlReport += '<p>Test Duration: ' + [math]::Round($duration.TotalSeconds, 1) + ' seconds</p>'
$htmlReport += '<hr><p style="color: #666; font-size: 12px;">Generated by Laptop Diagnostic Tool v1.0</p>'
$htmlReport += '</body></html>'

$htmlReport | Out-File -FilePath $OutputPath -Encoding UTF8
Write-Host "`n  📄 Report saved to: $OutputPath" -ForegroundColor Cyan
Write-Host "  Open the HTML file in a browser for detailed report.`n" -ForegroundColor Gray

# Return summary object
return [PSCustomObject]@{
    System = $systemInfo
    Score = $score
    Passes = $passes
    Issues = $issues
    ReportPath = $OutputPath
}
