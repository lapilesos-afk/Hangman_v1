@echo off
REM ============================================================================
REM Hangman Game - Stop Services Script
REM Beendet Backend und Frontend Services
REM ============================================================================

setlocal enabledelayedexpansion

cls
echo.
echo ============================================================================
echo HANGMAN - Stop Services
echo ============================================================================
echo.

echo Stopping services...
echo.

REM Kill processes by port (Windows 10+)
echo [1/2] Stopping Backend (port 8080)...
for /f "tokens=5" %%i in ('netstat -ano ^| findstr :8080') do (
    taskkill /PID %%i /F >nul 2>&1
    if errorlevel 1 (
        echo       [INFO] No process on port 8080
    ) else (
        echo       [OK] Backend stopped
    )
)

echo [2/2] Stopping Frontend (port 4200)...
for /f "tokens=5" %%i in ('netstat -ano ^| findstr :4200') do (
    taskkill /PID %%i /F >nul 2>&1
    if errorlevel 1 (
        echo       [INFO] No process on port 4200
    ) else (
        echo       [OK] Frontend stopped
    )
)

REM Alternative: Kill by window name
taskkill /FI "WINDOWTITLE eq Hangman*" /T /F >nul 2>&1

echo.
echo ============================================================================
echo All services stopped.
echo ============================================================================
echo.
pause
