# 🎯 Hangman Game - Start Guide

## ⚡ SOFORT STARTEN

**Einfach auf diese Datei doppelklicken:**

```
→ startup.bat
```

Das ist alles! Backend und Frontend starten automatisch.

---

## 📋 Was wird benötigt?

Vor dem ersten Start müssen installiert sein:

- ✅ **Java 17+** - https://www.oracle.com/java/technologies/downloads/
- ✅ **Node.js + npm** - https://nodejs.org/
- ✅ **Maven 3.8+** - https://maven.apache.org/

**Schnell überprüfen:**
```bash
check-dependencies.bat
```

---

## 📁 Wichtige Dateien

### 🚀 Start-Skripte
| Datei | Beschreibung |
|-------|-------------|
| `startup.bat` | **← HIER KLICKEN** zum Starten |
| `startup-advanced.bat` | Erweiterte Version mit Logging |
| `startup.ps1` | PowerShell Version (macOS/Linux) |

### 📖 Dokumentation
| Datei | Inhalt |
|-------|--------|
| `QUICK_START.md` | Schnelleinstieg (2 Min) |
| `SETUP_NO_DOCKER.md` | Detaillierte Anleitung |
| `ARCHITECTURE.md` | Systemarchitektur |
| `BACKEND_SETUP.md` | Backend-Konfiguration |
| `API_TESTING.md` | REST API Endpoints |
| `README.md` | Allgemeine Info |

### 🛠️ Hilfsskripte
| Datei | Zweck |
|-------|-------|
| `check-dependencies.bat` | System-Anforderungen prüfen |
| `stop-services.bat` | Services beenden |
| `cleanup.bat` | Cache löschen & Reset |

---

## 🎮 Spielen

Nach dem Start öffnet sich automatisch:
- **Frontend**: http://localhost:4200
- **Backend**: http://localhost:8080

---

## ❌ Probleme?

1. **Check-Dependencies ausführen:**
   ```bash
   check-dependencies.bat
   ```

2. **Fehlende Installation?**
   - Java, Node.js oder Maven installieren
   - (Links siehe oben)

3. **Port in Verwendung?**
   ```bash
   stop-services.bat
   ```

4. **Cache-Probleme?**
   ```bash
   cleanup.bat
   startup.bat
   ```

---

## 📊 Projekt-Info

```
Backend:  Spring Boot 3.2 (Java 17) - Port 8080
Frontend: Angular 20 (Node.js) - Port 4200
Database: H2 (In-Memory)
```

**Struktur:**
```
Hangman_v1/
├── backend/          # Spring Boot REST API
├── src/              # Angular Frontend
├── startup.bat       # ← CLICK HERE
└── ...
```

---

## 🚀 Nächste Schritte

1. ✅ Voraussetzungen installieren (Java, Node.js, Maven)
2. ✅ `check-dependencies.bat` ausführen
3. ✅ `startup.bat` doppelklicken
4. ✅ Spielen auf http://localhost:4200
5. 📖 Weitere Infos in `QUICK_START.md` oder `SETUP_NO_DOCKER.md`

---

## 💡 Tipps

- **Erste Ausführung dauert länger** - Maven und npm laden Dependencies
- **Logs** werden in `logs/` Verzeichnis gespeichert
- **Hot Reload** ist aktiviert - Änderungen werden automatisch neugeladen
- **H2 Console** verfügbar unter: http://localhost:8080/h2-console

---

**Fragen?** Siehe `SETUP_NO_DOCKER.md` oder `README.md`

**Viel Spaß! 🎯**
