@echo off
REM ============================================================================
REM Hangman Game - Cleanup and Reset Script
REM Löscht Build-Artefakte und Cache
REM ============================================================================

setlocal enabledelayedexpansion

cls
echo.
echo ============================================================================
echo HANGMAN - Cleanup and Reset
echo ============================================================================
echo.

set /p CONFIRM="This will delete build artifacts and cache. Continue (Y/N)? "
if /i not "%CONFIRM%"=="Y" (
    echo Aborted.
    exit /b 0
)

echo.
echo Cleaning up...
echo.

REM Backend cleanup
echo [1/4] Cleaning Backend (target directory)...
if exist "backend\target" (
    rmdir /s /q "backend\target"
    echo       [OK] Removed backend\target
) else (
    echo       [SKIP] No backend\target directory
)

REM Frontend cleanup
echo [2/4] Cleaning Frontend (node_modules)...
if exist "node_modules" (
    rmdir /s /q "node_modules"
    echo       [OK] Removed node_modules
) else (
    echo       [SKIP] No node_modules directory
)

REM Angular build cleanup
echo [3/4] Cleaning Angular build (dist directory)...
if exist "dist" (
    rmdir /s /q "dist"
    echo       [OK] Removed dist
) else (
    echo       [SKIP] No dist directory
)

REM Logs cleanup (optional)
echo [4/4] Cleaning logs (logs directory)...
if exist "logs" (
    rmdir /s /q "logs"
    echo       [OK] Removed logs
) else (
    echo       [SKIP] No logs directory
)

echo.
echo ============================================================================
echo CLEANUP COMPLETE
echo ============================================================================
echo.
echo Next steps:
echo   1. Run: startup.bat (for automatic setup)
echo   2. Or: check-dependencies.bat (to verify requirements)
echo.
pause
