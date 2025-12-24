@echo off
REM Backend Test Script for Hangman Application
REM This script runs all backend tests using Maven

echo ========================================
echo Backend Test Script
echo ========================================
echo.

REM Change to the workspace directory
cd /d "%~dp0"

echo Running backend tests...
echo.

REM Run Maven tests
call mvn test -f backend\pom.xml

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Tests completed successfully!
    echo ========================================
) else (
    echo.
    echo ========================================
    echo Tests failed with errors!
    echo ========================================
    exit /b 1
)

pause
