# Hangman Game - Full Stack Application

A complete Hangman game implementation with Angular frontend and Spring Boot backend REST API.

## Project Structure

```
Hangman_v1/
├── src/                    # Angular Frontend
│   ├── app/
│   ├── components/
│   ├── services/
│   └── ...
├── backend/                # Spring Boot Backend
│   ├── src/
│   ├── pom.xml
│   └── README.md
├── angular.json
├── package.json
└── README.md (this file)
```

## Technology Stack

### Frontend
- **Framework**: Angular 18+
- **Language**: TypeScript
- **Styling**: CSS
- **Components**: 
  - Keyboard component
  - Word display component
  - Hangman canvas component
  - Status dialog component

### Backend
- **Framework**: Spring Boot 3.2.0
- **Language**: Java 17
- **Database**: H2 (in-memory)
- **ORM**: JPA/Hibernate
- **Build Tool**: Maven

## Quick Start

### Prerequisites
- Node.js 18+ and npm
- Java 17+
- Maven 3.6+

### Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Build the project:
```bash
mvn clean install
```

3. Run the Spring Boot application:
```bash
mvn spring-boot:run
```

Backend will be available at: `http://localhost:8080`

### Frontend Setup

1. Install dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm start
```

Frontend will be available at: `http://localhost:4200`

## API Documentation

### Start New Game
```
POST http://localhost:8080/api/games
Response: 201 Created
{
  "id": "game-id",
  "maskedWord": "_ _ _ _",
  "failedAttempts": 0,
  "maxAttempts": 6,
  "status": "ACTIVE"
}
```

### Submit Guess
```
POST http://localhost:8080/api/games/guess
Request:
{
  "id": "game-id",
  "letter": "A"
}
Response: 200 OK
{
  "id": "game-id",
  "maskedWord": "A _ _ _",
  "failedAttempts": 0,
  "maxAttempts": 6,
  "status": "ACTIVE"
}
```

### Get Game State
```
GET http://localhost:8080/api/games/{id}
Response: 200 OK
{
  "id": "game-id",
  "maskedWord": "A _ _ _",
  "failedAttempts": 0,
  "maxAttempts": 6,
  "status": "ACTIVE"
}
```

## Architecture Overview

The application follows a layered architecture pattern:

```
┌─────────────────────────────┐
│   Angular Frontend (4200)    │
└──────────────┬──────────────┘
               │ HTTP/REST
┌──────────────▼──────────────┐
│  Spring Boot API (8080)     │
│  ├─ HangmanController       │
│  ├─ HangmanService          │
│  ├─ GameRepository          │
│  └─ Game Domain             │
└──────────────┬──────────────┘
               │ JPA
┌──────────────▼──────────────┐
│   H2 Database (in-memory)   │
└─────────────────────────────┘
```

### Component Details

1. **HangmanController**: REST endpoint handler
   - POST /api/games - Start new game
   - POST /api/games/guess - Submit letter guess
   - GET /api/games/{id} - Get game state

2. **HangmanService**: Business logic layer
   - Game creation and initialization
   - Guess processing
   - Game state management

3. **GameRepository**: Data access layer
   - CRUD operations
   - Database persistence

4. **Game Domain**: Entity model
   - Word masking
   - Guess validation
   - State transitions

## Game Rules

1. The server randomly selects a word
2. Player guesses one letter at a time
3. Correct guesses reveal letters in the word
4. Wrong guesses increment the attempt counter
5. Maximum 6 failed attempts
6. Game ends when:
   - All letters are revealed (WIN)
   - 6 incorrect guesses are made (LOSS)

## Testing

### Run Backend Tests
```bash
cd backend
mvn test
```

### Run Frontend Tests
```bash
npm test
```

## Development Notes

### Adding New Words
Edit `backend/src/main/java/com/hangman/service/WordProvider.java`

### Changing Maximum Attempts
Edit the `maxAttempts` field in `Game.java` constructor

### Modifying CORS Settings
Edit the `CorsConfig` in `HangmanServiceApplication.java`

## Frontend Development

The Angular application runs on `http://localhost:4200` and communicates with the Spring Boot backend on `http://localhost:8080`.

Key components:
- `app.component.ts` - Main component
- `game.service.ts` - API communication
- `keyboard.component.ts` - Letter input
- `word-display.component.ts` - Word visualization
- `hangman-canvas.component.ts` - Hangman drawing
- `status-dialog.component.ts` - Game status

## Backend Development

The Spring Boot application exposes a REST API that follows RESTful conventions with proper:
- HTTP status codes
- Error handling
- Input validation
- CORS support

## Troubleshooting

### Backend won't start
- Ensure Java 17 is installed: `java -version`
- Check if port 8080 is available
- Run: `mvn clean install` first

### Frontend can't connect to backend
- Ensure backend is running on 8080
- Check CORS configuration
- Verify network connectivity

### Database issues
- H2 console available at: `http://localhost:8080/h2-console`
- JDBC URL: `jdbc:h2:mem:hangmandb`
- Database resets on server restart

## Further Documentation

- Frontend README: See `src/` directory
- Backend README: See `backend/README.md`
- Backend API specs follow the PlantUML sequence diagram provided

## License

Educational project

## Authors

Hangman Game - Full Stack Development
