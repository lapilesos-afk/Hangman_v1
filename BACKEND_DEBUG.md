# Backend Debug Guide

Anleitung zum Debuggen des Hangman-Backends mit VS Code.

---

## 🐛 Debug-Modi

Es gibt zwei Möglichkeiten, das Backend zu debuggen:

### 1️⃣ Direct Launch (Empfohlen für Anfänger)
Backend wird direkt in VS Code mit Breakpoints gestartet.

### 2️⃣ Attach (Für bereits laufenden Server)
Backend läuft bereits, VS Code verbindet sich zum Debuggen.

---

## 🚀 Method 1: Direct Launch in VS Code

### Schritt 1: Breakpoint setzen
1. Öffne eine Java-Datei, z.B. `backend/src/main/java/com/hangman/service/HangmanService.java`
2. Klick auf die Zeilennummer, um einen Breakpoint zu setzen (roter Punkt)
3. Beispiel: Breakpoint bei der `guess()` Methode

### Schritt 2: Debug starten
1. Gehe zu **Run** → **Start Debugging** (oder drücke `F5`)
2. Wähle **"Backend Debug (Java)"** aus
3. Backend kompiliert und startet im Debug-Modus
4. Warte auf die Nachricht: `"Tomcat started on port(s): 8080"`

### Schritt 3: Spiel spielen zum Triggern von Breakpoints
1. Öffne Browser: `http://localhost:4200`
2. Starte ein Spiel und klick auf Buchstaben
3. Der Code stoppt bei deinem Breakpoint!

### Schritt 4: Debugging Controls
In VS Code siehst du die Debug-Toolbar:
- ▶️ **Continue** (F5) - Code fortsetzen bis zum nächsten Breakpoint
- ⏸️ **Pause** - Code anhalten
- ⏭️ **Step Over** (F10) - Eine Zeile ausführen
- ⬇️ **Step Into** (F11) - In eine Funktion hineinspringen
- ⬆️ **Step Out** (Shift+F11) - Aus einer Funktion herausspringen

### Schritt 5: Variablen inspizieren
- Links im **Variables**-Bereich siehst du alle Variablen
- Hover über Variablen im Code um ihren Wert zu sehen
- **Watch**-Bereich: Füge Expressions hinzu zum Beobachten

---

## 🔌 Method 2: Attach to Running Process

### Schritt 1: Backend im Debug-Modus starten
```batch
.\debug-backend.bat
```

Oder im Terminal:
```bash
cd backend
mvn spring-boot:run -DskipTests "-Dspring-boot.run.jvmArguments=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
```

Backend gibt aus:
```
Listening for transport dt_socket at address: 5005
Tomcat started on port(s): 8080
```

### Schritt 2: Breakpoints setzen
1. Öffne Java-Dateien in VS Code
2. Setze Breakpoints (rote Punkte bei Zeilennummern)

### Schritt 3: Debugger verbinden
1. Gehe zu **Run** → **Start Debugging**
2. Wähle **"Attach to Java Process (Remote Debug)"**
3. VS Code verbindet sich zum Backend auf Port 5005

### Schritt 4: Code triggern
- Öffne `http://localhost:4200`
- Spiele das Spiel
- Code stoppt bei Breakpoints

---

## 📍 Breakpoints

### Breakpoint setzen
- Klick auf Zeilennummer links im Editor
- Roter Punkt = Breakpoint aktiv

### Conditional Breakpoint
- Rechtsklick auf Breakpoint → **Edit Breakpoint**
- Bedingung eingeben (z.B.: `gameId == 1`)
- Breakpoint stoppt nur wenn Bedingung erfüllt

### Logpoint (statt Breakpoint)
- Rechtsklick → **Add Logpoint**
- Nachricht eingeben (z.B.: `"Guess: " + letter`)
- Logs den Wert statt zu stoppen

---

## 🔍 Beliebte Debug-Szenarien

### Szenario 1: API-Aufruf debuggen
```java
// In HangmanController.java - Breakpoint hier setzen
@PostMapping("/games/guess")
public ResponseEntity<GameResponse> guess(@RequestBody GuessRequest request) {
    // Breakpoint hier: Code stoppt wenn API aufgerufen wird
    return ResponseEntity.ok(service.guess(...));
}
```

### Szenario 2: Geschäftslogik überprüfen
```java
// In HangmanService.java - Breakpoint hier setzen
public GameGuessResult guess(Game game, char letter) {
    // Breakpoint: Schaue die Variablen an
    boolean isCorrect = game.getWord().contains(letter);
    // ...
}
```

### Szenario 3: Datenbankzugriff überprüfen
```java
// In GameRepository.java - Breakpoint hier setzen
Game game = gameRepository.findById(gameId).orElse(null);
// Inspiziere das game-Objekt
```

---

## 📊 Debug-Views in VS Code

### Variables
- Zeige alle lokalen Variablen
- Zeige Objektinhalte expandierbar

### Watch
- Gib Custom-Expressions ein
- Z.B.: `game.getWord()` um das Wort zu sehen

### Call Stack
- Zeigt alle aufgerufenen Funktionen
- Klick um zwischen Stack-Frames zu wechseln

### Debug Console
- Führe Java-Code zur Laufzeit aus
- Z.B.: `game.getWord()` eingeben und Enter drücken

---

## ⚙️ Debug-Konfigurationen Anpassen

### In `.vscode/launch.json`:

```json
{
  "name": "Backend Debug (Java)",
  "vmArgs": "-Xmx512m -Xms256m",  // JVM Memory: Min 256MB, Max 512MB
  "console": "integratedTerminal"  // Output im integrierten Terminal
}
```

Anpassungen:
- **vmArgs**: JVM-Optionen (Speicher, Properties, etc.)
- **console**: "integratedTerminal" oder "externalTerminal"

---

## 🛑 Debug stoppen

### In VS Code
1. Klick auf **Stop** (Quadrat-Symbol) in der Debug-Toolbar
2. Oder: `Ctrl+Shift+F5`

### Terminal beenden
- Drücke `Ctrl+C` im Maven-Terminal

---

## 🐛 Häufige Debug-Probleme

### ❌ Problem: "Cannot connect to debugger"
**Lösung:**
- Stelle sicher, dass Backend im Debug-Modus läuft
- Port 5005 ist nicht blockiert
- Firewall erlaubt Port 5005

### ❌ Problem: "Breakpoint not hit"
**Lösung:**
- Code ist in einer anderen Klasse als erwartet
- Breakpoint-Bedingung ist false
- Code wird mit Caching/Optimierungen ausgeführt
- Lösung: `mvn clean compile` vor Debug

### ❌ Problem: "Source code does not match bytecode"
**Lösung:**
- Backend neu kompilieren: `mvn clean compile`
- Breakpoints neu setzen

---

## 📝 Debug-Tipps

1. **Systematisch debuggen**
   - Starte mit dem äußersten Layer (Controller)
   - Arbeite dich nach innen vor (Service → Repository)

2. **Watches verwenden**
   - Beobachte wichtige Variablen
   - Kombiniere mehrere Felder (z.B. `game.getId() + ": " + game.getWord()`)

3. **Conditional Breakpoints**
   - Breakpoint nur wenn `gameId == 123`
   - Spart Zeit bei Schleifen

4. **Logpoints statt Breakpoints**
   - Für häufig ausgeführten Code
   - Langsamer als normale Logs, aber hilfreich

5. **Remote Debugging in Production**
   - SSH zum Server
   - Backend mit JDWP starten
   - VS Code verbindet sich über Port-Forward

---

## 🎓 Weiterführende Ressourcen

- [VS Code Java Debugging](https://code.visualstudio.com/docs/java/java-debugging)
- [Java Debug Wire Protocol (JDWP)](https://docs.oracle.com/en/java/javase/17/docs/specs/jpda/conndebug.html)
- [Spring Boot Debug](https://spring.io/blog/2020/08/06/getting-started-with-spring-cloud-config-server)

---

**Viel Erfolg beim Debuggen!** 🚀
