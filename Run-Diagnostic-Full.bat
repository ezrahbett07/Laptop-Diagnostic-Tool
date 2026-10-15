@echo off
echo.
echo ================================================
echo   Laptop Diagnostic Tool - FULL STRESS TEST
echo ================================================
echo.
echo This will run CPU stress test (30 seconds).
echo Make sure laptop is plugged in!
echo.
echo Requesting Administrator privileges...
echo.

:: Request administrator privileges with stress test
powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0LaptopDiagnosticTool.ps1\" -StressTest' -Verb RunAs"

echo Done! Check your desktop for the HTML report.
pause
