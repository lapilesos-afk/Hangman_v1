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

REM Fix: Kopiere environment-Dateien an erwarteten Ort (temporär für Build)
echo [INFO] Preparing environment files...
if not exist "src\environments" mkdir "src\environments"
copy /y "src\app\environments\environment.ts" "src\environments\environment.ts" >nul 2>&1
copy /y "src\app\environments\environment.prod.ts" "src\environments\environment.prod.ts" >nul 2>&1

REM Führe den Angular Build durch
call npx ng build --configuration production --progress false
if errorlevel 1 (
    echo [ERROR] Frontend build failed!
    REM Cleanup temporärer Dateien
    if exist "src\environments\environment.ts" del "src\environments\environment.ts"
    if exist "src\environments\environment.prod.ts" del "src\environments\environment.prod.ts"
    pause
    exit /b 1
)

REM Cleanup temporärer environment-Dateien
echo [INFO] Cleaning up temporary files...
if exist "src\environments\environment.ts" del "src\environments\environment.ts"
if exist "src\environments\environment.prod.ts" del "src\environments\environment.prod.ts"
if exist "src\environments" rmdir "src\environments" 2>nul

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

REM Backend: JAR + Konfiguration
echo [INFO] Copying backend artifacts...
xcopy /y /q "!JAR_FILE!" "%ARTIFACT_DIR%\backend\" >nul 2>&1
xcopy /y /q "backend\src\main\resources\application.yml" "%ARTIFACT_DIR%\backend\" >nul 2>&1

REM Frontend: Build-Ausgabe (aus dist/hangman-app/browser/)
echo [INFO] Copying frontend artifacts...
if exist "dist\hangman-app\browser\" (
    REM Kopiere Dateien direkt, nicht die Ordnerstruktur
    xcopy /e /i /y /q "dist\hangman-app\browser" "%ARTIFACT_DIR%\frontend" >nul 2>&1
) else if exist "dist\hangman-app\" (
    xcopy /e /i /y /q "dist\hangman-app" "%ARTIFACT_DIR%\frontend" >nul 2>&1
) else (
    echo [ERROR] Frontend build output not found in dist\
    goto error
)

REM Erstelle vereinfachte Startup-Scripts für Artifact
echo [INFO] Creating startup scripts...

REM start-backend.bat für Artifact
(
    echo @echo off
    echo REM Hangman Backend Starter
    echo echo Starting Hangman Backend...
    echo echo.
    echo cd backend
    echo java -jar hangman-service-1.0.0.jar
    echo pause
) > "%ARTIFACT_DIR%\start-backend.bat"

REM start-all.bat für Artifact
(
    echo @echo off
    echo REM Hangman Full Stack Starter
    echo echo ========================================
    echo echo Hangman Game - Startup
    echo echo ========================================
    echo echo.
    echo echo [1/2] Starting Backend...
    echo start "Hangman Backend" cmd /k "start-backend.bat"
    echo timeout /t 3 /nobreak ^>nul
    echo echo [OK] Backend started on: http://localhost:8080
    echo echo.
    echo echo [2/2] Starting Frontend...
    echo echo.
    echo REM Try npx http-server
    echo where npx ^>nul 2^^^>^^^&1
    echo if %%ERRORLEVEL%% EQU 0 ^(
    echo     start "Hangman Frontend" cmd /k "npx http-server frontend -p 4200"
    echo     echo [INFO] Waiting for servers to start...
    echo     timeout /t 8 /nobreak ^>nul
    echo     echo [OK] Frontend started on: http://localhost:4200
    echo     echo.
    echo     echo Opening browser...
    echo     start http://localhost:4200
    echo     goto end
    echo ^)
    echo.
    echo REM Try http-server
    echo where http-server ^>nul 2^^^>^^^&1
    echo if %%ERRORLEVEL%% EQU 0 ^(
    echo     start "Hangman Frontend" cmd /k "http-server frontend -p 4200"
    echo     echo [INFO] Waiting for servers to start...
    echo     timeout /t 8 /nobreak ^>nul
    echo     echo [OK] Frontend started on: http://localhost:4200
    echo     echo.
    echo     echo Opening browser...
    echo     start http://localhost:4200
    echo     goto end
    echo ^)
    echo.
    echo echo [WARNING] No Node.js web server found!
    echo echo Please install: npm install -g http-server
    echo echo.
    echo :end
    echo pause
) > "%ARTIFACT_DIR%\start-all.bat"

REM Kopiere nützliche Scripts
xcopy /y /q "stop-services.bat" "%ARTIFACT_DIR%\" >nul 2>&1

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
    echo ## Struktur
    echo ```
    echo hangman-artifact/
    echo ├── backend/
    echo │   ├── hangman-service-1.0.0.jar
    echo │   └── application.yml
    echo ├── frontend/
    echo │   └── (kompilierte Angular App^)
    echo ├── start-backend.bat       (Startet nur Backend^)
    echo ├── start-all.bat            (Startet Backend + Anweisungen für Frontend^)
    echo └── stop-services.bat        (Stoppt alle Services^)
    echo ```
    echo.
    echo ## Verwendung
    echo.
    echo ### Backend starten
    echo ```batch
    echo start-backend.bat
    echo ```
    echo - Backend läuft auf: http://localhost:8080
    echo - API: http://localhost:8080/api/games
    echo - H2 Console: http://localhost:8080/h2-console
    echo.
    echo ### Frontend bereitstellen
    echo.
    echo Das Frontend ist bereits kompiliert. Öffnen Sie `frontend/index.html` direkt
    echo oder verwenden Sie einen einfachen Web-Server:
    echo.
    echo **Option 1: Python**
    echo ```batch
    echo cd frontend
    echo python -m http.server 4200
    echo ```
    echo.
    echo **Option 2: Node.js http-server**
    echo ```batch
    echo npm install -g http-server
    echo cd frontend
    echo http-server -p 4200
    echo ```
    echo.
    echo **Option 3: Live Server (VS Code Extension^)**
    echo - Installiere "Live Server" in VS Code
    echo - Rechtsklick auf frontend/index.html
    echo - "Open with Live Server"
    echo.
    echo Dann öffnen Sie: http://localhost:4200
    echo.
    echo ## Voraussetzungen
    echo.
    echo ### Backend
    echo - Java 17 oder höher
    echo.
    echo ### Frontend (optional^)
    echo - Python 3.x oder
    echo - Node.js mit http-server oder
    echo - Beliebiger Web-Server
    echo.
    echo ## Konfiguration
    echo.
    echo Backend-Konfiguration: `backend/application.yml`
    echo.
    echo ## Technologie-Stack
    echo - Backend: Spring Boot 3.2.0 + Java 17
    echo - Frontend: Angular 18 + TypeScript
    echo - Datenbank: H2 (In-Memory^)
    echo.
    echo ## Support
    echo Bei Problemen siehe README.md im Hauptprojekt.
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
    if not errorlevel 1 (
        goto zip_done
    )
    echo [WARNING] 7-Zip fehlgeschlagen, versuche PowerShell...
)

REM PowerShell Compress-Archive Methode
echo [INFO] Verwende PowerShell Compress-Archive...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Compress-Archive -Path '%ARTIFACT_DIR%\*' -DestinationPath '%ARTIFACT_PATH%' -Force -CompressionLevel Optimal" 2>nul
if not errorlevel 1 (
    goto zip_done
)

REM Fallback: VBScript ZIP-Methode (funktioniert auf allen Windows-Versionen)
echo [WARNING] PowerShell fehlgeschlagen, verwende VBScript-Methode...
echo [INFO] Erstelle ZIP mit VBScript (kann etwas dauern)...

REM Erstelle vollständige Pfade (ohne .\ Prefix)
for %%I in ("%ARTIFACT_NAME%") do set "FULL_ARTIFACT_PATH=%CD%\%%~nxI"
for %%I in ("%ARTIFACT_DIR%") do set "FULL_ARTIFACT_DIR=%CD%\%%~nxI"

echo [DEBUG] ZIP wird erstellt: %FULL_ARTIFACT_PATH%
echo [DEBUG] Quelle: %FULL_ARTIFACT_DIR%

REM Erstelle temporäres VBScript
set "VBSCRIPT=%TEMP%\create_zip_%RANDOM%.vbs"
(
    echo Option Explicit
    echo Dim zipFile, sourceFolder, fso, objShell, zip, source
    echo.
    echo zipFile = "%FULL_ARTIFACT_PATH%"
    echo sourceFolder = "%FULL_ARTIFACT_DIR%"
    echo.
    echo Set fso = CreateObject^("Scripting.FileSystemObject"^)
    echo Set objShell = CreateObject^("Shell.Application"^)
    echo.
    echo ' Erstelle leere ZIP-Datei
    echo If fso.FileExists^(zipFile^) Then fso.DeleteFile zipFile
    echo Dim file
    echo Set file = fso.CreateTextFile^(zipFile, True^)
    echo file.Write Chr^(80^) ^& Chr^(75^) ^& Chr^(5^) ^& Chr^(6^) ^& String^(18, Chr^(0^)^)
    echo file.Close
    echo Set file = Nothing
    echo.
    echo ' Warte bis ZIP-Datei bereit ist
    echo WScript.Sleep 500
    echo.
    echo ' Kopiere alle Dateien
    echo Set zip = objShell.NameSpace^(zipFile^)
    echo Set source = objShell.NameSpace^(sourceFolder^)
    echo.
    echo If Not zip Is Nothing And Not source Is Nothing Then
    echo     zip.CopyHere source.Items, 4 + 16 + 512 + 1024
    echo     ' Warte auf Fertigstellung (max 60 Sekunden^)
    echo     Dim i
    echo     For i = 1 To 600
    echo         WScript.Sleep 100
    echo         If zip.Items.Count ^>= source.Items.Count Then Exit For
    echo     Next
    echo     WScript.Sleep 500
    echo End If
) > "%VBSCRIPT%"

echo [DEBUG] VBScript erstellt: %VBSCRIPT%

REM Prüfe ob VBScript existiert
if not exist "%VBSCRIPT%" (
    echo [ERROR] Konnte VBScript nicht erstellen!
    goto zip_failed
)

REM Führe VBScript aus
echo [INFO] Führe VBScript aus...
cscript //Nologo "%VBSCRIPT%" 2>&1
set VBS_RESULT=%ERRORLEVEL%

REM Warte etwas
timeout /t 2 /nobreak >nul 2>&1

REM Lösche VBScript
if exist "%VBSCRIPT%" del "%VBSCRIPT%" >nul 2>&1

REM Prüfe ob ZIP-Datei erstellt wurde
if exist "%FULL_ARTIFACT_PATH%" (
    echo [OK] ZIP-Datei erfolgreich erstellt
    goto zip_done
)

:zip_failed

REM Wenn alles fehlgeschlagen ist
echo [ERROR] Alle ZIP-Methoden fehlgeschlagen!
echo.
echo Mögliche Lösungen:
echo   1. Installiere 7-Zip: https://www.7-zip.org/
echo   2. Oder: Kopiere den Ordner 'artifact' manuell und benenne ihn um
echo.
echo Das Artifact-Verzeichnis befindet sich in: %ARTIFACT_DIR%
echo.
pause
exit /b 1

:zip_done
REM Prüfe nochmal ob ZIP existiert
set "FINAL_ZIP_PATH=.\%ARTIFACT_NAME%"
if not exist "%FINAL_ZIP_PATH%" (
    set "FINAL_ZIP_PATH=%FULL_ARTIFACT_PATH%"
)
if not exist "%FINAL_ZIP_PATH%" (
    set "FINAL_ZIP_PATH=%ARTIFACT_PATH%"
)

if not exist "%FINAL_ZIP_PATH%" (
    echo [ERROR] Failed to create archive!
    echo.
    echo Hinweis: Das Artifact-Verzeichnis wurde erstellt in: %ARTIFACT_DIR%
    echo Sie können dieses Verzeichnis manuell als ZIP komprimieren.
    echo.
    pause
    exit /b 1
)

echo [OK] ZIP archive created successfully
set "ARTIFACT_PATH=%FINAL_ZIP_PATH%"

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
