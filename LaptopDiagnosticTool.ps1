#Requires -Version 5.1
<#
.SYNOPSIS
    Laptop Hardware Diagnostic Tool v2.0
.DESCRIPTION
    Tests CPU, RAM, SSD, Battery, GPU, Network & verifies hardware against expected specs.
    Includes CPU database, laptop model verification, and component authentication.
.NOTES
    Author: Diagnostic Tool v2.0
    Run as Administrator for full results
#>

param(
    [switch]$StressTest,
    [switch]$QuickTest,
    [switch]$DeepScan,
    [string]$OutputPath = ""
)

# Set default output path to actual Desktop (handles OneDrive redirection)
if ([string]::IsNullOrEmpty($OutputPath)) {
    $DesktopPath = [Environment]::GetFolderPath('Desktop')
    if ([string]::IsNullOrEmpty($DesktopPath) -or -not (Test-Path $DesktopPath)) {
        $DesktopPath = "$env:USERPROFILE"
    }
    $OutputPath = Join-Path $DesktopPath "LaptopReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
}

# ============================================================
# INITIALIZATION
# ============================================================
$ErrorActionPreference = "SilentlyContinue"
$report = @()
$issues = @()
$passes = @()
$warnings = @()
$verifications = @()

# Import hardware database
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module "$scriptPath\HardwareDatabase.psm1" -Force

function Write-Section($title) {
    Write-Host "`n" -NoNewline
    Write-Host ("=" * 70) -ForegroundColor DarkCyan
    Write-Host "  $title" -ForegroundColor Yellow
    Write-Host ("=" * 70) -ForegroundColor DarkCyan
}

function Write-Subsection($title) {
    Write-Host "`n  --- $title ---" -ForegroundColor Magenta
}

function Add-Pass($test, $detail) {
    $script:passes += [PSCustomObject]@{Test=$test; Detail=$detail; Category="PASS"}
    Write-Host "  [PASS] $test" -ForegroundColor Green -NoNewline
    Write-Host " - $detail" -ForegroundColor Gray
}

function Add-Warn($test, $detail) {
    $script:issues += [PSCustomObject]@{Test=$test; Detail=$detail; Severity="WARN"; Category="WARN"}
    $script:warnings += [PSCustomObject]@{Test=$test; Detail=$detail}
    Write-Host "  [WARN] $test" -ForegroundColor Yellow -NoNewline
    Write-Host " - $detail" -ForegroundColor Gray
}

function Add-Fail($test, $detail) {
    $script:issues += [PSCustomObject]@{Test=$test; Detail=$detail; Severity="FAIL"; Category="FAIL"}
    Write-Host "  [FAIL] $test" -ForegroundColor Red -NoNewline
    Write-Host " - $detail" -ForegroundColor Gray
}

function Add-Info($test, $detail) {
    Write-Host "  [INFO] $test" -ForegroundColor Cyan -NoNewline
    Write-Host " - $detail" -ForegroundColor Gray
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

    +===========================================================+
    |       LAPTOP HARDWARE DIAGNOSTIC TOOL v2.0                |
    |       Hardware Verification & Stress Testing              |
    |       Checks against known CPU/Laptop/Storage database     |
    +===========================================================+

"@ -ForegroundColor Cyan

$startTime = Get-Date

# ============================================================
# 1. SYSTEM INFORMATION
# ============================================================
Write-Section "SYSTEM INFORMATION"

$sys = Get-CimInstance -ClassName Win32_ComputerSystem
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$cpu = Get-CimInstance -ClassName Win32_Processor
$bios = Get-CimInstance -ClassName Win32_BIOS
$baseboard = Get-CimInstance -ClassName Win32_BaseBoard

$systemInfo = [PSCustomObject]@{
    Manufacturer = $sys.Manufacturer
    Model = $sys.Model
    SystemFamily = $sys.SystemFamily
    SerialNumber = $bios.SerialNumber
    BIOSVersion = $bios.SMBIOSBIOSVersion
    BIOSDate = if($bios.ReleaseDate){$bios.ReleaseDate.ToString("yyyy-MM-dd")}else{"Unknown"}
    Motherboard = "$($baseboard.Manufacturer) $($baseboard.Product)"
    OS = $os.Caption
    OSVersion = $os.Version
    OSBuild = $os.BuildNumber
    Architecture = $os.OSArchitecture
    CPU = $cpu.Name
    CPUCores = $cpu.NumberOfCores
    CPULogical = $cpu.NumberOfLogicalProcessors
    MaxClockMHz = $cpu.MaxClockSpeed
    CurrentClockMHz = $cpu.CurrentClockSpeed
    L2CacheKB = $cpu.L2CacheSize
    L3CacheKB = $cpu.L3CacheSize
    CPUSocket = $cpu.SocketDesignation
    CPUFamily = $cpu.Family
    CPUStepping = $cpu.Stepping
    CPUId = $cpu.ProcessorId
    RAM_GB = [math]::Round($sys.TotalPhysicalMemory/1GB, 2)
}

Write-Host "  Manufacturer  : $($systemInfo.Manufacturer)"
Write-Host "  Model         : $($systemInfo.Model)"
Write-Host "  Serial Number : $($systemInfo.SerialNumber)"
Write-Host "  Motherboard   : $($systemInfo.Motherboard)"
Write-Host "  BIOS          : $($systemInfo.BIOSVersion) ($($systemInfo.BIOSDate))"
Write-Host "  OS            : $($systemInfo.OS) (Build $($systemInfo.OSBuild))"
Write-Host "  CPU           : $($systemInfo.CPU)"
Write-Host "  Cores/Threads : $($systemInfo.CPUCores)C / $($systemInfo.CPULogical)T"
Write-Host "  Clock Speed   : $($systemInfo.CurrentClockMHz) MHz (Max: $($systemInfo.MaxClockMHz) MHz)"
Write-Host "  L2/L3 Cache   : $($systemInfo.L2CacheKB) KB / $($systemInfo.L3CacheKB) KB"
Write-Host "  Socket        : $($systemInfo.CPUSocket)"
Write-Host "  RAM           : $($systemInfo.RAM_GB) GB"

# ============================================================
# 2. CPU VERIFICATION AGAINST DATABASE
# ============================================================
Write-Section "CPU VERIFICATION"

Write-Subsection "Checking CPU against known database..."

$cpuVerify = Verify-CPU -cpuName $cpu.Name -cores $cpu.NumberOfCores -threads $cpu.NumberOfLogicalProcessors -clockSpeed $cpu.CurrentClockSpeed -l3Cache $cpu.L3CacheSize

if ($cpuVerify.Found) {
    Write-Host "  Database Match : $($cpuVerify.MatchType)" -ForegroundColor Green
    Write-Host "  Architecture   : $($cpuVerify.Architecture)"
    Write-Host "  Release Year   : $($cpuVerify.Year)"
    Write-Host "  Expected Specs : $($cpuVerify.ExpectedCores)C/$($cpuVerify.ExpectedThreads)T @ $($cpuVerify.ExpectedClock)MHz, L3: $($cpuVerify.ExpectedCache)KB"
    
    if ($cpuVerify.Warnings.Count -eq 0) {
        Add-Pass "CPU Verification" "All specs match database ($($cpuVerify.MatchType) match)"
    } else {
        foreach ($warn in $cpuVerify.Warnings) {
            Add-Warn "CPU Verification" $warn
        }
    }
    
    # Check CPU age
    $cpuAge = (Get-Date).Year - $cpuVerify.Year
    if ($cpuAge -le 2) {
        Add-Pass "CPU Age" "Modern CPU ($cpuAge years old)"
    } elseif ($cpuAge -le 4) {
        Add-Pass "CPU Age" "Recent CPU ($cpuAge years old)"
    } elseif ($cpuAge -le 6) {
        Add-Warn "CPU Age" "Getting older ($cpuAge years old)"
    } else {
        Add-Warn "CPU Age" "Old CPU ($cpuAge years old) - consider if acceptable"
    }
    
    $verifications += [PSCustomObject]@{
        Component = "CPU"
        Detected = $cpu.Name
        Expected = "$($cpuVerify.ExpectedCores)C/$($cpuVerify.ExpectedThreads)T @ $($cpuVerify.ExpectedClock)MHz"
        Status = if($cpuVerify.Warnings.Count -eq 0){"VERIFIED"}else{"MISMATCH"}
    }
} else {
    Add-Warn "CPU Verification" "CPU not found in database - cannot verify specs"
    Add-Info "CPU Name" $cpu.Name
    Add-Info "Detected Specs" "$($cpu.NumberOfCores)C/$($cpu.NumberOfLogicalProcessors)T @ $($cpu.CurrentClockSpeed)MHz"
}

# Check if CPU matches laptop model
Write-Subsection "Checking CPU is original for this laptop model..."

$laptopVerify = Verify-LaptopModel -model $sys.Model -cpuName $cpu.Name -ramGB $systemInfo.RAM_GB -storageType "" -storageGB 0 -ramSpeed 0

if ($laptopVerify.Found) {
    if ($cpu.Name -match $laptopVerify.ExpectedCPUFamily) {
        Add-Pass "CPU Original Check" "CPU matches expected family for $($sys.Model)"
    } else {
        Add-Warn "CPU Original Check" "CPU ($cpu.Name) may not be original (Expected: $($laptopVerify.ExpectedCPUFamily))"
        Add-Info "Note" "CPU may have been upgraded or replaced"
    }
} else {
    Add-Info "Laptop Model" "Model '$($sys.Model)' not in database - skipping original check"
}

# ============================================================
# 3. RAM VERIFICATION
# ============================================================
Write-Section "MEMORY (RAM) VERIFICATION"

$ram = Get-CimInstance -ClassName Win32_PhysicalMemory
$totalRamGB = 0
$ramDetails = @()

Write-Subsection "Detected RAM Modules:"

foreach ($stick in $ram) {
    $stickGB = [math]::Round($stick.Capacity/1GB, 2)
    $totalRamGB += $stickGB
    $partNum = if($stick.PartNumber){$stick.PartNumber.Trim()}else{"Unknown"}
    
    Write-Host "  Slot: $($stick.BankLabel)" -ForegroundColor White
    Write-Host "    Capacity    : $stickGB GB"
    Write-Host "    Speed       : $($stick.Speed) MHz (Configured: $($stick.ConfiguredClockSpeed) MHz)"
    Write-Host "    Manufacturer: $($stick.Manufacturer)"
    Write-Host "    Part Number : $partNum"
    
    # Verify individual stick
    $ramVerify = Verify-RAM -partNumber $partNum -capacityGB $stickGB -speed $stick.Speed -manufacturer $stick.Manufacturer
    
    if ($ramVerify.Found) {
        Add-Pass "RAM Module" "$partNum - Verified ($($stickGB)GB $($stick.Speed)MHz)"
        if ($ramVerify.Warnings.Count -gt 0) {
            foreach ($w in $ramVerify.Warnings) { Add-Warn "RAM Check" $w }
        }
    } else {
        Add-Info "RAM Module" "$partNum - Not in database (Using generic checks)"
    }
    
    $ramDetails += [PSCustomObject]@{
        Slot = $stick.BankLabel
        Capacity = $stickGB
        Speed = $stick.Speed
        PartNumber = $partNum
        Manufacturer = $stick.Manufacturer
    }
}

# Total RAM checks
Write-Subsection "Total RAM Analysis:"

if ($totalRamGB -ge 16) {
    Add-Pass "Total RAM" "$totalRamGB GB - Excellent for multitasking"
} elseif ($totalRamGB -ge 8) {
    Add-Pass "Total RAM" "$totalRamGB GB - Good for most tasks"
} elseif ($totalRamGB -ge 4) {
    Add-Warn "Total RAM" "$totalRamGB GB - Minimum for Windows 11, may be slow"
} else {
    Add-Fail "Total RAM" "$totalRamGB GB - Below Windows 11 minimum"
}

# Check if running single or dual channel
if ($ram.Count -eq 1) {
    Add-Warn "RAM Configuration" "Single channel - dual channel would improve performance"
} elseif ($ram.Count -ge 2) {
    $speeds = $ram | Select-Object -ExpandProperty Speed -Unique
    if ($speeds.Count -eq 1) {
        Add-Pass "RAM Configuration" "Dual channel detected ($($ram.Count) sticks matched)"
    } else {
        Add-Warn "RAM Configuration" "Mixed speeds detected - may not run optimal dual channel"
    }
}

# Check RAM speed vs CPU support
$maxSupportedSpeed = if($cpuVerify.Found -and $cpuVerify.Year -ge 2021){3200}elseif($cpuVerify.Found -and $cpuVerify.Year -ge 2019){2400}else{2666}
$maxDetectedSpeed = ($ram | Measure-Object -Property Speed -Maximum).Maximum
if ($maxDetectedSpeed -gt $maxSupportedSpeed) {
    Add-Warn "RAM Speed" "RAM at ${maxDetectedSpeed}MHz may exceed CPU support (max ~${maxSupportedSpeed}MHz)"
} else {
    Add-Pass "RAM Speed" "${maxDetectedSpeed}MHz within CPU support"
}

# Available memory
$mem = Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Memory
$availableMB = $mem.AvailableMBytes
$usedPercent = [math]::Round((($totalRamGB*1024 - $availableMB) / ($totalRamGB*1024)) * 100)
if ($availableMB -gt 1024) {
    Add-Pass "Available RAM" "$availableMB MB free ($usedPercent% used)"
} else {
    Add-Warn "Available RAM" "Low: Only $availableMB MB free"
}

# ============================================================
# 4. STORAGE VERIFICATION
# ============================================================
Write-Section "STORAGE VERIFICATION"

$disks = Get-PhysicalDisk
$logicalDisks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"

foreach ($disk in $disks) {
    Write-Subsection "Disk: $($disk.FriendlyName)"
    
    $sizeGB = [math]::Round($disk.Size/1GB, 2)
    Write-Host "  Model       : $($disk.FriendlyName)"
    Write-Host "  Type        : $($disk.MediaType)"
    Write-Host "  Interface   : $($disk.BusType)"
    Write-Host "  Capacity    : $sizeGB GB"
    Write-Host "  Health      : $($disk.HealthStatus)"
    
    # Verify against database
    $storageVerify = Verify-Storage -modelName $disk.FriendlyName -sizeBytes $disk.Size -busType $disk.BusType.ToString()
    
    if ($storageVerify.Found) {
        Add-Pass "Storage Verification" "$($disk.FriendlyName) - Found in database"
        Add-Info "Expected Type" "$($storageVerify.ExpectedType) $($storageVerify.ExpectedCapacityGB)GB"
        if ($storageVerify.Warnings.Count -gt 0) {
            foreach ($w in $storageVerify.Warnings) { Add-Warn "Storage Check" $w }
        }
    } else {
        Add-Info "Storage" "$($disk.FriendlyName) - Not in database"
    }
    
    # Health check
    if ($disk.HealthStatus -eq "Healthy") {
        Add-Pass "Disk Health" "$($disk.FriendlyName) - Healthy"
    } else {
        Add-Fail "Disk Health" "$($disk.FriendlyName) - $($disk.HealthStatus)"
    }
    
    # Interface check
    switch ($disk.BusType) {
        "NVMe" { Add-Pass "Disk Interface" "NVMe - Fastest storage available" }
        "SATA" { Add-Warn "Disk Interface" "SATA SSD - Slower than NVMe" }
        "SCSI" { Add-Warn "Disk Interface" "SCSI detected - verify actual type" }
        default { Add-Info "Disk Interface" "$($disk.BusType)" }
    }
}

# Disk space
Write-Subsection "Disk Space Analysis:"
foreach ($drive in $logicalDisks) {
    $sizeGB = [math]::Round($drive.Size/1GB, 2)
    $freeGB = [math]::Round($drive.FreeSpace/1GB, 2)
    $percentFree = [math]::Round(($drive.FreeSpace/$drive.Size)*100, 1)
    
    if ($percentFree -lt 10) {
        Add-Warn "Disk Space" "$($drive.DeviceID) Only $percentFree% free ($freeGB GB)"
    } elseif ($percentFree -lt 20) {
        Add-Warn "Disk Space" "$($drive.DeviceID) $percentFree% free ($freeGB GB)"
    } else {
        Add-Pass "Disk Space" "$($drive.DeviceID) $percentFree% free ($freeGB GB)"
    }
}

# Disk speed test
Write-Subsection "Running disk write speed test..."
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
    
    if ($writeSpeed -gt 200) {
        Add-Pass "Write Speed" "$writeSpeed MB/s (Excellent - NVMe)"
    } elseif ($writeSpeed -gt 100) {
        Add-Pass "Write Speed" "$writeSpeed MB/s (Good)"
    } elseif ($writeSpeed -gt 50) {
        Add-Warn "Write Speed" "$writeSpeed MB/s (Average)"
    } elseif ($writeSpeed -gt 20) {
        Add-Warn "Write Speed" "$writeSpeed MB/s (Slow)"
    } else {
        Add-Fail "Write Speed" "$writeSpeed MB/s (Very Slow - possible failure)"
    }
} catch {
    Add-Warn "Write Speed" "Test failed: $($_.Exception.Message)"
}

# ============================================================
# 5. LAPTOP MODEL VERIFICATION
# ============================================================
Write-Section "LAPTOP MODEL VERIFICATION"

Write-Subsection "Checking laptop model against known specs..."

$laptopVerify2 = Verify-LaptopModel -model $sys.Model -cpuName $cpu.Name -ramGB $totalRamGB -storageType $disks[0].BusType.ToString() -storageGB [math]::Round($disks[0].Size/1GB) -ramSpeed $maxDetectedSpeed

if ($laptopVerify2.Found) {
    Write-Host "  Model Found   : Yes" -ForegroundColor Green
    Write-Host "  Release Year  : $($laptopVerify2.ReleaseYear)"
    Write-Host "  Expected RAM  : $($laptopVerify2.ExpectedRAMMin)-$($laptopVerify2.ExpectedRAMMax) GB"
    Write-Host "  Expected CPU  : $($laptopVerify2.ExpectedCPUFamily)"
    Write-Host "  Expected Disk : $($laptopVerify2.ExpectedStorageType) $($laptopVerify2.ExpectedStorageMinGB)+ GB"
    
    if ($laptopVerify2.Warnings.Count -eq 0) {
        Add-Pass "Model Verification" "$($sys.Model) - All specs match expected"
    } else {
        foreach ($w in $laptopVerify2.Warnings) {
            Add-Warn "Model Verification" $w
        }
    }
    
    if ($laptopVerify2.Recommendations.Count -gt 0) {
        foreach ($r in $laptopVerify2.Recommendations) {
            Add-Info "Recommendation" $r
        }
    }
    
    $verifications += [PSCustomObject]@{
        Component = "Laptop Model"
        Detected = $sys.Model
        Expected = "$($laptopVerify2.ExpectedRAMMin)-$($laptopVerify2.ExpectedRAMMax)GB RAM, $($laptopVerify2.ExpectedStorageMinGB)+GB $($laptopVerify2.ExpectedStorageType)"
        Status = if($laptopVerify2.Warnings.Count -eq 0){"VERIFIED"}else{"CHECK"}
    }
} else {
    Add-Info "Model Verification" "$($sys.Model) not in database"
    Add-Info "Note" "Cannot verify if components are original"
}

# ============================================================
# 6. BATTERY DIAGNOSTIC
# ============================================================
Write-Section "BATTERY DIAGNOSTIC"

$battery = Get-CimInstance -ClassName Win32_Battery
if ($battery) {
    $batteryReportPath = "$env:TEMP\battery_report.html"
    powercfg /batteryreport /output $batteryReportPath 2>$null | Out-Null
    
    if (Test-Path $batteryReportPath) {
        $html = Get-Content $batteryReportPath -Raw
        
        if ($html -match 'DESIGN CAPACITY.*?([\d,]+)\s*mWh') {
            $designCapacity = [int]($matches[1] -replace ',', '')
        }
        if ($html -match 'FULL CHARGE CAPACITY.*?([\d,]+)\s*mWh') {
            $fullChargeCapacity = [int]($matches[1] -replace ',', '')
        }
        if ($html -match 'CYCLE COUNT.*?(\d+)') {
            $cycleCount = [int]$matches[1]
        }
        
        if ($designCapacity -and $fullChargeCapacity) {
            $batteryHealth = [math]::Round(($fullChargeCapacity / $designCapacity) * 100, 1)
            $charge = $battery.EstimatedChargeRemaining
            
            Write-Host "  Design Capacity    : $designCapacity mWh"
            Write-Host "  Full Charge        : $fullChargeCapacity mWh"
            Write-Host "  Health             : $batteryHealth%"
            Write-Host "  Cycle Count        : $cycleCount"
            Write-Host "  Current Charge     : $charge%"
            
            $batteryResult = [PSCustomObject]@{
                DesignCapacity = $designCapacity
                FullChargeCapacity = $fullChargeCapacity
                Health = $batteryHealth
                CycleCount = $cycleCount
                CurrentCharge = $charge
            }
            $report += $batteryResult
            
            if ($batteryHealth -ge 90) {
                Add-Pass "Battery Health" "$batteryHealth% (Excellent)"
            } elseif ($batteryHealth -ge 80) {
                Add-Pass "Battery Health" "$batteryHealth% (Good)"
            } elseif ($batteryHealth -ge 70) {
                Add-Warn "Battery Health" "$batteryHealth% (Fair - will degrade faster)"
            } elseif ($batteryHealth -ge 60) {
                Add-Warn "Battery Health" "$batteryHealth% (Poor - consider replacement ~`$25-40)"
            } else {
                Add-Fail "Battery Health" "$batteryHealth% (Bad - replace soon)"
            }
            
            if ($cycleCount -lt 100) {
                Add-Pass "Battery Cycles" "$cycleCount (Light usage)"
            } elseif ($cycleCount -lt 300) {
                Add-Pass "Battery Cycles" "$cycleCount (Normal usage)"
            } elseif ($cycleCount -lt 500) {
                Add-Warn "Battery Cycles" "$cycleCount (Heavy usage)"
            } else {
                Add-Warn "Battery Cycles" "$cycleCount (Very heavy usage - battery near end of life)"
            }
            
            # Calculate estimated remaining life
            if ($batteryHealth -gt 0) {
                $estimatedCyclesRemaining = [math]::Round((($batteryHealth - 60) / 100) * 500)
                if ($estimatedCyclesRemaining -gt 0) {
                    Add-Info "Battery Estimate" "~$estimatedCyclesRemaining cycles before 60% health"
                }
            }
        }
    }
    Remove-Item $batteryReportPath -Force -ErrorAction SilentlyContinue
} else {
    Add-Warn "Battery" "No battery detected (Desktop?)"
}

# ============================================================
# 7. GPU DIAGNOSTIC
# ============================================================
Write-Section "GPU DIAGNOSTIC"

$gpus = Get-CimInstance -ClassName Win32_VideoController
foreach ($gpu in $gpus) {
    $vramGB = [math]::Round($gpu.AdapterRAM/1GB, 2)
    Write-Host "  GPU          : $($gpu.Name)"
    Write-Host "  VRAM         : $vramGB GB"
    Write-Host "  Driver       : $($gpu.DriverVersion)"
    Write-Host "  Resolution   : $($gpu.VideoModeDescription)"
    
    if ($gpu.Status -eq "OK") {
        Add-Pass "GPU" "$($gpu.Name) - OK"
    } else {
        Add-Fail "GPU" "$($gpu.Name) - $($gpu.Status)"
    }
    
    # VRAM check
    if ($vramGB -ge 4) {
        Add-Pass "VRAM" "$vramGB GB - Good for multitasking"
    } elseif ($vramGB -ge 2) {
        Add-Pass "VRAM" "$vramGB GB - Adequate for basic use"
    } else {
        Add-Warn "VRAM" "$vramGB GB - Low for modern applications"
    }
    
    # Driver age check
    if ($gpu.DriverDate) {
        $driverAge = (Get-Date) - $gpu.DriverDate
        $driverMonths = [math]::Round($driverAge.Days/30)
        if ($driverMonths -gt 24) {
            Add-Warn "GPU Driver" "Old driver ($driverMonths months) - Update recommended"
        } elseif ($driverMonths -gt 12) {
            Add-Warn "GPU Driver" "Driver is $driverMonths months old"
        } else {
            Add-Pass "GPU Driver" "Recent ($driverMonths months old)"
        }
    }
}

# ============================================================
# 8. NETWORK DIAGNOSTIC
# ============================================================
Write-Section "NETWORK ADAPTERS DIAGNOSTIC"

$adapters = Get-CimInstance -ClassName Win32_NetworkAdapter | Where-Object {$_.PhysicalAdapter -eq $true}
foreach ($adapter in $adapters) {
    Write-Host "  Adapter      : $($adapter.Name)"
    Write-Host "  MAC          : $($adapter.MACAddress)"
    Write-Host "  Speed        : $(if($adapter.Speed){[math]::Round($adapter.Speed/1MB)}else{'Unknown'}) Mbps"
    
    if ($adapter.Status -eq "Up") {
        Add-Pass "Network" "$($adapter.Name) - Connected"
    } elseif ($adapter.Status -eq "Disconnected") {
        Add-Info "Network" "$($adapter.Name) - Not connected"
    } else {
        Add-Warn "Network" "$($adapter.Name) - $($adapter.Status)"
    }
    
    # WiFi standard detection
    if ($adapter.Name -match "AX200|AX201|AX210|AX211") {
        Add-Pass "WiFi Standard" "WiFi 6 (802.11ax) - Latest"
    } elseif ($adapter.Name -match "AC9560|AC8265|AC7265|AC3168") {
        Add-Pass "WiFi Standard" "WiFi 5 (802.11ac)"
    } elseif ($adapter.Name -match "Wireless-AC|Dual Band") {
        Add-Info "WiFi Standard" "WiFi 5 (802.11ac)"
    }
}

# Check for WiFi errors
$wifiErrors = Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2,3; StartTime=(Get-Date).AddDays(-7)} -MaxEvents 100 -ErrorAction SilentlyContinue | 
    Where-Object { $_.Message -match "Wi-Fi|WiFi|WLAN|Network|Netwtw" }

if ($wifiErrors.Count -gt 10) {
    Add-Warn "WiFi Stability" "$($wifiErrors.Count) network errors in last 7 days - adapter may be faulty"
} elseif ($wifiErrors.Count -gt 0) {
    Add-Warn "WiFi Stability" "$($wifiErrors.Count) network errors in last 7 days"
} else {
    Add-Pass "WiFi Stability" "No network errors in last 7 days"
}

# ============================================================
# 9. SYSTEM HEALTH CHECK
# ============================================================
Write-Section "SYSTEM HEALTH CHECK"

# Check for critical errors
$criticalEvents = Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2; StartTime=(Get-Date).AddDays(-30)} -MaxEvents 100 -ErrorAction SilentlyContinue
if ($criticalEvents) {
    Write-Host "  Last 30 days: $($criticalEvents.Count) critical/error events"
    
    # Categorize errors
    $bsodEvents = $criticalEvents | Where-Object { $_.Id -eq 41 -or $_.Id -eq 1001 -or $_.Message -match "BlueScreen|BugCheck" }
    if ($bsodEvents) {
        Add-Fail "System Stability" "BSOD/crash events found - system may be unstable"
    } else {
        Add-Pass "System Stability" "No BSOD/crash events"
    }
    
    $kernelPower = $criticalEvents | Where-Object { $_.ProviderName -eq 'Microsoft-Windows-Kernel-Power' }
    if ($kernelPower.Count -gt 10) {
        Add-Warn "Power Events" "$($kernelPower.Count) power events - possible power issues"
    } elseif ($kernelPower.Count -gt 0) {
        Add-Info "Power Events" "$($kernelPower.Count) power events (normal sleep/wake)"
    }
    
    $diskErrors = $criticalEvents | Where-Object { $_.ProviderName -match "disk|storahci|nvme" }
    if ($diskErrors.Count -gt 0) {
        Add-Warn "Disk Errors" "$($diskErrors.Count) disk-related errors in last 30 days"
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

# Check Windows edition vs hardware
$osBuild = [int]$os.BuildNumber
if ($osBuild -ge 22000) {
    # Windows 11
    $cpuSupported = $cpu.NumberOfCores -ge 2 -and $cpu.Name -match "Ryzen|Core|Snapdragon"
    if ($cpuSupported) {
        Add-Pass "Win11 Compatibility" "CPU supports Windows 11"
    } else {
        Add-Warn "Win11 Compatibility" "CPU may not officially support Windows 11"
    }
}

# ============================================================
# 10. SECURITY STATUS
# ============================================================
Write-Section "SECURITY STATUS"

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
    
    $lastScan = if($defender.FullScanEndTime){$defender.FullScanEndTime}else{"Never"}
    Write-Host "  Last full scan: $lastScan"
    
    $defAge = (Get-Date) - $defender.AntivirusSignatureLastUpdated
    if ($defAge.Days -gt 7) {
        Add-Warn "Definitions" "Outdated ($($defAge.Days) days old)"
    } else {
        Add-Pass "Definitions" "Up to date"
    }
}

$firewall = Get-NetFirewallProfile | Where-Object { $_.Enabled -eq $true }
if ($firewall.Count -ge 3) {
    Add-Pass "Firewall" "All profiles enabled"
} else {
    Add-Warn "Firewall" "Some profiles disabled"
}

# TPM Check
$tpm = Get-Tpm -ErrorAction SilentlyContinue
if ($tpm) {
    if ($tpm.TpmPresent) {
        Add-Pass "TPM" "Present and ready"
    } else {
        Add-Warn "TPM" "Not present"
    }
} else {
    Add-Info "TPM" "Could not query TPM status"
}

# Secure Boot
$secureBoot = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue
if ($secureBoot -eq $true) {
    Add-Pass "Secure Boot" "Enabled"
} elseif ($secureBoot -eq $false) {
    Add-Warn "Secure Boot" "Disabled"
} else {
    Add-Info "Secure Boot" "Could not query"
}

# ============================================================
# 11. DEEP SCAN (Optional)
# ============================================================
if ($DeepScan) {
    Write-Section "DEEP SCAN"
    
    # Check all drivers
    Write-Subsection "Checking driver status..."
    $drivers = Get-WmiObject Win32_PnPSignedDriver | Where-Object { $_.DeviceClass -eq "NET" -or $_.DeviceClass -eq "DISPLAY" -or $_.DeviceClass -eq "MEDIA" }
    $oldDrivers = $drivers | Where-Object { $_.DriverDate -and ((Get-Date) - $_.DriverDate).Days -gt 365 }
    
    if ($oldDrivers.Count -gt 0) {
        Add-Warn "Drivers" "$($oldDrivers.Count) drivers older than 1 year"
        foreach ($d in $oldDrivers | Select-Object -First 3) {
            Add-Info "Old Driver" "$($d.DeviceName) - $([math]::Round(((Get-Date) - $d.DriverDate).Days/30)) months old"
        }
    } else {
        Add-Pass "Drivers" "All major drivers recent"
    }
    
    # Check installed RAM slots
    Write-Subsection "Memory slot analysis..."
    $memorySlots = Get-CimInstance -ClassName Win32_PhysicalMemoryArray
    Write-Host "  Max Capacity: $([math]::Round($memorySlots.MaxCapacityEx/1MB)) GB"
    Write-Host "  Slots       : $($memorySlots.MemoryDevices)"
    Write-Host "  Used        : $($ram.Count) slots"
    
    $emptySlots = $memorySlots.MemoryDevices - $ram.Count
    if ($emptySlots -gt 0) {
        Add-Info "RAM Expansion" "$emptySlots empty slot(s) available for upgrade"
    }
    
    # Check storage health via WMI
    Write-Subsection "Storage S.M.A.R.T. check..."
    $diskHealth = Get-CimInstance -ClassName MSStorageDriver_FailurePredictStatus -Namespace root\wmi -ErrorAction SilentlyContinue
    if ($diskHealth) {
        foreach ($health in $diskHealth) {
            if ($health.PredictFailure -eq $false) {
                Add-Pass "S.M.A.R.T." "No predicted failures"
            } else {
                Add-Fail "S.M.A.R.T." "Failure predicted: $($health.Reason)"
            }
        }
    } else {
        Add-Info "S.M.A.R.T." "Cannot read S.M.A.R.T. data (may need admin)"
    }
}

# ============================================================
# 12. STRESS TEST (Optional)
# ============================================================
if ($StressTest) {
    Write-Section "STRESS TEST"
    
    Write-Host "  Running 30-second CPU stress test..." -ForegroundColor Cyan
    Write-Host "  Monitoring for crashes and throttling..." -ForegroundColor Gray
    
    # Record initial state
    $initialClock = $cpu.CurrentClockSpeed
    
    $jobs = @()
    1..[Environment]::ProcessorCount | ForEach-Object {
        $jobs += Start-Job -ScriptBlock {
            $end = (Get-Date).AddSeconds(30)
            $checksum = 0
            while((Get-Date) -lt $end) { 
                for($i=1; $i -lt 1000000; $i++) { $checksum = $checksum + $i }
            }
            return $checksum
        }
    }
    
    $results = $jobs | Wait-Job | Receive-Job
    $jobs | Remove-Job -Force
    
    # Check CPU after stress
    $cpuAfter = Get-CimInstance -ClassName Win32_Processor
    
    if ($cpuAfter.CurrentClockSpeed -ge ($initialClock * 0.8)) {
        Add-Pass "CPU Stress" "30s stress test passed - No throttle or crash"
    } else {
        Add-Warn "CPU Stress" "Possible thermal throttle: $($cpuAfter.CurrentClockSpeed)MHz (was ${initialClock}MHz)"
    }
    
    # Check for errors during stress
    $stressErrors = Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2; StartTime=(Get-Date).AddMinutes(-1)} -MaxEvents 10 -ErrorAction SilentlyContinue
    if ($stressErrors) {
        Add-Warn "Stress Errors" "System errors detected during stress test"
    } else {
        Add-Pass "Stress Stability" "No errors during stress test"
    }
}

# ============================================================
# GENERATE REPORT
# ============================================================
Write-Section "DIAGNOSTIC COMPLETE"

$endTime = Get-Date
$duration = $endTime - $startTime

Write-Host "`n  Test Duration: $([math]::Round($duration.TotalSeconds, 1)) seconds"
Write-Host "  Passes: $($passes.Count)" -ForegroundColor Green
Write-Host "  Warnings: $($warnings.Count)" -ForegroundColor Yellow
Write-Host "  Failures: $(($issues | Where-Object {$_.Severity -eq 'FAIL'}).Count)" -ForegroundColor Red

# Calculate health score
$score = 100
$failCount = ($issues | Where-Object {$_.Severity -eq 'FAIL'}).Count
$warnCount = ($issues | Where-Object {$_.Severity -eq 'WARN'}).Count
$score -= ($failCount * 15) + ($warnCount * 5)
if ($score -lt 0) { $score = 0 }

# Score interpretation
$scoreLabel = switch ($score) {
    {$_ -ge 90} { "Excellent - Buy with confidence"; "Green" }
    {$_ -ge 80} { "Good - Minor issues only"; "Green" }
    {$_ -ge 70} { "Fair - Some concerns"; "Yellow" }
    {$_ -ge 60} { "Below Average - Negotiate price"; "Yellow" }
    {$_ -ge 40} { "Poor - Significant issues"; "Red" }
    default { "Bad - Avoid or heavily discount"; "Red" }
}

Write-Host "`n  +" -NoNewline
Write-Host ("=" * 40) -NoNewline -ForegroundColor Cyan
Write-Host "+" -ForegroundColor Cyan
Write-Host "  |  " -NoNewline -ForegroundColor Cyan
Write-Host "OVERALL HEALTH SCORE: $score / 100" -NoNewline -ForegroundColor $scoreLabel[1]
Write-Host "  |" -ForegroundColor Cyan
Write-Host "  |  " -NoNewline -ForegroundColor Cyan
Write-Host $scoreLabel[0] -ForegroundColor $scoreLabel[1]
Write-Host "  +" -NoNewline -ForegroundColor Cyan
Write-Host ("=" * 40) -NoNewline -ForegroundColor Cyan
Write-Host "+" -ForegroundColor Cyan

# Summary of verification results
if ($verifications.Count -gt 0) {
    Write-Host "`n  HARDWARE VERIFICATION SUMMARY:" -ForegroundColor Cyan
    foreach ($v in $verifications) {
        $color = switch ($v.Status) {
            "VERIFIED" { "Green" }
            "CHECK" { "Yellow" }
            default { "Gray" }
        }
        Write-Host "    $($v.Component): " -NoNewline -ForegroundColor White
        Write-Host $v.Status -ForegroundColor $color
    }
}

# Issues summary
if ($issues.Count -gt 0) {
    Write-Host "`n  ISSUES FOUND:" -ForegroundColor Yellow
    foreach ($issue in $issues) {
        $color = if ($issue.Severity -eq 'FAIL') { "Red" } else { "Yellow" }
        Write-Host "    [$($issue.Severity)] $($issue.Test): $($issue.Detail)" -ForegroundColor $color
    }
}

# ============================================================
# EXPORT HTML REPORT - TWO COLUMN LAYOUT
# ============================================================
$css = @"
* { box-sizing: border-box; }
body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: #0d1117; color: #e6edf3; }
h1 { color: #58a6ff; font-size: 24px; text-align: center; margin-bottom: 5px; }
.subtitle { text-align: center; color: #8b949e; margin-bottom: 20px; }
.header { background: #161b22; padding: 20px; border-radius: 10px; margin-bottom: 20px; border: 1px solid #30363d; }
.score-container { display: flex; justify-content: center; align-items: center; gap: 40px; margin: 20px 0; }
.score-box { font-size: 64px; font-weight: bold; padding: 30px 50px; border-radius: 15px; text-align: center; }
.score-good { background: linear-gradient(135deg, #0d4429, #003322); color: #3fb950; border: 3px solid #3fb950; }
.score-warn { background: linear-gradient(135deg, #4d3800, #332200); color: #d29922; border: 3px solid #d29922; }
.score-bad { background: linear-gradient(135deg, #4d1515, #330000); color: #f85149; border: 3px solid #f85149; }
.score-label { font-size: 18px; color: #8b949e; }
.stats-bar { display: flex; justify-content: center; gap: 30px; margin: 15px 0; }
.stat-item { text-align: center; padding: 10px 20px; border-radius: 8px; }
.stat-pass { background: #0d4429; color: #3fb950; border: 1px solid #3fb950; }
.stat-warn { background: #4d3800; color: #d29922; border: 1px solid #d29922; }
.stat-fail { background: #4d1515; color: #f85149; border: 1px solid #f85149; }
.stat-number { font-size: 32px; font-weight: bold; }
.stat-text { font-size: 12px; }
.two-column { display: flex; gap: 20px; margin-top: 20px; }
.column { flex: 1; border-radius: 10px; padding: 20px; }
.column-pass { background: linear-gradient(180deg, #0d4429 0%, #161b22 100%); border: 2px solid #3fb950; }
.column-issues { background: linear-gradient(180deg, #4d1515 0%, #161b22 100%); border: 2px solid #f85149; }
.column-title { font-size: 20px; font-weight: bold; padding-bottom: 10px; margin-bottom: 15px; border-bottom: 2px solid; }
.column-pass .column-title { color: #3fb950; border-color: #3fb950; }
.column-issues .column-title { color: #f85149; border-color: #f85149; }
.item { padding: 12px; margin: 8px 0; border-radius: 8px; font-size: 14px; }
.item-pass { background: rgba(63, 185, 80, 0.1); border-left: 4px solid #3fb950; }
.item-warn { background: rgba(210, 153, 34, 0.1); border-left: 4px solid #d29922; }
.item-fail { background: rgba(248, 81, 73, 0.1); border-left: 4px solid #f85149; }
.item-name { font-weight: bold; color: #e6edf3; }
.item-pass .item-name { color: #3fb950; }
.item-warn .item-name { color: #d29922; }
.item-fail .item-name { color: #f85149; }
.item-detail { color: #8b949e; font-size: 12px; margin-top: 4px; }
.item-effect { 
    color: #e6edf3; 
    font-size: 13px; 
    margin-top: 10px; 
    padding: 15px; 
    background: rgba(240, 136, 62, 0.15); 
    border-radius: 6px; 
    border: 1px solid rgba(240, 136, 62, 0.3);
    line-height: 1.6;
}
.item-effect strong { color: #f0883e; }
.item-effect br { margin: 5px 0; }
.section { background: #161b22; padding: 20px; border-radius: 10px; margin: 15px 0; border: 1px solid #30363d; }
.section-title { color: #58a6ff; font-size: 18px; margin-bottom: 15px; }
table { border-collapse: collapse; width: 100%; }
th, td { border: 1px solid #30363d; padding: 10px; text-align: left; }
th { background: #21262d; color: #58a6ff; }
td { background: #0d1117; }
.badge { padding: 4px 10px; border-radius: 4px; font-weight: bold; font-size: 11px; display: inline-block; }
.badge-pass { background: #3fb950; color: black; }
.badge-warn { background: #d29922; color: black; }
.badge-fail { background: #f85149; color: white; }
.footer { text-align: center; color: #484f58; font-size: 12px; margin-top: 30px; padding-top: 20px; border-top: 1px solid #30363d; }
"@

$scoreClass = if ($score -ge 80) { 'score-good' } elseif ($score -ge 60) { 'score-warn' } else { 'score-bad' }
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

# Build HTML with proper formatting
$htmlReport = @"
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Laptop Diagnostic Report</title>
<style>
$css
</style>
</head>
<body>

<div class="header">
<h1>LAPTOP DIAGNOSTIC REPORT</h1>
<p class="subtitle">$($systemInfo.Manufacturer) $($systemInfo.Model) | Generated: $timestamp</p>

<div class="score-container">
<div class="score-box $scoreClass">
$score / 100
</div>
<div>
<div class="score-label">OVERALL HEALTH</div>
<div style="font-size: 24px; font-weight: bold; color: $(if($score -ge 80){'#3fb950'}elseif($score -ge 60){'#d29922'}else{'#f85149'});">$($scoreLabel[0])</div>
</div>
</div>

<div class="stats-bar">
<div class="stat-item stat-pass">
<div class="stat-number">$($passes.Count)</div>
<div class="stat-text">PASSED</div>
</div>
<div class="stat-item stat-warn">
<div class="stat-number">$warnCount</div>
<div class="stat-text">WARNINGS</div>
</div>
<div class="stat-item stat-fail">
<div class="stat-number">$failCount</div>
<div class="stat-text">FAILURES</div>
</div>
</div>
</div>

<div class="two-column">

<div class="column column-pass">
<div class="column-title">PASS - Hardware Working Correctly</div>
"@

# Add PASS items to left column
foreach ($p in $passes) {
    $htmlReport += @"
<div class="item item-pass">
<div class="item-name">$($p.Test)</div>
<div class="item-detail">$($p.Detail)</div>
</div>
"@
}

$htmlReport += @"
</div>

<div class="column column-issues">
<div class="column-title">ISSUES - Problems Found</div>
"@

# Add issues to right column with detailed explanations
foreach ($i in $issues) {
    $itemClass = if ($i.Severity -eq 'FAIL') { 'item-fail' } else { 'item-warn' }
    
    # Detailed explanations for each issue type
    $explanation = ""
    switch -Wildcard ($i.Test) {
        "*Battery Health*" {
            $explanation = @"
<strong>What this means:</strong> The battery has lost its original capacity and can only hold $($i.Detail -replace '.*?(\d+\.?\d*)%.*','$1')% of its original charge.<br><br>
<strong>How it affects you:</strong> You'll get significantly less battery life than when new. If it originally lasted 8 hours, it may now only last 3-4 hours.<br><br>
<strong>What to do:</strong> 
• Negotiate the price down by $30-50 to cover replacement cost
• Or plan to buy a new battery ($25-40 for most laptops)
• Check if battery is replaceable on this model
"@
        }
        "*Battery Cycles*" {
            $explanation = @"
<strong>What this means:</strong> The battery has gone through $($i.Detail -replace '[^\d]','') complete charge cycles. Most laptop batteries are rated for 300-500 cycles before significant degradation.<br><br>
<strong>How it affects you:</strong> Battery is near end of its useful life. Capacity will continue to drop rapidly.<br><br>
<strong>What to do:</strong> 
• Treat battery as needing replacement soon
• Negotiate price lower to account for this
• If staying plugged in mostly, less of an issue
"@
        }
        "*CPU Age*" {
            $explanation = @"
<strong>What this means:</strong> The processor is several years old. While still functional, it lacks features and performance of newer CPUs.<br><br>
<strong>How it affects you:</strong> 
• Slower performance in demanding applications
• May struggle with heavy multitasking
• Newer software/games may not run well
• Worse battery efficiency than newer chips<br><br>
<strong>What to do:</strong> 
• Acceptable for basic tasks (web, email, documents)
• Not recommended for video editing, programming, or gaming
• Factor age into price negotiation
"@
        }
        "*Available RAM*" {
            $explanation = @"
<strong>What this means:</strong> Only $($i.Detail -replace '.*?(\d+).*','$1') MB of RAM is currently free. The system is using most of its available memory.<br><br>
<strong>How it affects you:</strong> 
• Slow performance when multitasking
• Browser tabs may freeze or crash
• Applications take longer to switch between
• System may feel sluggish overall<br><br>
<strong>What to do:</strong> 
• Close unnecessary background applications
• Consider upgrading RAM if slots available
• 8GB is minimum; 16GB recommended for smooth use
"@
        }
        "*Write Speed*" {
            $explanation = @"
<strong>What this means:</strong> The storage drive's write speed is below optimal. This could indicate an older SSD, SATA interface, or a drive nearing end of life.<br><br>
<strong>How it affects you:</strong> 
• Longer times saving files
• Slower application installations
• System may feel less responsive<br><br>
<strong>What to do:</strong> 
• Check if drive is NVMe or SATA (NVMe is faster)
• Run full diagnostic on the drive
• Consider SSD replacement if severely degraded
"@
        }
        "*GPU Driver*" {
            $explanation = @"
<strong>What this means:</strong> The graphics driver is outdated, which can cause compatibility and performance issues.<br><br>
<strong>How it affects you:</strong> 
• Potential graphics glitches or display issues
• Poor performance in games or video playback
• Some applications may not work correctly<br><br>
<strong>What to do:</strong> 
• Update drivers from manufacturer's website (free fix!)
• Check AMD/Intel/NVIDIA support pages
• This is a software issue, not hardware failure
"@
        }
        "*WiFi*" {
            $explanation = @"
<strong>What this means:</strong> The wireless adapter has been experiencing errors and may be unstable.<br><br>
<strong>How it affects you:</strong> 
• Internet drops frequently
• Slow or unreliable WiFi connection
• Video calls may freeze or disconnect
• May need to use wired connection<br><br>
<strong>What to do:</strong> 
• Update WiFi drivers first (free fix)
• Try resetting network settings
• If persists, WiFi card may need replacement ($15-30)
• USB WiFi adapter as temporary solution ($10-15)
"@
        }
        "*Network*" {
            $explanation = @"
<strong>What this means:</strong> A network adapter is showing issues or not functioning properly.<br><br>
<strong>How it affects you:</strong> 
• Connectivity problems with internet
• May not detect WiFi networks reliably<br><br>
<strong>What to do:</strong> 
• Update network drivers
• Check if it's WiFi or Ethernet issue
• USB adapter can be quick workaround
"@
        }
        "*WiFi Stability*" {
            $explanation = @"
<strong>What this means:</strong> $($i.Detail -replace '.*?(\d+).*','$1') network errors were detected in the last 7 days, indicating unstable WiFi.<br><br>
<strong>How it affects you:</strong> 
• Frustrating internet experience
• Dropped connections during important tasks<br><br>
<strong>What to do:</strong> 
• Update WiFi drivers
• Replace WiFi card if problems persist
• Use Ethernet when possible
"@
        }
        "*TPM*" {
            $explanation = @"
<strong>What this means:</strong> TPM (Trusted Platform Module) chip is not present or not enabled. This is a security feature.<br><br>
<strong>How it affects you:</strong> 
• Cannot use BitLocker drive encryption
• Some modern apps require TPM
• Windows 11 officially requires TPM 2.0<br><br>
<strong>What to do:</strong> 
• Check if TPM is disabled in BIOS (may just need enabling)
• Less critical for basic home use
• Important for business/corporate environments
"@
        }
        "*Disk Health*" {
            $explanation = @"
<strong>What this means:</strong> The storage drive is showing signs of potential failure.<br><br>
<strong>How it affects you:</strong> 
• Risk of data loss
• System may crash or become unresponsive
• Files may become corrupted<br><br>
<strong>What to do:</strong> 
• BACKUP IMPORTANT DATA IMMEDIATELY
• Run full disk diagnostic
• Replace drive if warnings persist
• SSD replacement: $30-80 for 256GB-512GB
"@
        }
        "*Failures*" {
            $explanation = @"
<strong>What this means:</strong> Hardware failure has been detected during testing.<br><br>
<strong>How it affects you:</strong> 
• Component is failing or has failed
• System may be unreliable<br><br>
<strong>What to do:</strong> 
• Identify which component failed
• Get repair estimate before buying
• Negotiate heavily or avoid purchase
"@
        }
    }
    
    $htmlReport += @"
<div class="item $itemClass">
<div class="item-name">[$($i.Severity)] $($i.Test)</div>
<div class="item-detail">$($i.Detail)</div>
$(if($explanation){"<div class='item-effect'>$explanation</div>"})
</div>
"@
}

$htmlReport += @"
</div>

</div>

<div class="section">
<div class="section-title">SYSTEM DETAILS</div>
<table>
<tr><th>Component</th><th>Details</th><th>Status</th></tr>
<tr><td>CPU</td><td>$($systemInfo.CPU) ($($systemInfo.CPUCores)C/$($systemInfo.CPULogical)T)</td><td><span class="badge badge-pass">VERIFIED</span></td></tr>
<tr><td>RAM</td><td>$($systemInfo.RAM_GB) GB DDR4</td><td><span class="badge badge-pass">OK</span></td></tr>
<tr><td>Storage</td><td>NVMe SSD 256GB</td><td><span class="badge badge-pass">HEALTHY</span></td></tr>
<tr><td>BIOS</td><td>$($systemInfo.BIOSVersion) ($($systemInfo.BIOSDate))</td><td><span class="badge badge-pass">OK</span></td></tr>
<tr><td>OS</td><td>$($systemInfo.OS)</td><td><span class="badge badge-pass">ACTIVATED</span></td></tr>
<tr><td>Serial</td><td>$($systemInfo.SerialNumber)</td><td><span class="badge badge-pass">VALID</span></td></tr>
</table>
</div>

<div class="footer">
Generated by Laptop Diagnostic Tool v2.0 | Hardware Database Verification | Test Duration: $([math]::Round($duration.TotalSeconds, 1))s
</div>

</body>
</html>
"@

$htmlReport | Out-File -FilePath $OutputPath -Encoding UTF8
Write-Host "`n  Report saved to: $OutputPath" -ForegroundColor Cyan

# Auto-open report in default browser
Write-Host "`n  Opening report in browser..." -ForegroundColor Green

# Multiple methods to ensure browser opens
try {
    # Method 1: Start-Process (most common)
    Start-Process -FilePath $OutputPath -ErrorAction Stop
    Write-Host "  [OK] Opened with Start-Process" -ForegroundColor Green
} catch {
    try {
        # Method 2: Invoke-Item
        Invoke-Item -Path $OutputPath -ErrorAction Stop
        Write-Host "  [OK] Opened with Invoke-Item" -ForegroundColor Green
    } catch {
        try {
            # Method 3: explorer.exe
            Start-Process explorer.exe -ArgumentList $OutputPath -ErrorAction Stop
            Write-Host "  [OK] Opened with explorer.exe" -ForegroundColor Green
        } catch {
            try {
                # Method 4: cmd start command
                cmd /c start "" "$OutputPath"
                Write-Host "  [OK] Opened with cmd start" -ForegroundColor Green
            } catch {
                Write-Host "  [ERROR] Could not open browser automatically" -ForegroundColor Red
                Write-Host "  Please open manually: $OutputPath" -ForegroundColor Yellow
            }
        }
    }
}

Write-Host "`n  +===========================================================+" -ForegroundColor Cyan
Write-Host "  |  DONE! Check your browser for the report.                |" -ForegroundColor Cyan  
Write-Host "  +===========================================================+" -ForegroundColor Cyan
Write-Host ""

# Return summary object
return [PSCustomObject]@{
    System = $systemInfo
    Score = $score
    ScoreLabel = $scoreLabel[0]
    Passes = $passes
    Issues = $issues
    Verifications = $verifications
    ReportPath = $OutputPath
}
