@echo off
REM ============================================================================
REM Hangman Game - Local Startup Script
REM Starts Backend (Spring Boot) and Frontend (Angular) without Docker
REM ============================================================================

setlocal enabledelayedexpansion

REM Colors for output (Windows 10+ supports ANSI)
for /F %%A in ('copy /Z "%~f0" nul') do set "BS=%%A"

echo.
echo ============================================================================
echo Hangman Game - Local Startup
echo ============================================================================
echo.

REM Check if Java is installed
echo [1/5] Checking Java installation...
java -version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Java is not installed or not in PATH
    echo Please install Java 17 or later from https://www.oracle.com/java/technologies/
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('java -version 2^>^&1 ^| findstr /R "version"') do set JAVA_VERSION=%%i
echo [OK] %JAVA_VERSION%
echo.

REM Check if Node.js/npm is installed
echo [2/5] Checking Node.js/npm installation...
where npm >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js/npm is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)
echo [OK] npm is installed
echo.

REM Check if Maven is installed
echo [3/5] Checking Maven installation...
where mvn >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Maven is not installed or not in PATH
    echo Please install Maven from https://maven.apache.org/
    pause
    exit /b 1
)
echo [OK] Maven is installed
echo.

REM Get the script directory
set SCRIPT_DIR=%~dp0
set BACKEND_DIR=%SCRIPT_DIR%backend
set FRONTEND_DIR=%SCRIPT_DIR%

REM Kill any existing processes on ports 8080 and 4200
echo [PREP] Cleaning up ports...
for /f "tokens=5" %%a in ('netstat -aon ^| find ":8080"') do taskkill /PID %%a /F >nul 2>&1
for /f "tokens=5" %%a in ('netstat -aon ^| find ":4200"') do taskkill /PID %%a /F >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1
echo.

echo [4/5] Building Backend (Spring Boot)...
echo.
cd /d "%BACKEND_DIR%"
call mvn clean package -DskipTests -q
if errorlevel 1 (
    echo [ERROR] Backend build failed
    pause
    exit /b 1
)
echo [OK] Backend built successfully
echo.

REM Find the generated JAR file
echo [5/5] Preparing Frontend...
cd /d "%FRONTEND_DIR%"
if not exist "node_modules" (
    echo Installing npm dependencies...
    call npm install -q
)
echo [OK] Frontend ready
echo.

REM Start backend in a separate window
echo ============================================================================
echo Starting Backend (Spring Boot on port 8080)...
echo ============================================================================
start "Hangman Backend" cmd /k "cd /d "%BACKEND_DIR%" && mvn spring-boot:run"

REM Wait for backend to start
echo.
echo Waiting for backend to start (10 seconds)...
timeout /t 10 /nobreak

REM Start frontend in a separate window
echo.
echo ============================================================================
echo Starting Frontend (Angular on port 4200)...
echo ============================================================================
start "Hangman Frontend" cmd /k "cd /d "%FRONTEND_DIR%" && node_modules\.bin\ng serve"

REM Wait a bit for frontend to start
timeout /t 5 /nobreak

echo.
echo ============================================================================
echo SUCCESS! Application is starting...
echo ============================================================================
echo.
echo Frontend:  http://localhost:4200
echo Backend:   http://localhost:8080
echo API Docs:  http://localhost:8080/api (if Swagger is configured)
echo.
echo Press any key to close this window...
pause
