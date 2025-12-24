# Hangman Artifact - Version 2/02_011847

Dies ist ein vorkompiliertes Deployment-Paket für die Hangman-Anwendung.

**Version:** 2/02_011847
**Erstellt:** 24/12/2025  1:18:56,91

## Struktur
```
hangman-artifact/
├── backend/
│   ├── hangman-service-1.0.0.jar
│   └── application.yml
├── frontend/
│   └── (kompilierte Angular App)
├── start-backend.bat       (Startet nur Backend)
├── start-all.bat            (Startet Backend + Anweisungen für Frontend)
└── stop-services.bat        (Stoppt alle Services)
```

## Verwendung

### Backend starten
```batch
start-backend.bat
```
- Backend läuft auf: http://localhost:8080
- API: http://localhost:8080/api/games
- H2 Console: http://localhost:8080/h2-console

### Frontend bereitstellen

Das Frontend ist bereits kompiliert. Öffnen Sie `frontend/index.html` direkt
oder verwenden Sie einen einfachen Web-Server:

**Option 1: Python**
```batch
cd frontend
python -m http.server 4200
```

**Option 2: Node.js http-server**
```batch
npm install -g http-server
cd frontend
http-server -p 4200
```

**Option 3: Live Server (VS Code Extension)**
- Installiere "Live Server" in VS Code
- Rechtsklick auf frontend/index.html
- "Open with Live Server"

Dann öffnen Sie: http://localhost:4200

## Voraussetzungen

### Backend
- Java 17 oder höher

### Frontend (optional)
- Python 3.x oder
- Node.js mit http-server oder
- Beliebiger Web-Server

## Konfiguration

Backend-Konfiguration: `backend/application.yml`

## Technologie-Stack
- Backend: Spring Boot 3.2.0 + Java 17
- Frontend: Angular 18 + TypeScript
- Datenbank: H2 (In-Memory)

## Support
Bei Problemen siehe README.md im Hauptprojekt.
