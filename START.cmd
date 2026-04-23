@echo off
chcp 65001 >nul
title QuickLOAD Win10 Helper

net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  QuickLOAD Win10 Helper
    echo  ======================
    echo.
    echo  This script must run as Administrator.
    echo  Right-click START.cmd and choose "Run as administrator".
    echo.
    pause
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0START.ps1"
pause
