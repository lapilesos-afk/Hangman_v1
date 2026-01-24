@echo off
setlocal enabledelayedexpansion
REM Hangman Full Stack Starter
echo ========================================
echo Hangman Game - Startup
echo ========================================
echo.
echo [1/2] Starting Backend...
start "Hangman Backend" cmd /k "start-backend.bat --no-pause"
echo [INFO] Waiting for backend to start on port 8080...
set WAIT_COUNT=0
:wait_backend
timeout /t 2 /nobreak >nul
REM Prüfe einfach ob Port 8080 verwendet wird (sprachunabhängig)
netstat -ano | findstr ":8080 " >nul 2>&1
if not errorlevel 1 goto backend_ready
set /a WAIT_COUNT+=1
if !WAIT_COUNT! GEQ 15 goto backend_timeout
echo [INFO] Still waiting... (attempt !WAIT_COUNT!/15)
goto wait_backend

:backend_timeout
echo [WARNING] Backend did not start within 30 seconds
echo [WARNING] Please check the Backend window for errors
goto end

:backend_ready
echo [OK] Backend is ready on: http://localhost:8080
echo.
echo [2/2] Starting Frontend...
echo.
REM Try npx http-server
where npx >nul 2>&1
if errorlevel 1 goto try_http_server
start "Hangman Frontend" cmd /k "npx http-server frontend -p 4200"
echo [INFO] Waiting for frontend to start (5 seconds)...
timeout /t 5 /nobreak >nul
echo [OK] Frontend started on: http://localhost:4200
echo.
echo Opening browser...
timeout /t 2 /nobreak >nul
start http://localhost:4200
goto end

:try_http_server
REM Try http-server
where http-server >nul 2>&1
if errorlevel 1 goto no_server
start "Hangman Frontend" cmd /k "http-server frontend -p 4200"
echo [INFO] Waiting for frontend to start (5 seconds)...
timeout /t 5 /nobreak >nul
echo [OK] Frontend started on: http://localhost:4200
echo.
echo Opening browser...
timeout /t 2 /nobreak >nul
start http://localhost:4200
goto end

:no_server
echo [WARNING] No Node.js web server found
echo Please install: npm install -g http-server
echo.

:end
pause
