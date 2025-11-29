# Hangman Artifact Installation Guide

Anleitung zum Installieren und Ausführen des vorkompilierten Hangman-Artifacts.

---

## 📋 Vorraussetzungen

Bevor du das Artifact installierst, stelle sicher, dass du folgende Software installiert hast:

### ✅ Erforderlich
- **Java 17+** (für Backend)
  - Download: [https://www.oracle.com/java/technologies/downloads/](https://www.oracle.com/java/technologies/downloads/)
  - Überprüfung: `java -version`
  
### ✅ Optional (für Entwicklung/Änderungen)
- **Node.js 18+** (für Frontend - nur wenn du Änderungen machst)
  - Download: [https://nodejs.org/](https://nodejs.org/)
  - Überprüfung: `node --version`

- **Maven 3.6+** (für Backend - nur wenn du Änderungen machst)
  - Download: [https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)
  - Überprüfung: `mvn --version`

---

## 🚀 Installation (Windows)

### Schritt 1: Artifact entpacken
1. Finde `hangman-artifact-1.0.0.zip` (oder deine entsprechende Version)
2. Klick mit Rechtsklick → **"Entpacken"** oder ziehe in einen Ordner
   ```
   Beispiel: C:\Programme\hangman-app-1.0.0\
   ```

### Schritt 2: Abhängigkeiten überprüfen
Öffne PowerShell/CMD im entpackten Verzeichnis und führe aus:
```powershell
cd scripts
.\check-dependencies.bat
```

**Erwartete Ausgabe:**
```
[OK] Java 17
[OK] Git
```

Falls Fehler erscheinen → siehe [Troubleshooting](#troubleshooting).

### Schritt 3: Anwendung starten
```powershell
cd scripts
.\startup.bat
```

**Die Anwendung wird gestartet:**
- Backend läuft auf: **http://localhost:8080**
- Frontend läuft auf: **http://localhost:4200**

### Schritt 4: Im Browser öffnen
Öffne deinen Browser und gehe zu:
```
http://localhost:4200
```

---

## 🐧 Installation (Linux / macOS)

### Schritt 1: Artifact entpacken
```bash
unzip hangman-artifact-1.0.0.zip
cd hangman-artifact-1.0.0
```

### Schritt 2: Abhängigkeiten überprüfen
```bash
cd scripts
bash start-backend.sh --check
```

Oder überprüfe manuell:
```bash
java -version
# Sollte Java 17+ zeigen
```

### Schritt 3: Anwendung starten
```bash
cd scripts
bash start-backend.sh
```

### Schritt 4: Im Browser öffnen
```bash
http://localhost:4200
```

---

## 📁 Artifact-Struktur

```
hangman-artifact-1.0.0/
│
├── backend/
│   └── hangman-service-1.0.0.jar    ← Backend (kompiliert)
│
├── frontend/                        ← Frontend (kompiliert)
│   ├── index.html
│   ├── main-XXXXXXX.js
│   ├── polyfills-XXXXXXX.js
│   └── styles-XXXXXXX.css
│
├── config/
│   └── application.yml              ← Backend-Konfiguration
│
├── scripts/
│   ├── startup.bat                  ← Windows Startup
│   ├── startup.ps1                  ← Windows PowerShell
│   ├── start-backend.bat            ← Backend-only (Windows)
│   ├── start-backend.sh             ← Backend-only (Linux/Mac)
│   ├── check-dependencies.bat       ← Abhängigkeitsprüfung
│   └── stop-services.bat            ← Services beenden
│
└── README.md                        ← Artifact-Info
```

---

## 🎮 Spielen

Nach dem Start siehst du die Hangman-Oberfläche:

1. **Klick "Start Game"** → Neues Spiel beginnen
2. **Klick auf Buchstaben** → Buchstabe raten
3. **Gewinnen:** Alle Buchstaben des Wortes finden
4. **Verlieren:** 6 falsche Versuche

---

## 🛑 Services stoppen

### Windows
```batch
cd scripts
stop-services.bat
```

Oder drücke in den laufenden Fenstern `Ctrl+C`.

### Linux/macOS
```bash
pkill -f "java -jar"          # Backend stoppen
pkill -f "ng serve"           # Frontend stoppen (falls lokal)
```

---

## 🔧 Konfiguration

Die Backend-Konfiguration ist in `config/application.yml`:

```yaml
server:
  port: 8080
  
spring:
  datasource:
    url: jdbc:h2:mem:hangman
```

### Änderungen an Konfiguration
1. Bearbeite `config/application.yml`
2. Starte Backend neu
3. Änderungen sind aktiv

---

## 🐛 Troubleshooting

### ❌ Fehler: "java: command not found"
**Lösung:**
- Java 17+ installieren: [https://www.oracle.com/java/technologies/downloads/](https://www.oracle.com/java/technologies/downloads/)
- Nach Installation: PowerShell/CMD neu starten
- Überprüfung: `java -version`

### ❌ Fehler: "Port 8080 is already in use"
**Lösung:**
Anderer Service nutzt Port 8080:
```batch
REM Windows
netstat -ano | findstr :8080
REM Finde PID und stoppe den Prozess
taskkill /PID <PID> /F

REM Linux/Mac
lsof -i :8080
kill -9 <PID>
```

Oder ändere Port in `config/application.yml`:
```yaml
server:
  port: 9090
```

### ❌ Fehler: "Port 4200 is already in use"
**Lösung:** Gleich wie Port 8080 oben.

### ❌ Fehler: "ng build failed"
**Ursache:** Frontend wurde nicht richtig kompiliert.
**Lösung:** 
- Stelle sicher, dass das ZIP vollständig entpackt wurde
- Alle Dateien im `frontend/` Verzeichnis sollten vorhanden sein
- Falls nötig: ZIP neu entpacken

### ❌ Fehler: "Cannot connect to backend"
**Lösung:**
1. Überprüfe, ob Backend läuft: `http://localhost:8080`
2. Öffne Browser-Konsole (F12)
3. Achte auf CORS-Fehler
4. Backend-Logs überprüfen in `scripts/startup.bat` Output

### ❌ Frontend startet nicht
**Ursache:** HTTP-Server startet nicht.
**Lösung:**
- Stelle sicher, dass `frontend/` Verzeichnis nicht leer ist
- Alle `.js` und `.html` Dateien sollten vorhanden sein
- Windows Firewall kann blockieren → erlaube Port 4200

---

## 📊 Ports und URLs

| Service | Port | URL |
|---------|------|-----|
| Backend (API) | 8080 | http://localhost:8080 |
| Frontend (Web) | 4200 | http://localhost:4200 |
| Backend Health | 8080 | http://localhost:8080/api/games |

---

## 🔄 Neu starten

Wenn Services hängen bleiben:

### Windows
```batch
REM Alle Prozesse auf Ports 8080 und 4200 beenden
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-NetTCPConnection -LocalPort @(8080,4200) -State Established | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force }"
```

### Linux/macOS
```bash
kill $(lsof -t -i:8080) $(lsof -t -i:4200)
```

---

## 📝 Logs überprüfen

### Backend-Logs
- Während des Starts sichtbar in `startup.bat` Fenster
- Logs enthalten:
  - Server-Start-Zeit
  - Datenbankverbindung
  - Anfrage-Logs (optional)

### Frontend-Logs
- Browser-Konsole öffnen: `F12` → **Console**
- Dort siehst du:
  - API-Aufrufe
  - Fehler
  - Debugging-Info

---

## 🎓 Weitere Ressourcen

- **API Dokumentation:** `API_TESTING.md` (im Projekt-Root)
- **Architektur-Übersicht:** `ARCHITECTURE.md`
- **Schnellstart:** `QUICK_REFERENCE.md`

---

## ❓ FAQ

**F: Kann ich das Artifact auf einem anderen Computer verwenden?**
A: Ja! Kopiere das ZIP auf einen beliebigen Computer mit Java 17+.

**F: Kann ich die Ports ändern?**
A: Ja! Editiere `config/application.yml` für Backend und nutze Umgebungsvariablen für Frontend.

**F: Ist das Artifact für Production geeignet?**
A: Das ist ein Development-Artifact. Für Production sollte Docker oder ein Application Server verwendet werden.

**F: Kann ich Änderungen am Code machen?**
A: Das Artifact enthält keinen Quellcode. Du brauchst das vollständige Repository mit `src/` Verzeichnis.

**F: Wie viel Speicher braucht die Anwendung?**
A: Typisch 256-512 MB RAM. Bei Speicherproblemen die JVM-Optionen anpassen in `scripts/startup.bat`.

---

## 📞 Support

Falls Probleme auftreten:
1. Überprüfe alle Vorraussetzungen
2. Schau ins Troubleshooting-Kapitel
3. Überprüfe Browser-Konsole (F12)
4. Überprüfe Backend-Output in Kommandozeile

---

**Version:** 1.0.0  
**Erstellt:** 2025-11-29  
**Hangman Game - Vorkompiliertes Deployment-Paket**
