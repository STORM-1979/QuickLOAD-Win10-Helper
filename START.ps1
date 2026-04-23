# QuickLOAD Win10 Helper
# Registers VB5/VB6 ActiveX components needed for QuickLOAD 3.8 on Windows 10/11.
# Run as Administrator.
#
# Usage:
#   1. Disable Avast (if installed) temporarily
#   2. Put OCX/DLL files from the ISO in the same folder as this script, OR mount the ISO
#   3. Run this script as admin — it registers components and optionally launches setup
#
# After install, copy Russian language files from lan_russian/ to
# %USERPROFILE%\Documents\QuickLOAD\lan\ and use File → Set language to → Russian.

$ErrorActionPreference = "Continue"
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host " ============================================" -ForegroundColor Cyan
Write-Host "  QuickLOAD 3.8 — Windows 10/11 Helper" -ForegroundColor Cyan
Write-Host " ============================================" -ForegroundColor Cyan
Write-Host ""

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "  Not running as administrator." -ForegroundColor Red
    Write-Host "  Right-click START.cmd → Run as administrator." -ForegroundColor Yellow
    Read-Host "  Press ENTER to exit"
    exit 1
}

# Register common VB5/VB6 ActiveX components (MSCOMCTL.OCX, COMDLG32.OCX, SComm32.ocx)
# These files should either be in the same folder as this script, or already installed in SysWOW64.
$sys = Join-Path $env:SystemRoot "SysWOW64"
$regsvr = Join-Path $sys "regsvr32.exe"

Write-Host "  Registering VB runtime components..." -ForegroundColor Cyan
foreach ($f in "MSCOMCTL.OCX","COMDLG32.OCX","SComm32.ocx","MSVBVM50.DLL") {
    # Try folder next to script first
    $local = Join-Path $dir $f
    if (Test-Path -LiteralPath $local) {
        Copy-Item -LiteralPath $local -Destination (Join-Path $sys $f) -Force -ErrorAction SilentlyContinue
    }
    $target = Join-Path $sys $f
    if (Test-Path -LiteralPath $target) {
        & $regsvr /s $target
        Write-Host "    [OK] $f registered"
    } else {
        Write-Host "    [!!] $f missing — put the ISO file next to this script" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "  Components registered." -ForegroundColor Green
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor Cyan
Write-Host "    1. Disable Avast temporarily (it blocks VB5 setup)"
Write-Host "    2. Mount QuickLoad_3_8.iso (right-click → Mount)"
Write-Host "    3. Run SETUP.EXE from the mounted drive as admin"
Write-Host "    4. Walk through the installer (any name/company will do)"
Write-Host "    5. After install, copy lan_russian\*.LAN/.TIP files to:"
Write-Host "         %USERPROFILE%\Documents\QuickLOAD\lan\"
Write-Host "    6. Launch QLOADFW.EXE from the installed location"
Write-Host "       File → Set language to → Russian"
Write-Host ""
Read-Host "  Press ENTER to exit"
