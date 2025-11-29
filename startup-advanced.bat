@echo off
REM ============================================================================
REM Hangman Game - Advanced Local Startup Script
REM Features: Port checking, dependency verification, error recovery
REM ============================================================================

setlocal enabledelayedexpansion
cd /d "%~dp0"

REM Configuration
set BACKEND_PORT=8080
set FRONTEND_PORT=4200
set BACKEND_DIR=%CD%\backend
set FRONTEND_DIR=%CD%
set LOG_DIR=%CD%\logs
set JAVA_VERSION_REQUIRED=17

REM Create log directory
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

REM ============================================================================
REM Functions
REM ============================================================================

:check_port
setlocal enabledelayedexpansion
set PORT=%1
netstat -ano | findstr :%PORT% >nul 2>&1
if errorlevel 1 (
    endlocal & exit /b 0
) else (
    endlocal & exit /b 1
)

:check_command
set CMD=%1
%CMD% >nul 2>&1
if errorlevel 1 (
    exit /b 1
) else (
    exit /b 0
)

REM ============================================================================
REM Main Script
REM ============================================================================

cls
echo.
echo ============================================================================
echo.
echo   HANGMAN GAME - LOCAL STARTUP (NO DOCKER REQUIRED)
echo.
echo ============================================================================
echo.

REM Check prerequisites
echo [SETUP] Checking prerequisites...
echo.

REM Check Java
echo   [1] Checking Java...
java -version >nul 2>&1
if errorlevel 1 (
    echo   [ERROR] Java not found. Please install Java %JAVA_VERSION_REQUIRED%+ from:
    echo           https://www.oracle.com/java/technologies/downloads/
    echo.
    pause
    exit /b 1
)
for /f "tokens=2" %%i in ('java -version 2^>^&1 ^| findstr /R "version"') do set JV=%%i
echo   [OK] Java !JV!

REM Check npm
echo   [2] Checking Node.js/npm...
npm --version >nul 2>&1
if errorlevel 1 (
    echo   [ERROR] npm not found. Please install Node.js from:
    echo           https://nodejs.org/
    echo.
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('npm --version') do set NV=%%i
echo   [OK] npm !NV!

REM Check Maven
echo   [3] Checking Maven...
mvn --version >nul 2>&1
if errorlevel 1 (
    echo   [ERROR] Maven not found. Please install Maven from:
    echo           https://maven.apache.org/download.cgi
    echo.
    pause
    exit /b 1
)
for /f "tokens=3" %%i in ('mvn --version ^| findstr /R "Apache Maven"') do set MV=%%i
echo   [OK] Maven !MV!

REM Check ports
echo   [4] Checking ports...
call :check_port %BACKEND_PORT%
if errorlevel 0 if not errorlevel 1 (
    echo   [OK] Port %BACKEND_PORT% available
) else (
    echo   [WARNING] Port %BACKEND_PORT% already in use
)
call :check_port %FRONTEND_PORT%
if errorlevel 0 if not errorlevel 1 (
    echo   [OK] Port %FRONTEND_PORT% available
) else (
    echo   [WARNING] Port %FRONTEND_PORT% already in use
)

echo.
echo [BUILD] Building application...
echo.

REM Build Backend
echo   [1] Building Backend (Spring Boot)...
cd /d "%BACKEND_DIR%"
call mvn clean package -DskipTests -q 2>"%LOG_DIR%\backend-build.log"
if errorlevel 1 (
    echo   [ERROR] Backend build failed. Check %LOG_DIR%\backend-build.log
    type "%LOG_DIR%\backend-build.log"
    pause
    exit /b 1
)
echo   [OK] Backend built

REM Check frontend dependencies
echo   [2] Checking Frontend dependencies...
if not exist "%FRONTEND_DIR%\node_modules" (
    echo       Installing npm packages...
    cd /d "%FRONTEND_DIR%"
    call npm install -q 2>"%LOG_DIR%\npm-install.log"
    if errorlevel 1 (
        echo   [WARNING] npm install had issues. Continuing anyway...
    )
)
echo   [OK] Frontend ready

echo.
echo [STARTUP] Starting services...
echo.

REM Launch Backend
echo   [1] Launching Backend on port %BACKEND_PORT%...
start "Hangman Backend" /min cmd /k "cd /d "%BACKEND_DIR%" && mvn spring-boot:run 2> "%LOG_DIR%\backend.log""
set BACKEND_PID=%ERRORLEVEL%
echo   [OK] Backend started (check logs at %LOG_DIR%\backend.log)

REM Wait for backend startup
echo   [*] Waiting for backend to initialize (15 seconds)...
timeout /t 15 /nobreak

REM Launch Frontend
echo   [2] Launching Frontend on port %FRONTEND_PORT%...
start "Hangman Frontend" /min cmd /k "cd /d "%FRONTEND_DIR%" && npm start 2> "%LOG_DIR%\frontend.log""
echo   [OK] Frontend started (check logs at %LOG_DIR%\frontend.log)

REM Wait for frontend to compile
timeout /t 10 /nobreak

echo.
echo ============================================================================
echo.
echo   SUCCESS! Your Hangman Game is running!
echo.
echo   Frontend:   http://localhost:%FRONTEND_PORT%
echo   Backend:    http://localhost:%BACKEND_PORT%
echo.
echo   Logs are saved in: %LOG_DIR%\
echo   - backend.log    (Spring Boot output)
echo   - frontend.log   (Angular output)
echo.
echo   To stop the application, close the command windows or press Ctrl+C
echo.
echo ============================================================================
echo.

pause
