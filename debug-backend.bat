@echo off
REM ============================================================================
REM Backend Debug Starter (JDWP - Java Debug Wire Protocol)
REM ============================================================================
REM
REM Startet das Backend im Debug-Modus auf Port 5005
REM Ermöglicht das Debuggen mit VS Code oder anderen Debuggern
REM
REM Verwendung: .\debug-backend.bat
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ========================================================
echo  Hangman Backend - Debug Mode
echo ========================================================
echo.
echo [INFO] Starte Backend im Debug-Modus...
echo [INFO] Debug-Port: 5005
echo [INFO] Warte auf Debugger-Verbindung...
echo.

cd backend

REM Setze JAVA_OPTS für Debug über Umgebungsvariable
set JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005

echo [INFO] JAVA_OPTS: %JAVA_OPTS%
echo [INFO] Starte Maven...
echo.

REM Starte Maven Spring Boot mit gesetzter JAVA_OPTS
call mvn spring-boot:run -DskipTests

cd ..

pause
