@echo off
REM ============================================================================
REM Artifact Builder - Erstellt ein Deployment-Paket ohne Quellcode
REM ============================================================================
REM
REM Dieses Skript erstellt ein ZIP-Archiv mit allen notwendigen Dateien zum
REM Ausführen der Hangman-Anwendung:
REM   - Backend JAR (kompiliert)
REM   - Frontend Build (kompiliert)
REM   - Startup-Skripte
REM   - Konfiguration
REM
REM Ausführung: .\create-artifact.bat [VERSION]
REM   Beispiel: .\create-artifact.bat 1.0.0
REM   Ausgabe: hangman-artifact-1.0.0.zip
REM
REM Wenn keine VERSION angegeben wird, wird ein Timestamp verwendet:
REM   Ausgabe: hangman-artifact-<TIMESTAMP>.zip
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ========================================================
echo  Hangman Artifact Builder
echo ========================================================
echo.

REM Verarbeite Versionsnummer aus Parameter oder verwende Timestamp
if "%~1"=="" (
    set "VERSION=%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
    set "VERSION=!VERSION: =0!"
    echo [INFO] Keine Version angegeben, verwende Timestamp: !VERSION!
) else (
    set "VERSION=%~1"
    echo [INFO] Verwende Version: !VERSION!
)

REM Definiere Ausgabeverzeichnis und Namen
set "ARTIFACT_DIR=.\artifact"
set "ARTIFACT_NAME=hangman-artifact-!VERSION!.zip"
set "ARTIFACT_PATH=%ARTIFACT_DIR%\%ARTIFACT_NAME%"

echo [INFO] Cleanup old artifacts...
if exist "%ARTIFACT_DIR%" (
    rmdir /s /q "%ARTIFACT_DIR%" >nul 2>&1
)
mkdir "%ARTIFACT_DIR%" >nul 2>&1

REM ============================================================================
REM 1. Backend bauen
REM ============================================================================
echo.
echo [1/4] Building Backend (Maven)...
cd backend
if exist target (
    rmdir /s /q target >nul 2>&1
)
call mvn clean package -q -DskipTests
if errorlevel 1 (
    echo [ERROR] Backend build failed!
    cd ..
    pause
    exit /b 1
)
cd ..
echo [OK] Backend built successfully

REM Suche JAR-Datei
set "JAR_FILE="
for /f "delims=" %%f in ('dir /b backend\target\*.jar 2^>nul') do (
    set "JAR_FILE=backend\target\%%f"
    goto jar_found
)
:jar_found
if "!JAR_FILE!"=="" (
    echo [ERROR] JAR file not found in backend\target\
    pause
    exit /b 1
)
echo [INFO] Found JAR: !JAR_FILE!

REM ============================================================================
REM 2. Frontend bauen
REM ============================================================================
echo.
echo [2/4] Building Frontend (Angular)...

REM Stelle sicher, dass Dependencies installiert sind
echo [INFO] Installing npm dependencies...
call npm install --legacy-peer-deps -q
if errorlevel 1 (
    echo [WARNING] npm install had issues, but continuing...
)

REM Führe den Angular Build durch
call npx ng build --configuration production --progress false
if errorlevel 1 (
    echo [ERROR] Frontend build failed!
    pause
    exit /b 1
)
echo [OK] Frontend built successfully

if not exist dist (
    echo [ERROR] Frontend build directory 'dist' not found!
    pause
    exit /b 1
)

REM ============================================================================
REM 3. Artifact-Verzeichnis vorbereiten
REM ============================================================================
echo.
echo [3/4] Preparing artifact contents...

REM Verzeichnis-Struktur erstellen
mkdir "%ARTIFACT_DIR%\backend" >nul 2>&1
mkdir "%ARTIFACT_DIR%\frontend" >nul 2>&1
mkdir "%ARTIFACT_DIR%\config" >nul 2>&1
mkdir "%ARTIFACT_DIR%\scripts" >nul 2>&1

REM Backend: JAR + Konfiguration
echo [INFO] Copying backend artifacts...
xcopy /y /q "!JAR_FILE!" "%ARTIFACT_DIR%\backend\" >nul 2>&1
xcopy /y /q "backend\src\main\resources\application.yml" "%ARTIFACT_DIR%\config\" >nul 2>&1

REM Frontend: Build-Ausgabe
echo [INFO] Copying frontend artifacts...
xcopy /e /y /q "dist\*" "%ARTIFACT_DIR%\frontend\" >nul 2>&1

REM Startup-Skripte
echo [INFO] Copying startup scripts...
xcopy /y /q "startup.bat" "%ARTIFACT_DIR%\scripts\" >nul 2>&1
xcopy /y /q "startup.ps1" "%ARTIFACT_DIR%\scripts\" >nul 2>&1
xcopy /y /q "start-backend.bat" "%ARTIFACT_DIR%\scripts\" >nul 2>&1
xcopy /y /q "start-backend.sh" "%ARTIFACT_DIR%\scripts\" >nul 2>&1
xcopy /y /q "check-dependencies.bat" "%ARTIFACT_DIR%\scripts\" >nul 2>&1
xcopy /y /q "stop-services.bat" "%ARTIFACT_DIR%\scripts\" >nul 2>&1

REM README für Artifact
echo [INFO] Creating artifact README...
(
    echo # Hangman Artifact - Version !VERSION!
    echo.
    echo Dies ist ein vorkompiliertes Deployment-Paket für die Hangman-Anwendung.
    echo.
    echo **Version:** !VERSION!
    echo **Erstellt:** %DATE% %TIME%
    echo.
    echo ## Inhaltsverzeichnis
    echo - backend/       ^- Kompiliertes Backend JAR
    echo - frontend/      ^- Kompiliertes Angular Frontend
    echo - config/        ^- Konfigurationsdateien
    echo - scripts/       ^- Startup- und Verwaltungsskripte
    echo.
    echo ## Verwendung
    echo.
    echo ### Windows
    echo cd scripts
    echo startup.bat
    echo.
    echo ### Linux/Mac
    echo cd scripts
    echo bash start-backend.sh
    echo.
    echo Backend läuft auf: http://localhost:8080
    echo Frontend läuft auf: http://localhost:4200
    echo.
    echo ## Vorraussetzungen
    echo - Java 17+
    echo - Node.js 18+ (für Frontend)
    echo - Maven 3.6+ (optional, falls Anpassungen nötig sind^)
    echo.
    echo ## Release-Informationen
    echo **Version:** !VERSION!
    echo **Erstellt:** %DATE% %TIME%
) > "%ARTIFACT_DIR%\README.md"

echo [OK] Artifact contents prepared

REM ============================================================================
REM 4. ZIP-Archiv erstellen
REM ============================================================================
echo.
echo [4/4] Creating ZIP archive...

REM Versuche mit 7-Zip first (falls installiert)
where /q 7z.exe
if not errorlevel 1 (
    echo [INFO] Verwende 7-Zip zum Komprimieren...
    7z a -tzip -r "%ARTIFACT_PATH%" "%ARTIFACT_DIR%\*" >nul 2>&1
    if errorlevel 1 (
        echo [WARNING] 7-Zip fehlgeschlagen, versuche Compress-Archive...
        goto try_powershell
    )
    goto zip_done
)

:try_powershell
echo [INFO] Verwende PowerShell Compress-Archive...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Compress-Archive -Path '%ARTIFACT_DIR%\*' -DestinationPath '%ARTIFACT_PATH%' -Force -CompressionLevel Optimal" 2>nul

if errorlevel 1 (
    echo [WARNING] Compress-Archive fehlgeschlagen, versuche Expand-Archive alternative...
    REM Fallback: Erstelle ZIP mit einfacherer PowerShell-Methode
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-Type -Assembly 'System.IO.Compression.FileSystem'; $source='%ARTIFACT_DIR%'; $dest='%ARTIFACT_PATH%'; if(Test-Path $dest){Remove-Item $dest}; [System.IO.Compression.ZipFile]::CreateFromDirectory($source, $dest, 'Optimal', $false)" 2>nul
    if errorlevel 1 (
        echo [ERROR] Alle Archive-Methoden fehlgeschlagen!
        echo [ERROR] Bitte installiere 7-Zip: https://www.7-zip.org/
        pause
        exit /b 1
    )
)

:zip_done
if not exist "%ARTIFACT_PATH%" (
    echo [ERROR] Failed to create archive!
    pause
    exit /b 1
)

echo [OK] ZIP archive created successfully

REM Verschiebe ZIP ins Root-Verzeichnis (bevor artifact-Verzeichnis gelöscht wird)
echo [INFO] Moving archive to root directory...
move /y "%ARTIFACT_PATH%" ".\%ARTIFACT_NAME%" >nul 2>&1
set "ARTIFACT_PATH=.\%ARTIFACT_NAME%"

REM ============================================================================
REM 5. Cleanup und Zusammenfassung
REM ============================================================================
echo.
echo ========================================================
echo  Artifact Created Successfully!
echo ========================================================
echo.
echo [INFO] Version: !VERSION!
echo [INFO] Archive: %ARTIFACT_PATH%
if exist "%ARTIFACT_PATH%" (
    for /f "tokens=*" %%a in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$f=Get-Item '%ARTIFACT_PATH%'; Write-Host ([math]::Round($f.Length/1MB, 2))" 2^>nul') do (
        echo [INFO] Size: %%a MB
    )
)
echo.
echo [INFO] Contents:
echo   - Backend JAR: backend/
echo   - Frontend Build: frontend/ (static files^)
echo   - Configuration: config/application.yml
echo   - Scripts: scripts/
echo.
echo [INFO] Next Steps:
echo   1. Extract the ZIP file to your deployment target
echo   2. Navigate to the scripts/ directory
echo   3. Run startup.bat (Windows^) or start-backend.sh (Linux/Mac^)
echo   4. Open http://localhost:4200 in your browser
echo.
echo [INFO] Cleanup: Removing temporary artifact build directory...
rmdir /s /q "%ARTIFACT_DIR%" >nul 2>&1

echo [OK] Done!
echo.
pause
