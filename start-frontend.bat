@echo off
REM ============================================================================
REM Hangman Frontend Starter (Angular Dev Server) - Windows
REM ============================================================================
REM
REM Startet das Angular Frontend auf Port 4200
REM
REM Verwendung: .\start-frontend.bat
REM URL: http://localhost:4200
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ========================================================
echo  Hangman Frontend - Angular Dev Server
echo ========================================================
echo.

REM Überprüfe Node.js Installation
echo [1/2] Checking Node.js installation...
where node >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js is not installed!
    echo [INFO] Download: https://nodejs.org/
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('node --version 2^>^&1') do (
    echo [OK] Node.js found: %%i
)

echo.
echo [2/2] Starting Angular Dev Server...
echo [INFO] Frontend will be available at: http://localhost:4200
echo [INFO] Backend expected at: http://localhost:8080
echo [INFO] Press Ctrl+C to stop
echo.

REM Starte Angular Dev Server
call npm start

pause

