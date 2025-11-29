# 🎯 Hangman Game - Local Setup Complete!

## ✅ Was wurde implementiert?

Ihr Hangman-Projekt ist jetzt komplett eingerichtet für den lokalen Start **ohne Docker**:

### 🚀 Start-Skripte (Batch-Dateien)

```
startup.bat                    ← Hauptskript: Alles automatisch starten
startup-advanced.bat           ← Erweiterte Version mit Logging
startup.ps1                    ← PowerShell Version (macOS/Linux)
```

**Wie zu verwenden:**
1. Doppelklick auf `startup.bat`
2. Das Skript überprüft automatisch:
   - ✓ Java 17+ Installation
   - ✓ Maven Installation  
   - ✓ Node.js/npm Installation
   - ✓ Verfügbare Ports (8080, 4200)
3. Backend wird kompiliert
4. Frontend-Dependencies werden installiert
5. Backend startet auf Port 8080
6. Frontend startet auf Port 4200

---

## 📁 Hilfsskripte

### System-Management

```bash
check-dependencies.bat         # Überprüft Voraussetzungen
stop-services.bat              # Beendet Backend & Frontend
cleanup.bat                    # Löscht Cache & Build-Artefakte
```

### Windows Integration (Optional)

```bash
setup-context-menu.bat         # Fügt "Start Hangman" zum Kontextmenü hinzu
cleanup-context-menu.bat       # Entfernt Kontextmenü-Integration
```

---

## 📖 Dokumentation

### Schnelleinstieg
- **`START_HERE.md`** - Überblick (dieses Verzeichnis)
- **`QUICK_START.md`** - 2-Minuten Anleitung

### Detaillierte Anleitungen
- **`SETUP_NO_DOCKER.md`** - Vollständige Installationsanleitung
- **`BACKEND_SETUP.md`** - Backend-Konfiguration
- **`API_TESTING.md`** - REST API Endpoints
- **`ARCHITECTURE.md`** - Systemarchitektur

---

## 🛠️ Voraussetzungen (Müssen installiert sein!)

### 1. Java Development Kit (JDK) 17+
```bash
# Überprüfen:
java -version

# Download wenn nicht installiert:
# https://www.oracle.com/java/technologies/downloads/
```

### 2. Node.js + npm
```bash
# Überprüfen:
node --version
npm --version

# Download wenn nicht installiert:
# https://nodejs.org/
```

### 3. Apache Maven 3.8+
```bash
# Überprüfen:
mvn --version

# Download wenn nicht installiert:
# https://maven.apache.org/download.cgi
```

---

## 🎮 Starten in 3 Schritten

### Schritt 1: Voraussetzungen installieren
Falls noch nicht geschehen:
- Java 17+ herunterladen und installieren
- Node.js LTS herunterladen und installieren
- Maven herunterladen und installieren

### Schritt 2: Überprüfen
```bash
check-dependencies.bat
```

### Schritt 3: Starten!
```bash
startup.bat
```

Das war es! Der Browser öffnet sich automatisch.

---

## 🌐 Nach dem Start

### Verfügbare URLs

```
Frontend:     http://localhost:4200    (Angular)
Backend API:  http://localhost:8080    (Spring Boot)
Backend Docs: http://localhost:8080/api/v1/games
H2 Console:   http://localhost:8080/h2-console
```

### Logs

Alle Logs werden gespeichert in:
```
logs/
├── backend.log           # Spring Boot Output
├── frontend.log          # Angular CLI Output
├── backend-build.log     # Maven Build Output
└── npm-install.log       # npm Installation
```

---

## 🏗️ Projektstruktur

```
Hangman_v1/
│
├── 🚀 START SCRIPTS
│   ├── startup.bat                ← Hier klicken!
│   ├── startup-advanced.bat
│   ├── startup.ps1
│   ├── check-dependencies.bat
│   ├── stop-services.bat
│   └── cleanup.bat
│
├── 📖 DOCUMENTATION
│   ├── START_HERE.md              ← Sie sind hier
│   ├── QUICK_START.md
│   ├── SETUP_NO_DOCKER.md
│   ├── ARCHITECTURE.md
│   ├── BACKEND_SETUP.md
│   ├── API_TESTING.md
│   └── README.md
│
├── 🎯 BACKEND (Spring Boot)
│   ├── backend/
│   │   ├── src/main/java/com/hangman/
│   │   │   ├── controller/        # REST Endpoints
│   │   │   ├── service/           # Business Logic
│   │   │   ├── domain/            # Game Models
│   │   │   ├── dto/               # Data Transfer Objects
│   │   │   ├── repository/        # Data Access Layer
│   │   │   └── HangmanServiceApplication.java
│   │   ├── src/main/resources/
│   │   │   └── application.yml    # Configuration
│   │   ├── pom.xml                # Maven Build File
│   │   └── Dockerfile             # (für zukünftige Docker-Nutzung)
│   │
│   └── target/                    # Build Output (auto-generated)
│
├── 🎨 FRONTEND (Angular)
│   ├── src/
│   │   ├── app/
│   │   │   ├── services/          # API Services
│   │   │   ├── components/        # UI Components
│   │   │   ├── app.component.*
│   │   │   └── app.routes.ts
│   │   ├── main.ts
│   │   └── styles.css
│   ├── angular.json               # Angular Config
│   ├── package.json               # npm Config
│   ├── tsconfig.json              # TypeScript Config
│   └── node_modules/              # Dependencies (auto-generated)
│
└── 📁 OTHER
    ├── docker-compose.yml         # (optional)
    ├── logs/                      # Application logs
    └── .gitignore
```

---

## ⚙️ Systemanforderungen

| Komponente | Minimum | Empfohlen |
|-----------|---------|-----------|
| Java | 17 | 21+ |
| Node.js | 18 | 20 LTS |
| Maven | 3.8 | 3.9+ |
| RAM | 4 GB | 8 GB |
| Festplatte | 2 GB | 5 GB |

---

## 🐛 Troubleshooting

### Problem: Java nicht gefunden
```bash
# Lösung:
1. Laden Sie Java 17+ von: https://www.oracle.com/java/technologies/downloads/
2. Stellen Sie sicher, dass JAVA_HOME gesetzt ist:
   Windows: Umgebungsvariablen → New → JAVA_HOME → 
            Pfad zum Java-Installationsverzeichnis
3. Starten Sie cmd neu und versuchen Sie erneut:
   java -version
```

### Problem: Maven nicht gefunden
```bash
# Lösung:
1. Laden Sie Maven von: https://maven.apache.org/download.cgi
2. Entpacken Sie es in ein Verzeichnis (z.B. C:\Maven)
3. Fügen Sie zum PATH hinzu:
   Umgebungsvariablen → PATH → C:\Maven\bin
4. Starten Sie cmd neu:
   mvn --version
```

### Problem: npm/Node.js nicht gefunden
```bash
# Lösung:
1. Laden Sie Node.js LTS von: https://nodejs.org/
2. Installieren Sie es (npm wird automatisch installiert)
3. Starten Sie cmd neu:
   npm --version
```

### Problem: Port 8080 oder 4200 bereits in Verwendung
```bash
# Lösung 1: Services beenden
stop-services.bat

# Lösung 2: Andere Anwendung auf dem Port finden und beenden
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### Problem: Erstes Build dauert sehr lange
```
Das ist normal! Maven und npm laden zum ersten Mal große Mengen an Dependencies.
Erste Ausführung: 5-10 Minuten
Weitere Ausführungen: 30-60 Sekunden
```

---

## 🔄 Workflow

### Entwicklung

```bash
# 1. Terminal 1: Backend starten (Auto-Reload aktiviert)
cd backend
mvn spring-boot:run

# 2. Terminal 2: Frontend starten (HMR aktiviert)
npm start

# 3. Code bearbeiten → Automatisches Reload!
```

### Production Build

```bash
# Backend JAR erstellen
cd backend
mvn clean package

# Frontend für Production bauen
ng build --prod
```

---

## 📚 Weitere Ressourcen

- **Spring Boot**: https://spring.io/projects/spring-boot
- **Angular**: https://angular.io
- **Maven**: https://maven.apache.org
- **H2 Database**: https://www.h2database.com

---

## ✨ Features der Startup-Skripte

✅ Automatische Abhängigkeitsprüfung
✅ Automatisches Build von Backend
✅ Automatisches Installation von npm-Packages
✅ Gleichzeitiges Starten von Backend & Frontend
✅ Automatisches Öffnen im Browser
✅ Detailliertes Logging in `logs/` Verzeichnis
✅ Fehlerbehandlung und aussagekräftige Meldungen
✅ Port-Verfügbarkeitsprüfung
✅ Cross-Platform Support (PowerShell Script für macOS/Linux)

---

## 🎯 Zusammenfassung

| Was | Wie | Wann |
|-----|-----|------|
| **System überprüfen** | `check-dependencies.bat` | Vor dem ersten Start |
| **Alles starten** | `startup.bat` | Jeden Tag |
| **Logs prüfen** | `logs/` Verzeichnis | Bei Problemen |
| **Services stoppen** | `stop-services.bat` | Vor erneutem Start |
| **Cache löschen** | `cleanup.bat` | Bei Problemen |

---

## 🚀 Sie sind bereit!

**Nächster Schritt:**
```bash
startup.bat
```

**Viel Spaß beim Spielen! 🎮**

---

**Fragen?** Siehe `SETUP_NO_DOCKER.md` oder `QUICK_START.md`
