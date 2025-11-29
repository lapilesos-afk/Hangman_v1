@echo off
REM ============================================================================
REM Hangman Game - Windows Context Menu Integration
REM Fügt "Start Hangman" zum Windows-Kontextmenü hinzu
REM ============================================================================

setlocal enabledelayedexpansion

cls
echo.
echo ============================================================================
echo Windows Context Menu Integration Setup
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

set SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%
set STARTUP_BATCH=%SCRIPT_DIR%\startup.bat

echo [1/3] Creating registry entries...

REM Create registry entry for folder context menu
reg add "HKCU\Software\Classes\Folder\shell\Hangman" /ve /d "Start Hangman" /f >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Failed to create registry entry
    pause
    exit /b 1
)
echo [OK] Created context menu entry

echo [2/3] Setting up command...
reg add "HKCU\Software\Classes\Folder\shell\Hangman\command" /ve /d "cmd /k \"%STARTUP_BATCH%\"" /f >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Failed to set command
    pause
    exit /b 1
)
echo [OK] Command configured

echo [3/3] Setting icon...
reg add "HKCU\Software\Classes\Folder\shell\Hangman" /v "Icon" /d "%SCRIPT_DIR%\hangman-icon.ico" /f >nul 2>&1
echo [OK] Icon set

echo.
echo ============================================================================
echo SUCCESS!
echo ============================================================================
echo.
echo You can now:
echo   1. Open the Hangman_v1 folder
echo   2. Right-click in empty space
echo   3. Select "Start Hangman"
echo.
echo To remove this integration, run: cleanup-context-menu.bat
echo.
pause
