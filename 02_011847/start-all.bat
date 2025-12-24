@echo off
REM Hangman Full Stack Starter
echo ========================================
echo Hangman Game - Startup
echo ========================================
echo.
echo [1/2] Starting Backend...
start "Hangman Backend" cmd /k "start-backend.bat"
timeout /t 3 /nobreak >nul
echo [OK] Backend started on: http://localhost:8080
echo.
echo [2/2] Starting Frontend...
echo.
REM Try npx http-server
where npx >nul 2^>^&1
if %ERRORLEVEL% EQU 0 (
    start "Hangman Frontend" cmd /k "npx http-server frontend -p 4200"
    echo [INFO] Waiting for servers to start...
    timeout /t 8 /nobreak >nul
    echo [OK] Frontend started on: http://localhost:4200
    echo.
    echo Opening browser...
    start http://localhost:4200
    goto end
)

REM Try http-server
where http-server >nul 2^>^&1
if %ERRORLEVEL% EQU 0 (
    start "Hangman Frontend" cmd /k "http-server frontend -p 4200"
    echo [INFO] Waiting for servers to start...
    timeout /t 8 /nobreak >nul
    echo [OK] Frontend started on: http://localhost:4200
    echo.
    echo Opening browser...
    start http://localhost:4200
    goto end
)

echo [WARNING] No Node.js web server found
echo Please install: npm install -g http-server
echo.
:end
pause
