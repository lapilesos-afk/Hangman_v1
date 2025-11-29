# Backend Debug Starter (PowerShell Version)
# Startet das Backend im Debug-Modus mit JDWP auf Port 5005

Write-Host ""
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  Hangman Backend - Debug Mode" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host ""
Write-Host "[INFO] Starte Backend im Debug-Modus..." -ForegroundColor Yellow
Write-Host "[INFO] Debug-Port: 5005" -ForegroundColor Yellow
Write-Host "[INFO] Warte auf Debugger-Verbindung..." -ForegroundColor Yellow
Write-Host ""

# Setze JAVA_OPTS für Debug
$env:JAVA_OPTS = "-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005"

Write-Host "[INFO] JAVA_OPTS gesetzt: $env:JAVA_OPTS" -ForegroundColor Cyan
Write-Host ""

# Wechsle in Backend-Verzeichnis
Push-Location backend

# Starte Maven Spring Boot
Write-Host "[INFO] Führe Maven aus: mvn spring-boot:run -DskipTests" -ForegroundColor Cyan
Write-Host ""

& mvn spring-boot:run -DskipTests

# Räume auf
Pop-Location
