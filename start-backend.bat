@echo off
REM Hangman Game - Backend Quick Start Script for Windows
REM This script sets up and runs the Spring Boot backend

setlocal enabledelayedexpansion

echo ========================================
echo Hangman Game - Backend Setup
echo ========================================
echo.

REM Check Java installation
echo Checking Java installation...
java -version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Java is not installed. Please install Java 17 or higher.
    exit /b 1
)

for /f "tokens=*" %%i in ('java -version 2^>^&1 ^| findstr /I "version"') do (
    echo ^! Java found: %%i
)
echo.

REM Check Maven installation
echo Checking Maven installation...
mvn -version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Maven is not installed. Please install Maven 3.6 or higher.
    exit /b 1
)

for /f "tokens=*" %%i in ('mvn -version 2^>^&1 ^| findstr /I "Apache"') do (
    echo ^! Maven found: %%i
)
echo.

REM Navigate to backend directory
cd backend

echo Building the project...
echo ========================================
call mvn clean install
echo ========================================
echo ^! Build complete!
echo.

echo Starting Spring Boot application...
echo ========================================
echo Backend will be available at: http://localhost:8080
echo H2 Console: http://localhost:8080/h2-console
echo.
echo Press Ctrl+C to stop the server
echo ========================================

call mvn spring-boot:run
