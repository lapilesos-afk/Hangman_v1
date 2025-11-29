@echo off
REM ============================================================================
REM Hangman Game - Remove Windows Context Menu Integration
REM ============================================================================

setlocal enabledelayedexpansion

cls
echo.
echo ============================================================================
echo Windows Context Menu Integration Cleanup
echo ============================================================================
echo.

REM Check for admin rights
net session >nul 2>&1
if errorlevel 1 (
    echo [ERROR] This script requires Administrator privileges!
    echo.
    echo Please run as Administrator:
    echo   1. Right-click on this file
    echo   2. Select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo [1/1] Removing registry entries...

reg delete "HKCU\Software\Classes\Folder\shell\Hangman" /f >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Registry entries not found or already removed
) else (
    echo [OK] Context menu integration removed
)

echo.
echo ============================================================================
echo Done!
echo ============================================================================
echo.
pause
