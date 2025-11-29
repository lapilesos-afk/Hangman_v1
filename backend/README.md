# Hangman Service - Backend REST API

## Overview

Complete Java Spring Boot backend service for the Hangman game, implementing the REST API according to the PlantUML sequence diagram.

## Architecture

### Components

1. **HangmanController** (REST)
   - Handles HTTP requests for game start and letter guessing
   - Validates input and manages error responses
   - CORS-enabled for frontend communication

2. **HangmanService** (Business Logic)
   - Orchestrates game operations
   - Manages game lifecycle
   - Handles guess processing and game state updates

3. **GameRepository** (Data Access)
   - JPA repository for database persistence
   - CRUD operations for Game entities
   - Uses H2 in-memory database for development

4. **Game (Domain Model)**
   - Represents a game instance
   - Manages word masking logic
   - Tracks game state (active, won, lost)
   - Properties: id, word, maskedWord, failedAttempts, guessedLetters, status

## REST API Endpoints

### Start New Game
```
POST /api/games
Content-Type: application/json

Response (201 Created):
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "maskedWord": "_ _ _ _",
  "failedAttempts": 0,
  "maxAttempts": 6,
  "status": "ACTIVE",
  "message": "Game started successfully"
}
```

### Submit Guess
```
POST /api/games/guess
Content-Type: application/json

Request:
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "letter": "A"
}

Response (200 OK):
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "maskedWord": "A _ _ _",
  "failedAttempts": 0,
  "maxAttempts": 6,
  "status": "ACTIVE",
  "message": "Correct guess!"
}

Error Responses:
- 400 Bad Request: Invalid letter or missing game ID
- 404 Not Found: Game not found
- 500 Internal Server Error: Server error
```

### Get Game State
```
GET /api/games/{id}

Response (200 OK):
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "maskedWord": "A _ _ _",
  "failedAttempts": 0,
  "maxAttempts": 6,
  "status": "ACTIVE",
  "message": ""
}

Error Responses:
- 404 Not Found: Game not found
```

## Game Flow

### 1. Game Start
- Client sends POST /api/games
- Service creates new Game with random word
- Game generates masked word and initializes state
- Server responds with game ID, masked word, and failed attempts

### 2. Letter Guess
- Client sends POST /api/games/guess with game ID and letter
- Controller validates input
- Service retrieves game from repository
- Game processes guess:
  - If correct: Update masked word
  - If wrong: Increment failed attempts
  - If reached max attempts: Mark as LOST, reveal word
  - If word complete: Mark as WON
- Service saves updated game
- Server responds with updated game state

### 3. Game End Conditions
- **Win**: Masked word is completely revealed
- **Loss**: Failed attempts reach maximum (6)
- **Active**: Game continues

## Database Schema

### Games Table
```sql
CREATE TABLE games (
  game_id VARCHAR(255) PRIMARY KEY,
  word VARCHAR(255) NOT NULL,
  masked_word VARCHAR(255) NOT NULL,
  failed_attempts INT NOT NULL,
  guessed_letters VARCHAR(255),
  game_status VARCHAR(20) NOT NULL,
  max_attempts INT NOT NULL
);
```

## Dependencies

### Main Dependencies
- Spring Boot 3.2.0
- Spring Boot Starter Web (REST API)
- Spring Boot Starter Data JPA (Database)
- H2 Database (In-memory storage)
- Lombok (Reduce boilerplate)
- Jakarta Persistence API

### Test Dependencies
- Spring Boot Test
- JUnit 5
- Mockito

## Running the Backend

### Prerequisites
- Java 17 or higher
- Maven 3.6+

### Build
```bash
cd backend
mvn clean install
```

### Run
```bash
mvn spring-boot:run
```

The server will start on `http://localhost:8080`

### Access H2 Console
Navigate to: `http://localhost:8080/h2-console`
- JDBC URL: `jdbc:h2:mem:hangmandb`
- Username: `sa`
- Password: (leave empty)

## Testing

### Run All Tests
```bash
mvn test
```

### Test Coverage
- **HangmanServiceTest**: 
  - Starting new games
  - Processing correct guesses
  - Processing wrong guesses
  - Error handling for invalid game IDs
  - Validation of input

- **HangmanControllerTest**:
  - Starting games
  - Processing guesses
  - Error responses
  - HTTP status codes

## Configuration

File: `application.yml`

```yaml
server:
  port: 8080

spring:
  datasource:
    url: jdbc:h2:mem:hangmandb
  jpa:
    hibernate:
      ddl-auto: create-drop
```

## Frontend Integration

The Angular frontend can connect to this backend using:

```typescript
// Start game
POST http://localhost:8080/api/games

// Submit guess
POST http://localhost:8080/api/games/guess
Body: { id: "gameId", letter: "A" }

// Get game state
GET http://localhost:8080/api/games/{gameId}
```

CORS is enabled for:
- `http://localhost:4200` (Angular dev server)
- `http://localhost:3000` (Alternative frontend server)

## Project Structure

```
backend/
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/com/hangman/
│   │   │   ├── HangmanServiceApplication.java
│   │   │   ├── controller/
│   │   │   │   └── HangmanController.java
│   │   │   ├── service/
│   │   │   │   ├── HangmanService.java
│   │   │   │   └── WordProvider.java
│   │   │   ├── repository/
│   │   │   │   └── GameRepository.java
│   │   │   ├── domain/
│   │   │   │   ├── Game.java
│   │   │   │   └── GameGuessResult.java
│   │   │   └── dto/
│   │   │       ├── GameResponse.java
│   │   │       └── GuessRequest.java
│   │   └── resources/
│   │       └── application.yml
│   └── test/
│       └── java/com/hangman/
│           ├── service/
│           │   └── HangmanServiceTest.java
│           └── controller/
│               └── HangmanControllerTest.java
```

## Error Handling

All errors are handled gracefully with appropriate HTTP status codes:

- **400 Bad Request**: Invalid input (non-letter, empty field)
- **404 Not Found**: Game not found in database
- **500 Internal Server Error**: Unexpected server error

## Security Considerations

- CORS configured for specific origins
- Input validation on all endpoints
- SQL injection prevention (JPA parameterized queries)
- No sensitive data exposure in responses

## Future Enhancements

- Add user authentication
- Persist games across restarts
- Add game statistics/leaderboard
- Add word difficulty levels
- Add multiplayer support
- Add API documentation with Swagger/OpenAPI
