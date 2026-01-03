@echo off
REM ============================================================================
REM Hangman Game - Dependency Check Script
REM ============================================================================

setlocal

cls
echo.
echo ============================================================================
echo HANGMAN - System Requirements Check
echo ============================================================================
echo.

set "ERRORS=0"
set "WARNINGS=0"

REM Check Java
echo [CHECK] Java Development Kit (JDK)
where java >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Java is NOT installed
    set "ERRORS=1"
) else (
    echo [OK]    Java is installed
)
echo.

REM Check Maven
echo [CHECK] Apache Maven
where mvn >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Maven is NOT installed
    if "!ERRORS!"=="0" set "ERRORS=1"
) else (
    echo [OK]    Maven is installed
)
echo.

REM Check Node.js
echo [CHECK] Node.js
where node >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js is NOT installed
    if "!ERRORS!"=="0" set "ERRORS=1"
) else (
    echo [OK]    Node.js is installed
)
echo.

REM Check npm
echo [CHECK] npm
where npm >nul 2>&1
if errorlevel 1 (
    echo [ERROR] npm is NOT installed
    if "!ERRORS!"=="0" set "ERRORS=1"
) else (
    echo [OK]    npm is installed
)
echo.

REM Check npm dependencies
echo [CHECK] Frontend dependencies (node_modules)
if not exist "node_modules" (
    echo [WARNING] node_modules not found
    echo [INFO]    Installing npm dependencies...
    call npm install
    if errorlevel 1 (
        echo [ERROR] npm install failed
        if "!ERRORS!"=="0" set "ERRORS=1"
    ) else (
        echo [OK]    npm dependencies installed
    )
) else (
    echo [OK]    node_modules exists
)
echo.

REM Summary
echo ============================================================================
echo SUMMARY
echo ============================================================================
echo.

if "%ERRORS%"=="0" (
    echo [SUCCESS] All required dependencies are installed!
    echo.
    echo You can now run:
    echo   - startup.bat          ^(automatic setup and startup^)
    echo   - startup-advanced.bat ^(with detailed logging^)
    echo.
) else (
    echo [FAILED] Some required dependencies are missing!
    echo.
    echo Please install the missing packages and try again.
    echo.
)

echo ============================================================================
echo.
timeout /t 3 /nobreak
endlocal

