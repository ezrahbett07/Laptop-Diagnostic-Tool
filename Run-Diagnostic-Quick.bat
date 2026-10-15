@echo off
echo.
echo ========================================
echo   Laptop Diagnostic Tool - Quick Test
echo ========================================
echo.
echo Requesting Administrator privileges...
echo.

:: Request administrator privileges
powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0LaptopDiagnosticTool.ps1\" -QuickTest' -Verb RunAs"

echo Done! Check your desktop for the HTML report.
pause
