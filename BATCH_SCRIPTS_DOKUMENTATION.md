# Hangman Projekt - Batch Scripts Dokumentation

> **Projekt:** Hangman Web-Anwendung  
> **Datum:** 23. Dezember 2025  
> **Version:** 1.0.0

---

## Inhaltsverzeichnis

1. [Übersicht](#übersicht)
2. [Setup und Installation](#setup-und-installation)
3. [Entwicklung und Testing](#entwicklung-und-testing)
4. [Produktions-Deployment](#produktions-deployment)
5. [Wartung und Verwaltung](#wartung-und-verwaltung)
6. [Zusammenfassung](#zusammenfassung)

---

## Übersicht

Das Hangman-Projekt enthält **13 Batch-Scripts** zur Automatisierung verschiedener Entwicklungs- und Deployment-Prozesse. Diese Scripts ermöglichen eine einfache Verwaltung der Full-Stack-Anwendung (Spring Boot Backend + Angular Frontend) auf Windows-Systemen.

### Kategorisierung der Scripts

| Kategorie | Anzahl | Scripts |
|-----------|--------|---------|
| Setup & Prüfung | 2 | `check-dependencies.bat`, `setup-context-menu.bat` |
| Startup & Betrieb | 4 | `startup.bat`, `startup-advanced.bat`, `start-backend.bat`, `start-frontend.bat` |
| Debugging | 1 | `debug-backend.bat` |
| Testing | 1 | `test-backend.bat` |
| Deployment | 1 | `create-artifact.bat` |
| Wartung | 4 | `stop-all.bat`, `stop-services.bat`, `cleanup.bat`, `cleanup-context-menu.bat` |

---

## Setup und Installation

### 1. check-dependencies.bat

**Zweck:** Überprüfung aller erforderlichen System-Abhängigkeiten

**Funktionsweise:**
- Prüft ob Java (JDK) installiert ist
- Prüft ob Apache Maven installiert ist
- Prüft ob Node.js installiert ist
- Prüft ob npm installiert ist
- Zeigt eine Zusammenfassung mit Status (OK/ERROR)

**Verwendung:**
```batch
check-dependencies.bat
```

**Ausgabe:**
```
============================================================================
HANGMAN - System Requirements Check
============================================================================

[CHECK] Java Development Kit (JDK)
[OK]    Java is installed

[CHECK] Apache Maven
[OK]    Maven is installed

[CHECK] Node.js
[OK]    Node.js is installed

[CHECK] npm
[OK]    npm is installed

============================================================================
SUMMARY
============================================================================
[SUCCESS] All required dependencies are installed!
```

**Empfohlener Einsatz:** Vor der ersten Installation oder nach System-Updates

---

### 2. setup-context-menu.bat

**Zweck:** Integration ins Windows-Kontextmenü (Explorer)

**Funktionsweise:**
- **Erfordert Administrator-Rechte**
- Fügt "Start Hangman" zum Kontextmenü von Ordnern hinzu
- Erstellt Registry-Einträge in `HKCU\Software\Classes\Folder\shell\Hangman`
- Verknüpft mit `startup.bat`
- Setzt optionales Icon

**Verwendung:**
```batch
# Als Administrator ausführen!
setup-context-menu.bat
```

**Resultat:** Rechtsklick auf Ordner → "Start Hangman" erscheint im Menü

**Deinstallation:** `cleanup-context-menu.bat`

---

## Entwicklung und Testing

### 3. startup.bat

**Zweck:** Automatischer Start von Backend UND Frontend

**Funktionsweise:**
1. Überprüft Java, Maven und Node.js Installation
2. Bereinigt Ports 8080 (Backend) und 4200 (Frontend)
3. Baut Backend mit Maven (`mvn clean package -DskipTests`)
4. Installiert npm Dependencies (falls nötig)
5. Startet Backend in separatem Fenster (`mvn spring-boot:run`)
6. Wartet 10 Sekunden
7. Startet Frontend in separatem Fenster (`npm start`)
8. Öffnet automatisch Browser

**Verwendung:**
```batch
startup.bat
```

**Vorteile:**
- ✅ Ein Befehl für komplette Anwendung
- ✅ Automatische Dependency-Installation
- ✅ Port-Bereinigung
- ✅ Browser öffnet automatisch

**Nachteile:**
- ⚠️ Keine detaillierte Fehlerbehandlung
- ⚠️ Keine Logging-Funktionen

---

### 4. startup-advanced.bat

**Zweck:** Erweiterter Start mit umfangreicher Fehlerbehandlung

**Funktionsweise:**
- **Erweiterte Prüfungen:**
  - Java-Version (mindestens Version 17)
  - Detaillierte Versions-Anzeige
  - Port-Verfügbarkeit vor dem Start
  
- **Logging:**
  - Erstellt `logs/` Verzeichnis
  - Schreibt detaillierte Logs
  
- **Fehlerbehandlung:**
  - Erkennt blockierte Ports
  - Gibt detaillierte Fehlermeldungen
  - Bietet Wiederherstellungsoptionen

**Verwendung:**
```batch
startup-advanced.bat
```

**Ausgabe-Beispiel:**
```
============================================================================
  HANGMAN GAME - LOCAL STARTUP (NO DOCKER REQUIRED)
============================================================================

[SETUP] Checking prerequisites...

  [1] Checking Java...
  [OK] Java "17.0.12"
  
  [2] Checking Node.js/npm...
  [OK] npm 10.2.4
  
  [3] Checking Maven...
  [OK] Maven 3.9.5

[PORTS] Checking port availability...
  [OK] Port 8080 available
  [OK] Port 4200 available
```

**Empfohlener Einsatz:** 
- Produktive Entwicklung
- Wenn Probleme mit `startup.bat` auftreten
- Bei der Fehlersuche

---

### 5. start-backend.bat

**Zweck:** Nur Backend starten (Spring Boot)

**Funktionsweise:**
1. Prüft Java Installation
2. Prüft Maven Installation
3. Wechselt ins `backend/` Verzeichnis
4. Führt `mvn clean install` aus
5. Startet Backend mit `mvn spring-boot:run`

**Verwendung:**
```batch
start-backend.bat
```

**Zugangspunkte:**
- **API:** http://localhost:8080
- **H2 Console:** http://localhost:8080/h2-console

**Verwendungszweck:**
- Nur Backend testen
- Frontend separat entwickeln
- API-Tests durchführen

---

### 6. start-frontend.bat

**Zweck:** Nur Frontend starten (Angular Dev Server)

**Funktionsweise:**
1. Prüft Node.js Installation
2. Startet Angular Dev Server mit `npm start`
3. Server läuft auf Port 4200

**Verwendung:**
```batch
start-frontend.bat
```

**Zugangspunkt:** http://localhost:4200

**Hinweis:** Backend muss separat laufen (auf Port 8080)

**Verwendungszweck:**
- Frontend-Entwicklung
- UI/UX Testing
- Backend läuft bereits

---

### 7. debug-backend.bat

**Zweck:** Backend im Debug-Modus starten (für VS Code/IntelliJ)

**Funktionsweise:**
1. Setzt `JAVA_OPTS` für JDWP (Java Debug Wire Protocol)
2. Konfiguriert Debug-Port 5005
3. Startet mit `suspend=y` (wartet auf Debugger-Verbindung)
4. Führt `mvn spring-boot:run` aus

**Verwendung:**
```batch
debug-backend.bat
```

**Debug-Konfiguration:**
```
Transport: dt_socket
Server: yes
Suspend: yes (wartet auf Debugger)
Address: 5005
```

**VS Code Debug-Setup:**
```json
{
  "type": "java",
  "request": "attach",
  "name": "Attach to Backend",
  "hostName": "localhost",
  "port": 5005
}
```

**Verwendungszweck:**
- Breakpoint-Debugging
- Schritt-für-Schritt Code-Analyse
- Exception-Untersuchung

---

### 8. test-backend.bat

**Zweck:** Backend Tests ausführen (Maven Tests)

**Funktionsweise:**
1. Führt `mvn test -f backend\pom.xml` aus
2. Zeigt Test-Ergebnisse an
3. Gibt Exit-Code zurück (0 = Erfolg, 1 = Fehler)
4. Pausiert am Ende für Ergebnis-Ansicht

**Verwendung:**
```batch
test-backend.bat
```

**Test-Abdeckung:**
- **HangmanControllerTest** (17 Tests)
  - Start Game Tests
  - Guess Tests (korrekt/falsch/gewonnen/verloren)
  - Validierung Tests
  - Error Handling Tests
  
- **GameTest** (7 Tests)
  - Domain Logic Tests
  - Game Status Tests
  
- **HangmanIntegrationTest** (3 Tests)
  - End-to-End API Tests
  
- **HangmanServiceTest** (5 Tests)
  - Service Layer Tests

**Ausgabe-Beispiel:**
```
========================================
Backend Test Script
========================================

Running backend tests...

[INFO] Tests run: 32, Failures: 0, Errors: 0, Skipped: 0

========================================
Tests completed successfully!
========================================
```

**Verwendungszweck:**
- Vor jedem Commit
- Nach Code-Änderungen
- CI/CD Integration
- Qualitätssicherung

---

## Produktions-Deployment

### 9. create-artifact.bat

**Zweck:** Erstellung eines deployment-bereiten ZIP-Archivs

**Funktionsweise:**
1. Akzeptiert optionalen Versions-Parameter
2. Erstellt `artifact/` Verzeichnis
3. **Backend Build:**
   - Führt `mvn clean package -DskipTests` aus
   - Findet generierte JAR-Datei
4. **Frontend Build:**
   - Installiert npm dependencies
   - Führt `npx ng build --configuration production` aus
   - Optimiert für Produktion
5. **Paketierung:**
   - Kopiert JAR-Datei
   - Kopiert Frontend Build (dist/)
   - Kopiert Startup-Scripts
   - Kopiert Konfigurationsdateien
6. Erstellt ZIP-Archiv

**Verwendung:**
```batch
# Mit Versionsnummer
create-artifact.bat 1.0.0

# Ohne Versionsnummer (verwendet Timestamp)
create-artifact.bat
```

**Ausgabe:**
```
artifact/
  └── hangman-artifact-1.0.0.zip
      ├── backend/
      │   └── hangman-service-1.0.0.jar
      ├── frontend/
      │   └── (compiled Angular app)
      ├── startup.bat
      ├── start-backend.bat
      ├── start-frontend.bat
      └── README.md
```

**Dateiname-Muster:**
- Mit Version: `hangman-artifact-1.0.0.zip`
- Ohne Version: `hangman-artifact-20251223_193000.zip`

**Verwendungszweck:**
- Deployment auf Produktions-Server
- Verteilung an Kunden
- Releases
- Backup vor größeren Änderungen

---

## Wartung und Verwaltung

### 10. stop-all.bat

**Zweck:** Alle Java und Node.js Prozesse beenden

**Funktionsweise:**
- Beendet alle Java-Prozesse (`taskkill /F /IM java.exe`)
- Beendet alle Node.js-Prozesse (`taskkill /F /IM node.exe`)
- Beendet Microsoft Edge (falls geöffnet)
- Gibt Status-Meldungen aus

**Verwendung:**
```batch
stop-all.bat
```

**Ausgabe:**
```
========================================================
 Stopping Backend and Frontend Services
========================================================

[1/2] Stopping Backend (Java)...
[OK] Backend stopped

[2/2] Stopping Frontend (Node.js)...
[OK] Frontend stopped
```

**Achtung:** ⚠️ Beendet ALLE Java/Node Prozesse auf dem System!

**Verwendungszweck:**
- Schnelles Beenden aller Services
- Nach Entwicklungssession
- Bei hängenden Prozessen

---

### 11. stop-services.bat

**Zweck:** Gezieltes Beenden der Hangman-Services (Port-basiert)

**Funktionsweise:**
- **Intelligenter als stop-all.bat**
- Findet Prozesse auf Port 8080 (Backend)
- Findet Prozesse auf Port 4200 (Frontend)
- Beendet nur diese spezifischen Prozesse
- Versucht auch Window-Title-Match ("Hangman*")

**Verwendung:**
```batch
stop-services.bat
```

**Ausgabe:**
```
============================================================================
HANGMAN - Stop Services
============================================================================

[1/2] Stopping Backend (port 8080)...
      [OK] Backend stopped

[2/2] Stopping Frontend (port 4200)...
      [OK] Frontend stopped
```

**Vorteile gegenüber stop-all.bat:**
- ✅ Beendet nur Hangman-Prozesse
- ✅ Andere Java/Node Apps bleiben aktiv
- ✅ Sicherer für Multi-Projekt-Entwicklung

**Empfohlener Einsatz:** Generell bevorzugt gegenüber `stop-all.bat`

---

### 12. cleanup.bat

**Zweck:** Bereinigung von Build-Artefakten und Caches

**Funktionsweise:**
1. Fragt nach Bestätigung (`Y/N`)
2. **Löscht folgende Verzeichnisse:**
   - `backend/target/` - Maven Build-Artefakte
   - `node_modules/` - npm Dependencies
   - `dist/` - Angular Build-Output
   - `logs/` - Log-Dateien

**Verwendung:**
```batch
cleanup.bat
```

**Ausgabe:**
```
============================================================================
HANGMAN - Cleanup and Reset
============================================================================

This will delete build artifacts and cache. Continue (Y/N)? Y

Cleaning up...

[1/4] Cleaning Backend (target directory)...
      [OK] Removed backend\target

[2/4] Cleaning Frontend (node_modules)...
      [OK] Removed node_modules

[3/4] Cleaning Angular build (dist directory)...
      [OK] Removed dist

[4/4] Cleaning logs (logs directory)...
      [OK] Removed logs
```

**Verwendungszweck:**
- Nach Dependency-Updates
- Bei Build-Problemen
- Vor fresh install
- Disk-Space freigeben
- Troubleshooting

**Wichtig:** Nach cleanup muss `npm install` erneut ausgeführt werden!

---

### 13. cleanup-context-menu.bat

**Zweck:** Entfernung der Windows-Kontextmenü-Integration

**Funktionsweise:**
- **Erfordert Administrator-Rechte**
- Löscht Registry-Einträge aus `HKCU\Software\Classes\Folder\shell\Hangman`
- Entfernt "Start Hangman" aus dem Kontextmenü

**Verwendung:**
```batch
# Als Administrator ausführen!
cleanup-context-menu.bat
```

**Ausgabe:**
```
============================================================================
Windows Context Menu Integration Cleanup
============================================================================

[1/1] Removing registry entries...
[OK] Context menu integration removed
```

**Verwendungszweck:**
- Deinstallation
- System-Bereinigung
- Vor Neuinstallation

---

## Zusammenfassung

### Typischer Entwicklungs-Workflow

#### 1. Erste Einrichtung
```batch
# System-Anforderungen prüfen
check-dependencies.bat

# Optional: Kontextmenü einrichten
setup-context-menu.bat
```

#### 2. Tägliche Entwicklung
```batch
# Anwendung starten
startup.bat

# Oder bei Problemen
startup-advanced.bat

# Nur Backend debuggen
debug-backend.bat
```

#### 3. Testing
```batch
# Backend Tests ausführen
test-backend.bat
```

#### 4. Deployment vorbereiten
```batch
# Artifact erstellen
create-artifact.bat 1.0.0
```

#### 5. Aufräumen
```batch
# Services beenden
stop-services.bat

# Build-Artefakte löschen (optional)
cleanup.bat
```

---

### Best Practices

#### ✅ Empfohlene Reihenfolge bei Problemen

1. `stop-services.bat` - Alte Prozesse beenden
2. `cleanup.bat` - Build-Cache löschen
3. `check-dependencies.bat` - Dependencies prüfen
4. `startup-advanced.bat` - Mit detailliertem Logging starten

#### ⚠️ Wichtige Hinweise

- **Administrator-Rechte benötigt:**
  - `setup-context-menu.bat`
  - `cleanup-context-menu.bat`

- **Port-Konflikte vermeiden:**
  - Vor Start: `stop-services.bat` ausführen
  - Ports 8080 und 4200 müssen frei sein

- **Nach cleanup.bat:**
  - `npm install` wird beim nächsten Start automatisch ausgeführt
  - Oder manuell: `npm install --legacy-peer-deps`

#### 🔧 Debugging-Tipps

- **Backend startet nicht:** `debug-backend.bat` + VS Code Debugger
- **Frontend Build-Fehler:** `cleanup.bat` → `npm install` → `npm start`
- **Tests schlagen fehl:** `test-backend.bat` für Details

---

### Wartungs-Tabelle

| Script | Häufigkeit | Zweck |
|--------|-----------|-------|
| `startup.bat` | Täglich | Entwicklung starten |
| `test-backend.bat` | Vor jedem Commit | Qualitätssicherung |
| `stop-services.bat` | Täglich | Entwicklung beenden |
| `cleanup.bat` | Wöchentlich | Cache bereinigen |
| `check-dependencies.bat` | Bei Updates | System prüfen |
| `create-artifact.bat` | Bei Releases | Deployment |

---

### Technische Details

#### Verwendete Technologien in Scripts

- **Batch-Befehle:**
  - `setlocal enabledelayedexpansion` - Variable Expansion
  - `taskkill` - Prozess-Verwaltung
  - `netstat` - Port-Prüfung
  - `reg add/delete` - Registry-Verwaltung
  - `where` - Kommando-Prüfung

- **Build-Tools:**
  - Maven (`mvn`)
  - npm
  - Angular CLI (`npx ng`)

- **Java-Flags:**
  - `-agentlib:jdwp` - Debug-Protokoll
  - `-DskipTests` - Tests überspringen

---

## Support und Weiterentwicklung

### Geplante Erweiterungen

- [ ] `test-frontend.bat` - Frontend Unit Tests
- [ ] `test-e2e.bat` - End-to-End Tests
- [ ] `docker-build.bat` - Docker Image Build
- [ ] `deploy.bat` - Automatisches Deployment

### Bekannte Limitationen

- Scripts sind nur für Windows
- Erfordern lokale Installation von Java, Maven, Node.js
- Keine parallele Ausführung mehrerer Instanzen
- Keine automatische Update-Funktion

---

**Dokumentation erstellt:** 23.12.2025  
**Letzte Aktualisierung:** 23.12.2025  
**Version:** 1.0.0
