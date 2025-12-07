@echo off
REM ========================================================
REM Stop Backend (Java) and Frontend (Node.js)
REM ========================================================

echo.
echo ========================================================
echo  Stopping Backend and Frontend Services
echo ========================================================
echo.

REM Kill Java (Backend)
echo [1/2] Stopping Backend (Java)...
taskkill /F /IM java.exe 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] Backend stopped
) else (
    echo [INFO] No Java process running
)

REM Kill Node (Frontend)
echo [2/2] Stopping Frontend (Node.js)...
taskkill /F /IM node.exe 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] Frontend stopped
) else (
    echo [INFO] No Node process running
)

REM Kill Edge if open
taskkill /F /IM msedge.exe 2>nul

echo.
echo ========================================================
echo  All services stopped
echo ========================================================
echo.

pause
