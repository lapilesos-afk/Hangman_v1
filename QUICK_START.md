# Quick Start Guide - Hangman Game (No Docker)

## ⚡ Schnellstart (2 Minuten)

### Voraussetzungen installieren
```bash
# 1. Java 17+ 
# Download: https://www.oracle.com/java/technologies/downloads/

# 2. Node.js + npm
# Download: https://nodejs.org/

# 3. Maven
# Download: https://maven.apache.org/
```

### Alles überprüfen
```bash
# Doppelklick auf:
check-dependencies.bat
```

### Starten!
```bash
# Doppelklick auf:
startup.bat
```

Das war's! 🎉

- Frontend: http://localhost:4200
- Backend: http://localhost:8080

---

## 📁 Verfügbare Skripte

| Skript | Zweck |
|--------|-------|
| `startup.bat` | **EMPFOHLEN** - Automatischer Start (einfach) |
| `startup-advanced.bat` | Erweiterte Version mit Logging |
| `startup.ps1` | PowerShell Alternative (macOS/Linux) |
| `check-dependencies.bat` | System-Anforderungen überprüfen |
| `stop-services.bat` | Alle Services beenden |
| `cleanup.bat` | Caches und Build-Artefakte löschen |

---

## 🔧 Manuelle Befehle (falls nötig)

### Terminal 1: Backend starten
```bash
cd backend
mvn spring-boot:run
```

### Terminal 2: Frontend starten
```bash
npm start
```

---

## 🐛 Häufige Probleme

### Port bereits in Verwendung?
```bash
# Stop-Services ausführen:
stop-services.bat
```

### Dependencies-Fehler?
```bash
# Cleanup ausführen und neu starten:
cleanup.bat
startup.bat
```

### Fehlende Abhängigkeiten?
```bash
# Check ausführen:
check-dependencies.bat
```

---

## 📝 Projektstruktur

```
Hangman_v1/
├── backend/                    # Spring Boot REST API (Port 8080)
│   ├── src/main/java/
│   │   └── com/hangman/
│   │       ├── controller/     # REST Endpoints
│   │       ├── service/        # Business Logic
│   │       ├── domain/         # Game Models
│   │       └── repository/     # Data Access
│   └── pom.xml
├── src/                        # Angular Frontend (Port 4200)
│   └── app/
│       ├── services/           # API Services
│       └── components/         # UI Components
└── startup.bat                 # ← START HERE
```

---

## 🎮 Spielen

1. Frontend öffnet sich automatisch: http://localhost:4200
2. Klick auf "New Game"
3. Rate Buchstaben
4. Gewinne oder verliere!

---

## 💡 Tipps

- **Logs**: Check `logs/` folder für Details
- **Backend-Dokumentation**: `BACKEND_SETUP.md`
- **Frontend-Dokumentation**: `README.md`
- **API-Spezifikation**: `API_TESTING.md`

---

## 📞 Weitere Infos

- **Vollständige Anleitung**: `SETUP_NO_DOCKER.md`
- **Architektur**: `ARCHITECTURE.md`
- **Implementation Guide**: `backend/IMPLEMENTATION_GUIDE.md`

---

**Viel Spaß beim Spielen! 🎯**
