# Hangman Game - Local Setup Guide (No Docker)

Diese Anleitung beschreibt die lokale Installation und den Start von Backend und Frontend ohne Docker.

## Voraussetzungen

Das Projekt benötigt folgende Programme auf Ihrem System:

### 1. **Java Development Kit (JDK) 17+**
   - **Download:** https://www.oracle.com/java/technologies/downloads/
   - **Verifikation:**
     ```bash
     java -version
     ```
   - **Sollte zeigen:** `java version "17.x.x"` oder höher

### 2. **Node.js und npm**
   - **Download:** https://nodejs.org/ (LTS Version empfohlen)
   - **Verifikation:**
     ```bash
     node --version
     npm --version
     ```
   - **Sollte zeigen:** `node v20.x.x` oder höher

### 3. **Apache Maven 3.8+**
   - **Download:** https://maven.apache.org/download.cgi
   - **Installation:** Entpacken und zum PATH hinzufügen
   - **Verifikation:**
     ```bash
     mvn --version
     ```
   - **Sollte zeigen:** `Apache Maven 3.8.x` oder höher

## Installation

### Windows

#### Option 1: Automatisch mit Batch-Datei (Empfohlen)

```batch
# Doppelklick auf:
startup.bat
```

Dies wird automatisch:
- ✓ Java, npm und Maven überprüfen
- ✓ Backend kompilieren
- ✓ Frontend-Abhängigkeiten installieren
- ✓ Backend starten (Port 8080)
- ✓ Frontend starten (Port 4200)

#### Option 2: Manuell

```batch
# Terminal 1 - Backend starten:
cd backend
mvn spring-boot:run

# Terminal 2 - Frontend starten:
npm start
```

#### Option 3: PowerShell-Skript

```powershell
# PowerShell ausführen als Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\startup.ps1
```

### macOS / Linux

```bash
# Option 1: PowerShell-Skript
pwsh ./startup.ps1

# Option 2: Manuell
# Terminal 1:
cd backend
mvn spring-boot:run

# Terminal 2:
npm start
```

## URLs

Nach erfolgreichem Start:

- **Frontend:** http://localhost:4200
- **Backend API:** http://localhost:8080
- **Backend Health:** http://localhost:8080/actuator/health

## Projektstruktur

```
Hangman_v1/
├── backend/                      # Spring Boot REST API
│   ├── src/
│   │   └── main/java/com/hangman/
│   │       ├── controller/       # REST Endpoints
│   │       ├── service/          # Business Logic
│   │       ├── domain/           # Domain Models
│   │       ├── dto/              # Data Transfer Objects
│   │       └── repository/       # Data Access
│   └── pom.xml                   # Maven Configuration
├── src/                          # Angular Frontend
│   ├── app/
│   │   ├── services/             # API Services
│   │   └── components/           # UI Components
│   └── index.html
├── startup.bat                   # Automatischer Start (Windows)
├── startup.ps1                   # PowerShell Start-Skript
├── package.json                  # npm Configuration
└── README.md
```

## Fehlerbehebung

### Problem: "Java nicht gefunden"
```
Lösung: Java 17+ installieren und zum PATH hinzufügen
- Windows: Umgebungsvariablen > PATH > java bin Ordner hinzufügen
- macOS/Linux: export PATH=$JAVA_HOME/bin:$PATH
```

### Problem: "Maven nicht gefunden"
```
Lösung: Maven installieren und zum PATH hinzufügen
- Download: https://maven.apache.org/download.cgi
- Entpacken und bin Verzeichnis zum PATH hinzufügen
```

### Problem: "npm: command not found"
```
Lösung: Node.js von https://nodejs.org/ installieren
```

### Problem: Port 8080/4200 bereits in Verwendung
```
Lösung 1: Andere Anwendung beenden
Lösung 2: Ports in application.yml (Backend) und angular.json (Frontend) ändern
```

### Problem: "node_modules" Fehler
```
Lösung: npm cache leeren und neu installieren
npm cache clean --force
npm install
```

## Backend-Konfiguration

**Datei:** `backend/src/main/resources/application.yml`

```yaml
server:
  port: 8080
  servlet:
    context-path: /api

spring:
  application:
    name: hangman-service
  jpa:
    database-platform: org.hibernate.dialect.H2Dialect
    hibernate:
      ddl-auto: create-drop
  h2:
    console:
      enabled: true
```

## Frontend-Konfiguration

**Datei:** `angular.json`

```json
{
  "serve": {
    "options": {
      "port": 4200
    }
  }
}
```

## Performance-Tipps

1. **Erste Ausführung dauert länger:** Maven und npm müssen Abhängigkeiten herunterladen
2. **Rebuild beschleunigen:** `mvn clean install -o` (offline Mode)
3. **Frontend HMR:** Angular Hot Module Replacement ist aktiviert
4. **Backend Auto-Reload:** Spring Dev Tools ermöglichen schnelle Neustarts

## Logs

Logs werden automatisch in `logs/` Verzeichnis gespeichert:
- `backend.log` - Spring Boot Output
- `frontend.log` - Angular CLI Output
- `backend-build.log` - Maven Build Output
- `npm-install.log` - npm Install Output

## Weitere Ressourcen

- **Spring Boot Docs:** https://spring.io/projects/spring-boot
- **Angular Docs:** https://angular.io/docs
- **Maven Docs:** https://maven.apache.org/guides/

## Support

Bei Problemen überprüfen Sie:
1. Alle Voraussetzungen sind installiert (`java -version`, `npm --version`, `mvn --version`)
2. Ports 4200 und 8080 sind frei
3. Logs in `logs/` Verzeichnis für Fehlerdetails
4. Firewall erlaubt localhost-Zugriff
