@echo off
REM Hangman Backend Starter
REM Usage: start-backend.bat [--no-pause]
echo Starting Hangman Backend...
echo.
cd backend
java -jar hangman-service-1.0.0.jar
if "%~1" NEQ "--no-pause" pause
