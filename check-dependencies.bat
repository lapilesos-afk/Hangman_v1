@echo off
REM ============================================================================
REM Hangman Game - Dependency Check Script
REM ============================================================================

setlocal enabledelayedexpansion

cls
echo.
echo ============================================================================
echo HANGMAN - System Requirements Check
echo ============================================================================
echo.

set "JAVA_OK=0"
set "MAVEN_OK=0"
set "NODE_OK=0"
set "NPM_OK=0"
set "DEPS_OK=0"

REM Check Java
echo [CHECK] Java Development Kit (JDK)
where java >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Java is NOT installed
) else (
    echo [SUCCESS] Java is installed
    set "JAVA_OK=1"
)
echo.

REM Check Maven
echo [CHECK] Apache Maven
where mvn >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Maven is NOT installed
) else (
    echo [SUCCESS] Maven is installed
    set "MAVEN_OK=1"
)
echo.

REM Check Node.js
echo [CHECK] Node.js
where node >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js is NOT installed
) else (
    echo [SUCCESS] Node.js is installed
    set "NODE_OK=1"
)
echo.

REM Check npm
echo [CHECK] npm
where npm >nul 2>&1
if errorlevel 1 (
    echo [ERROR] npm is NOT installed
) else (
    echo [SUCCESS] npm is installed
    set "NPM_OK=1"
)
echo.

REM Check npm dependencies
echo [CHECK] Frontend dependencies (node_modules)
if not exist "node_modules" (
    echo [WARNING] node_modules not found
    if "!NPM_OK!"=="1" (
        echo [INFO]    Installing npm dependencies...
        call npm install
        if errorlevel 1 (
            echo [ERROR] npm install failed
        ) else (
            echo [SUCCESS] npm dependencies installed
            set "DEPS_OK=1"
        )
    ) else (
        echo [SKIP]    npm not available - cannot install dependencies
    )
) else (
    echo [SUCCESS] node_modules exists
    set "DEPS_OK=1"
)
echo.

REM Summary
echo ============================================================================
echo SUMMARY
echo ============================================================================
echo.

REM Check if all required dependencies are present
if "!JAVA_OK!"=="1" if "!MAVEN_OK!"=="1" if "!NODE_OK!"=="1" if "!NPM_OK!"=="1" if "!DEPS_OK!"=="1" (
    echo [SUCCESS] All required dependencies are installed!
    echo.
    echo You can now run:
    echo   - startup.bat          ^(automatic setup and startup^)
    echo   - startup-advanced.bat ^(with detailed logging^)
    echo.
) else (
    echo [FAILED] Some required dependencies are missing!
    echo.
    echo Missing components:
    if "!JAVA_OK!"=="0" echo   - Java Development Kit (JDK)
    if "!MAVEN_OK!"=="0" echo   - Apache Maven
    if "!NODE_OK!"=="0" echo   - Node.js
    if "!NPM_OK!"=="0" echo   - npm
    if "!DEPS_OK!"=="0" echo   - Frontend dependencies (node_modules)
    echo.
    echo Next steps:
    if "!JAVA_OK!"=="0" (
        echo 1. Install Java JDK 17 or higher
        echo    Download: https://adoptium.net/
    )
    if "!MAVEN_OK!"=="0" (
        echo 2. Install Apache Maven
        echo    Download: https://maven.apache.org/download.cgi
    )
    if "!NODE_OK!"=="0" (
        echo 3. Install Node.js (includes npm)
        echo    Download: https://nodejs.org/
    )
    if "!NPM_OK!"=="1" if "!DEPS_OK!"=="0" (
        echo 4. Run 'npm install' to install frontend dependencies
    )
    echo.
    echo After installing the missing components, run this script again.
    echo.
)

echo ============================================================================
echo.
timeout /t 5 /nobreak
endlocal
