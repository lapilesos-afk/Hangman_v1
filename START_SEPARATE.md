# Backend und Frontend separat starten

Anleitung zum separaten Starten des Backends und Frontends.

---

## 📋 Übersicht

| Service | Port | Start-Befehl |
|---------|------|--------------|
| **Backend** | 8080 | `.\start-backend.bat` oder `bash start-backend.sh` |
| **Frontend** | 4200 | `.\start-frontend.bat` oder `bash start-frontend.sh` |

---

## 🪟 Windows

### Backend starten

```batch
.\start-backend.bat
```

**Erwartete Ausgabe:**
```
[OK] Java 17
[OK] Maven 3.6+
Building the project...
Starting Spring Boot application...
Backend will be available at: http://localhost:8080
```

Backend läuft auf: **http://localhost:8080**

### Frontend starten (in neuem Terminal/CMD)

```batch
.\start-frontend.bat
```

**Erwartete Ausgabe:**
```
[OK] Node.js found: v18.x.x
[OK] npm found: 9.x.x
Starting Angular Dev Server...
Frontend will be available at: http://localhost:4200
```

Frontend läuft auf: **http://localhost:4200**

### Im Browser öffnen

Öffne: **http://localhost:4200**

---

## 🐧 Linux / macOS

### Backend starten

```bash
bash start-backend.sh
```

Oder (falls executable):
```bash
./start-backend.sh
```

**Erwartete Ausgabe:**
```
[OK] Java 17
[OK] Maven 3.6+
Building the project...
Starting Spring Boot application...
Backend will be available at: http://localhost:8080
```

Backend läuft auf: **http://localhost:8080**

### Frontend starten (in neuem Terminal)

```bash
bash start-frontend.sh
```

Oder (falls executable):
```bash
./start-frontend.sh
```

**Erwartete Ausgabe:**
```
[OK] Node.js found: v18.x.x
[OK] npm found: 9.x.x
Starting Angular Dev Server...
Frontend will be available at: http://localhost:4200
```

Frontend läuft auf: **http://localhost:4200**

### Im Browser öffnen

Öffne: **http://localhost:4200**

---

## 🎯 Typischer Workflow

### 1. Backend starten (Terminal 1)
```batch
.\start-backend.bat
```
Warte bis: `Tomcat started on port(s): 8080`

### 2. Frontend starten (Terminal 2)
```batch
.\start-frontend.bat
```
Warte bis: `Application bundle generation complete`

### 3. Spiel öffnen
Browser: `http://localhost:4200`

### 4. Arbeiten & Entwickeln
- **Backend**: Ändere Java-Dateien → Maven kompiliert automatisch (kurze Pause)
- **Frontend**: Ändere TypeScript/HTML → Angular lädt automatisch neu (Hot Reload)

---

## 🔄 Hot Reload / Auto-Refresh

### Backend
- Nicht standardmäßig aktiviert
- Für Hot Reload: DevTools verwenden oder jedes Mal neu kompilieren

### Frontend (Angular)
- **Automatisch aktiviert!**
- Änderungen an `.ts`, `.html`, `.css` Dateien werden sofort geladen
- Browser aktualisiert sich automatisch

---

## 🛑 Services stoppen

### Backend stoppen
- Im Backend-Terminal: `Ctrl+C` drücken
- oder: `.\stop-services.bat`

### Frontend stoppen
- Im Frontend-Terminal: `Ctrl+C` drücken

### Beide Terminals schließen
- Alle Terminal-Fenster können geschlossen werden

---

## 🔧 Ports ändern

### Backend Port (Standard: 8080)
Editiere `backend/src/main/resources/application.yml`:
```yaml
server:
  port: 9090  # Neuer Port
```

### Frontend Port (Standard: 4200)
Editiere `angular.json`:
```json
"serve": {
  "options": {
    "port": 4300  // Neuer Port
  }
}
```

Oder verwende Command-Line:
```bash
npm start -- --port 4300
```

---

## 📝 Vorraussetzungen

### Backend
- ✅ Java 17+
- ✅ Maven 3.6+
- ✅ Git (optional)

### Frontend
- ✅ Node.js 18+
- ✅ npm 9+

### Check der Installation
```bash
# Backend
java -version
mvn --version

# Frontend
node --version
npm --version
```

---

## 🐛 Troubleshooting

### ❌ Backend startet nicht
**Problem:** "Port 8080 already in use"
```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :8080
kill -9 <PID>
```

### ❌ Frontend startet nicht
**Problem:** "Port 4200 already in use"
```bash
# Windows
netstat -ano | findstr :4200
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :4200
kill -9 <PID>
```

### ❌ npm Dependencies fehlen
```bash
npm install
```

### ❌ Maven Build fehlgeschlagen
```bash
# Cache löschen
mvn clean

# Neu kompilieren
mvn compile
```

---

## 🚀 VS Code Integration

### Backend starten in VS Code
1. **Terminal** → **New Terminal** (`Ctrl+Shift+ö`)
2. Gib ein: `.\start-backend.bat`

### Frontend starten in VS Code
1. **Terminal** → **New Terminal** (`Ctrl+Shift+ö`)
2. Gib ein: `.\start-frontend.bat`

### Mit VS Code Tasks
1. Gehe zu **Tasks** → **Run Task** (`Ctrl+Shift+P` → "Run Task")
2. Wähle die entsprechende Task

---

## 📚 Verwandte Dokumentation

- `BACKEND_DEBUG.md` — Debuggen des Backends
- `ARTIFACT_INSTALL.md` — Installation des vorkompilierten Artifacts
- `QUICK_REFERENCE.md` — Schnellreferenz aller Befehle
- `README.md` — Hauptdokumentation

---

**Zusammenfassung:**
- Backend: `.\start-backend.bat` (Port 8080)
- Frontend: `.\start-frontend.bat` (Port 4200)
- Browser: `http://localhost:4200`
- Stoppen: `Ctrl+C` in den Terminals
