# Hangman Service - Installationsanleitung (Backend/Server)

## Inhaltsverzeichnis
1. [Systemvoraussetzungen](#systemvoraussetzungen)
2. [Installation auf separatem Server](#installation-auf-separatem-server)
3. [Installation auf gleichem PC wie Client](#installation-auf-gleichem-pc-wie-client)
4. [Konfiguration](#konfiguration)
5. [Service starten](#service-starten)
6. [Verifizierung](#verifizierung)
7. [Fehlerbehebung](#fehlerbehebung)

---

## Systemvoraussetzungen

### Minimale Anforderungen
- **Java**: Version 17 oder höher (JDK)
- **Maven**: Version 3.6 oder höher
- **Arbeitsspeicher**: Mindestens 512 MB RAM
- **Festplatte**: 200 MB freier Speicherplatz
- **Betriebssystem**: Windows, Linux, oder macOS

### Überprüfen der installierten Versionen

**Java Version prüfen:**
```bash
java -version
```
Erwartete Ausgabe: `java version "17.x.x"` oder höher

**Maven Version prüfen:**
```bash
mvn -version
```
Erwartete Ausgabe: `Apache Maven 3.6.x` oder höher

### Installation der Voraussetzungen

**Java JDK 17 installieren:**
- **Windows/macOS**: Download von [https://adoptium.net/](https://adoptium.net/)
- **Linux (Ubuntu/Debian)**:
  ```bash
  sudo apt update
  sudo apt install openjdk-17-jdk
  ```

**Maven installieren:**
- **Windows**: Download von [https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)
- **macOS**: 
  ```bash
  brew install maven
  ```
- **Linux (Ubuntu/Debian)**:
  ```bash
  sudo apt update
  sudo apt install maven
  ```

---

## Installation auf separatem Server

Diese Variante ist für den Einsatz auf einem dedizierten Server gedacht, auf den Clients über das Netzwerk zugreifen.

### Schritt 1: Backend-Code auf Server übertragen

**Option A: Mit Git**
```bash
git clone <repository-url>
cd Hangman_v1/backend
```

**Option B: Manueller Transfer**
1. Kopieren Sie den kompletten `backend` Ordner auf den Server
2. Navigieren Sie zum Backend-Verzeichnis:
   ```bash
   cd backend
   ```

### Schritt 2: Projekt bauen

```bash
mvn clean install
```

Dieser Befehl:
- Lädt alle benötigten Abhängigkeiten herunter
- Kompiliert den Quellcode
- Führt Tests aus
- Erstellt die ausführbare JAR-Datei

**Erwartete Ausgabe:**
```
[INFO] BUILD SUCCESS
[INFO] Total time: XX s
```

Die JAR-Datei befindet sich dann unter: `target/hangman-service-1.0.0.jar`

### Schritt 3: Server-Konfiguration anpassen

Erstellen Sie eine `application-prod.yml` für Produktionseinstellungen:

```bash
cd src/main/resources
```

Erstellen Sie die Datei `application-prod.yml`:

```yaml
spring:
  application:
    name: hangman-service
  datasource:
    url: jdbc:h2:mem:hangmandb
    driver-class-name: org.h2.Driver
    username: sa
    password:
  h2:
    console:
      enabled: false  # In Produktion deaktivieren
  jpa:
    database-platform: org.hibernate.dialect.H2Dialect
    hibernate:
      ddl-auto: create-drop
    show-sql: false
    properties:
      hibernate:
        format_sql: false

server:
  port: 8080
  address: 0.0.0.0  # Erlaubt Zugriff von allen Netzwerk-Interfaces

logging:
  level:
    com.hangman: INFO
    org.springframework.web: WARN
  file:
    name: logs/hangman-service.log
```

**Wichtig:** `server.address: 0.0.0.0` erlaubt Zugriff von externen Clients!

### Schritt 4: Firewall-Konfiguration

**Windows Server:**
```powershell
New-NetFirewallRule -DisplayName "Hangman Service" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow
```

**Linux (UFW):**
```bash
sudo ufw allow 8080/tcp
sudo ufw reload
```

**Linux (firewalld):**
```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

### Schritt 5: Service als Hintergrunddienst einrichten

**Option A: Als systemd Service (Linux)**

Erstellen Sie `/etc/systemd/system/hangman-service.service`:

```ini
[Unit]
Description=Hangman Game Service
After=network.target

[Service]
Type=simple
User=hangman
WorkingDirectory=/opt/hangman/backend
ExecStart=/usr/bin/java -jar /opt/hangman/backend/target/hangman-service-1.0.0.jar --spring.profiles.active=prod
SuccessExitStatus=143
TimeoutStopSec=10
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Service aktivieren und starten:
```bash
sudo systemctl daemon-reload
sudo systemctl enable hangman-service
sudo systemctl start hangman-service
sudo systemctl status hangman-service
```

**Option B: Als Windows Service**

Verwenden Sie ein Tool wie [NSSM](https://nssm.cc/) (Non-Sucking Service Manager):

```powershell
# NSSM herunterladen und installieren
nssm install HangmanService "C:\Program Files\Java\jdk-17\bin\java.exe" "-jar C:\hangman\backend\target\hangman-service-1.0.0.jar --spring.profiles.active=prod"
nssm set HangmanService AppDirectory "C:\hangman\backend"
nssm start HangmanService
```

### Schritt 6: Client-Zugriff konfigurieren

Clients müssen die Server-IP-Adresse kennen. Passen Sie die Frontend-Konfiguration an:

In `src/app/environments/environment.prod.ts`:
```typescript
export const environment = {
  production: true,
  apiUrl: 'http://SERVER_IP_ADRESSE:8080/api'
};
```

Ersetzen Sie `SERVER_IP_ADRESSE` durch die tatsächliche IP des Servers (z.B. `192.168.1.100`).

---

## Installation auf gleichem PC wie Client

Diese Variante ist für lokale Entwicklung oder wenn Backend und Frontend auf demselben Computer laufen.

### Schritt 1: Backend-Verzeichnis öffnen

```bash
cd C:\Users\lapil\Studium\SWL\Hangman_v1\backend
```

### Schritt 2: Projekt bauen

```bash
mvn clean install
```

### Schritt 3: Backend starten

**Option A: Mit Maven (empfohlen für Entwicklung)**
```bash
mvn spring-boot:run
```

**Option B: Mit JAR-Datei**
```bash
java -jar target/hangman-service-1.0.0.jar
```

**Option C: Mit bereitgestelltem Batch-Script (Windows)**
```bash
cd ..
.\start-backend.bat
```

**Option D: Mit PowerShell-Script**
```powershell
cd ..
.\startup.ps1
```

### Schritt 4: Beide Services gleichzeitig starten

**Windows (mit Batch-Datei):**
```bash
# Im Hauptverzeichnis
.\startup.bat
```

**Mit VS Code Tasks:**
- Drücken Sie `Ctrl+Shift+P`
- Wählen Sie "Tasks: Run Task"
- Wählen Sie "start backend and frontend"

Das Backend läuft auf: `http://localhost:8080`
Das Frontend läuft auf: `http://localhost:4200`

---

## Konfiguration

### Port ändern

Falls Port 8080 bereits belegt ist, können Sie ihn ändern:

**In `application.yml`:**
```yaml
server:
  port: 8090  # Gewünschter Port
```

**Beim Start als Parameter:**
```bash
java -jar target/hangman-service-1.0.0.jar --server.port=8090
```

### CORS-Konfiguration

Wenn Frontend und Backend auf unterschiedlichen Hosts laufen, passen Sie die CORS-Einstellungen an.

Die aktuelle Konfiguration erlaubt bereits alle Origins (`*`). Für Produktion sollten Sie spezifische Origins angeben:

```java
// In HangmanController.java
@CrossOrigin(origins = "http://192.168.1.50:4200")
```

### Logging-Level anpassen

**In `application.yml`:**
```yaml
logging:
  level:
    com.hangman: DEBUG  # DEBUG, INFO, WARN, ERROR
```

---

## Service starten

### Entwicklungsmodus

**Backend:**
```bash
cd backend
mvn spring-boot:run
```

**Frontend (in separatem Terminal):**
```bash
npm start
```

### Produktionsmodus

**Backend als JAR:**
```bash
cd backend
java -jar target/hangman-service-1.0.0.jar --spring.profiles.active=prod
```

**Im Hintergrund (Linux/Mac):**
```bash
nohup java -jar target/hangman-service-1.0.0.jar --spring.profiles.active=prod > logs/hangman.log 2>&1 &
```

**Im Hintergrund (Windows):**
```powershell
Start-Process java -ArgumentList "-jar","target/hangman-service-1.0.0.jar","--spring.profiles.active=prod" -WindowStyle Hidden
```

---

## Verifizierung

### 1. Service-Status prüfen

**Health Check Endpoint:**
```bash
curl http://localhost:8080/actuator/health
```

Oder im Browser öffnen: `http://localhost:8080/actuator/health`

### 2. API-Endpunkte testen

**Neues Spiel starten:**
```bash
curl -X POST http://localhost:8080/api/games -H "Content-Type: application/json"
```

**Erwartete Antwort:**
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "maskedWord": "_ _ _ _",
  "failedAttempts": 0,
  "maxAttempts": 6,
  "status": "ACTIVE",
  "message": "Game started successfully"
}
```

### 3. H2-Konsole (nur Entwicklung)

Öffnen Sie im Browser: `http://localhost:8080/h2-console`

**Verbindungsdetails:**
- JDBC URL: `jdbc:h2:mem:hangmandb`
- Username: `sa`
- Password: (leer lassen)

### 4. Logs überprüfen

**Konsolenausgabe:**
Beim Start sollten Sie sehen:
```
Started HangmanApplication in X.XXX seconds
Tomcat started on port(s): 8080 (http)
```

**Log-Datei:**
```bash
tail -f logs/hangman-service.log
```

---

## Fehlerbehebung

### Problem: "Port 8080 already in use"

**Lösung 1: Anderen Port verwenden**
```bash
java -jar target/hangman-service-1.0.0.jar --server.port=8090
```

**Lösung 2: Prozess auf Port 8080 beenden**

Windows:
```powershell
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

Linux/Mac:
```bash
lsof -i :8080
kill -9 <PID>
```

### Problem: "Java not found"

**Lösung:**
1. Überprüfen Sie die Java-Installation: `java -version`
2. Fügen Sie Java zum PATH hinzu:
   - Windows: Systemumgebungsvariablen → PATH → `C:\Program Files\Java\jdk-17\bin`
   - Linux: `export JAVA_HOME=/usr/lib/jvm/java-17-openjdk`

### Problem: "Maven not found"

**Lösung:**
1. Überprüfen Sie die Maven-Installation: `mvn -version`
2. Installieren Sie Maven (siehe [Systemvoraussetzungen](#systemvoraussetzungen))

### Problem: "Connection refused" vom Client

**Mögliche Ursachen:**
1. Backend läuft nicht → Starten Sie den Service
2. Falsche URL im Frontend → Überprüfen Sie `environment.ts`
3. Firewall blockiert Port → Öffnen Sie Port 8080
4. CORS-Problem → Überprüfen Sie CORS-Konfiguration

**Debugging:**
```bash
# Auf dem Server testen
curl http://localhost:8080/api/games

# Vom Client-PC testen
curl http://SERVER_IP:8080/api/games
```

### Problem: "Out of Memory"

**Lösung:** Mehr Heap-Speicher zuweisen
```bash
java -Xmx1024m -jar target/hangman-service-1.0.0.jar
```

### Problem: Service startet nicht als systemd Service

**Debugging:**
```bash
sudo journalctl -u hangman-service -f
```

Überprüfen Sie:
- Pfade in der Service-Datei sind korrekt
- Benutzer hat Ausführungsrechte
- Java ist im PATH verfügbar

---

## Erweiterte Konfiguration

### Performance-Optimierung

```bash
java -Xms256m -Xmx512m -XX:+UseG1GC -jar target/hangman-service-1.0.0.jar
```

### Reverse Proxy (nginx)

Für Produktionsumgebungen empfiehlt sich ein Reverse Proxy:

```nginx
server {
    listen 80;
    server_name hangman.example.com;

    location /api/ {
        proxy_pass http://localhost:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### SSL/TLS aktivieren

Erstellen Sie ein Keystore:
```bash
keytool -genkeypair -alias hangman -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore keystore.p12 -validity 3650
```

**In `application.yml`:**
```yaml
server:
  port: 8443
  ssl:
    enabled: true
    key-store: classpath:keystore.p12
    key-store-password: changeit
    key-store-type: PKCS12
    key-alias: hangman
```

---

## Zusammenfassung

### Schnellstart (gleicher PC)
```bash
# Im Hauptverzeichnis
cd backend
mvn clean install
mvn spring-boot:run
```

### Schnellstart (Server)
```bash
# Auf dem Server
cd backend
mvn clean install
java -jar target/hangman-service-1.0.0.jar --spring.profiles.active=prod
```

### Nützliche Befehle

| Aktion | Befehl |
|--------|--------|
| Backend bauen | `mvn clean install` |
| Backend starten (Dev) | `mvn spring-boot:run` |
| Backend starten (Prod) | `java -jar target/hangman-service-1.0.0.jar` |
| Logs anzeigen | `tail -f logs/hangman-service.log` |
| Service stoppen | `Ctrl+C` oder `taskkill /F /IM java.exe` |
| Tests ausführen | `mvn test` |

---

## Support und Dokumentation

- **API-Dokumentation**: Siehe [backend/README.md](README.md)
- **Architektur**: Siehe [ARCHITECTURE.md](../ARCHITECTURE.md)
- **Frontend-Setup**: Siehe [BACKEND_SETUP.md](../BACKEND_SETUP.md)

**Weitere Hilfe benötigt?**
Überprüfen Sie die Logs unter `logs/hangman-service.log` für detaillierte Fehlerinformationen.
