# Architecture Overview

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        Client Applications                              │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │  Angular Frontend (localhost:4200)                             │   │
│  │  ├─ Keyboard Component                                         │   │
│  │  ├─ Word Display Component                                     │   │
│  │  ├─ Hangman Canvas Component                                   │   │
│  │  └─ Status Dialog Component                                    │   │
│  └─────────────────────────────────────────────────────────────────┘   │
└────────────────────────┬─────────────────────────────────────────────────┘
                         │ HTTP/REST (CORS Enabled)
                         │
┌────────────────────────▼─────────────────────────────────────────────────┐
│                   Spring Boot REST API (localhost:8080)                  │
│                                                                           │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │                    HangmanController                            │   │
│  │  ├─ POST /api/games              → startGame()                 │   │
│  │  ├─ POST /api/games/guess        → submitGuess()               │   │
│  │  └─ GET /api/games/{id}          → getGameState()              │   │
│  └────────────────────┬─────────────────────────────────────────────┘   │
│                       │                                                   │
│  ┌────────────────────▼─────────────────────────────────────────────┐   │
│  │                   HangmanService                                │   │
│  │  ├─ startNewGame()      → Creates new Game entity              │   │
│  │  ├─ guess()             → Processes letter guesses             │   │
│  │  └─ getGame()           → Retrieves game state                 │   │
│  └────────────────────┬─────────────────────────────────────────────┘   │
│                       │                                                   │
│  ┌────────────────────▼─────────────────────────────────────────────┐   │
│  │                  GameRepository (JPA)                           │   │
│  │  ├─ save(Game)           → Insert/Update                        │   │
│  │  ├─ findById(String)     → Retrieve                             │   │
│  │  ├─ findAll()            → List all games                       │   │
│  │  └─ delete(Game)         → Delete                               │   │
│  └────────────────────┬─────────────────────────────────────────────┘   │
│                       │                                                   │
│  ┌────────────────────▼─────────────────────────────────────────────┐   │
│  │                 Game Domain Model                               │   │
│  │  ├─ id: String (UUID)                                          │   │
│  │  ├─ word: String                                               │   │
│  │  ├─ maskedWord: String                                         │   │
│  │  ├─ failedAttempts: int                                        │   │
│  │  ├─ guessedLetters: String                                     │   │
│  │  ├─ status: GameStatus                                         │   │
│  │  └─ guess(char): GameGuessResult                               │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                           │
└───────────────────────┬──────────────────────────────────────────────────┘
                        │ JPA/Hibernate
                        │
┌───────────────────────▼──────────────────────────────────────────────────┐
│              H2 In-Memory Database (Development)                         │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │  games table                                                      │  │
│  │  ├─ game_id (PK)         varchar(255)                            │  │
│  │  ├─ word                 varchar(255)                            │  │
│  │  ├─ masked_word          varchar(255)                            │  │
│  │  ├─ failed_attempts      int                                     │  │
│  │  ├─ guessed_letters      varchar(255)                            │  │
│  │  ├─ game_status          varchar(20)                             │  │
│  │  └─ max_attempts         int                                     │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                           │
│  H2 Console: http://localhost:8080/h2-console                           │
└───────────────────────────────────────────────────────────────────────────┘
```

## Request/Response Flow

### 1. New Game Request
```
Client:  POST /api/games
           ↓
Controller: Validate request
           ↓
Service:  startNewGame()
           ├─ WordProvider.getRandomWord()
           ├─ new Game(word)
           └─ GameRepository.save(game)
           ↓
Response: 201 Created
         {
           "id": "xxx",
           "maskedWord": "_ _ _ _",
           "failedAttempts": 0,
           ...
         }
```

### 2. Guess Request
```
Client:  POST /api/games/guess
         {"id": "xxx", "letter": "A"}
           ↓
Controller: Validate letter (not null, is letter)
           ↓
Service:  guess(id, letter)
           ├─ GameRepository.findById(id)
           ├─ game.guess(letter)
           │   ├─ Check if letter in word
           │   ├─ Update masked word OR
           │   ├─ Increment failed attempts
           │   └─ Check win/loss conditions
           └─ GameRepository.save(game)
           ↓
Response: 200 OK
         {
           "id": "xxx",
           "maskedWord": "A _ _ _",
           "failedAttempts": 0,
           ...
         }
```

## Layered Architecture

```
┌─────────────────────────────────┐
│     Presentation Layer          │
│  (HangmanController - REST API) │
│  Input Validation & HTTP Status │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│    Business Logic Layer         │
│   (HangmanService)              │
│  Game orchestration & rules     │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│   Domain Model Layer            │
│   (Game Entity)                 │
│  Core game logic & state        │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│   Data Access Layer             │
│  (GameRepository - JPA)         │
│  Database operations            │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│     Database Layer              │
│   (H2 In-Memory DB)             │
│   Persistent storage            │
└─────────────────────────────────┘
```

## Data Model

```
Game Entity
├── id: String (UUID)
│   └─ Primary Key
│   └─ Unique identifier for game session
│
├── word: String
│   └─ The complete word to guess (e.g., "AUTO")
│   └─ Stored in uppercase
│
├── maskedWord: String
│   └─ Display representation (e.g., "A _ _ _")
│   └─ Updated after each correct guess
│
├── failedAttempts: int
│   └─ Counter for wrong guesses
│   └─ Incremented on incorrect letter
│
├── guessedLetters: String
│   └─ Comma-separated list of attempted letters
│   └─ Used to prevent duplicate guesses
│
├── status: GameStatus (Enum)
│   ├─ ACTIVE: Game in progress
│   ├─ WON: All letters revealed
│   └─ LOST: Max attempts reached
│
└── maxAttempts: int
    └─ Maximum allowed failed attempts (6)
    └─ Game ends when failedAttempts >= maxAttempts
```

## State Transitions

```
         ┌──────────────┐
         │   Created    │
         └──────┬───────┘
                │
    ┌───────────┴──────────────┐
    │                          │
    │   Guess Processing       │
    │                          │
    ▼                          ▼
┌────────────┐          ┌─────────────┐
│  Correct   │          │   Wrong     │
│  Guess     │          │   Guess     │
└────┬───────┘          └─────┬───────┘
     │                        │
     │                   failedAttempts++
     │                        │
     │                        │
Check if won            Check if lost
     │                        │
     ▼                        ▼
┌────────────┐          ┌──────────────┐
│   WON      │          │    LOST      │
│ (All found)│          │  (Max tries) │
└────────────┘          └──────────────┘
     │                        │
     └────────┬───────────────┘
              │
              ▼
        ┌──────────┐
        │ GameOver │
        └──────────┘
```

## Component Interactions

```
Sequence of method calls for a guess:

HangmanController.guess(request)
    │
    ├─ validate(request.letter)
    │   └─ Throws 400 if invalid
    │
    └─ HangmanService.guess(gameId, letter)
        │
        ├─ GameRepository.findById(gameId)
        │   └─ Throws 404 if not found
        │
        ├─ Game.guess(letter)
        │   ├─ Validate not duplicate
        │   ├─ Check if letter in word
        │   ├─ Update masked word OR increment attempts
        │   ├─ Check win condition
        │   ├─ Check loss condition
        │   └─ Return GameGuessResult
        │
        └─ GameRepository.save(game)
            └─ Persist updated game state
```

## Error Handling Flow

```
Request
   │
   ├─ Null/Empty check
   │   └─ 400 Bad Request
   │
   ├─ Format validation
   │   └─ 400 Bad Request
   │
   ├─ Game ID validation
   │   └─ Call GameRepository.findById()
   │   └─ 404 Not Found if empty
   │
   ├─ Business logic
   │   └─ Execute game operations
   │   └─ Handle all outcomes
   │
   └─ Response
       ├─ 200 OK (Success)
       ├─ 201 Created (New resource)
       ├─ 400 Bad Request (Validation)
       ├─ 404 Not Found (Resource missing)
       └─ 500 Internal Server Error (Unexpected)
```

## Deployment Architecture

```
Development:
  ┌─────────────────────────────────┐
  │ Spring Boot Application         │
  │ H2 In-Memory Database          │
  │ localhost:8080                  │
  └─────────────────────────────────┘

Production (with Docker):
  ┌─────────────────────────────────┐
  │ Docker Container                │
  │ ├─ Spring Boot App (port 8080)  │
  │ ├─ H2 Database                  │
  │ └─ Volume (optional persistence)│
  └─────────────────────────────────┘

Advanced (Future):
  ┌─────────────────────────────────┐
  │ Kubernetes Cluster              │
  │ ├─ Spring Boot Pod              │
  │ ├─ PostgreSQL Service           │
  │ ├─ Ingress Controller           │
  │ └─ ConfigMap                    │
  └─────────────────────────────────┘
```

## CORS Configuration

```
Allowed Origins:
  ├─ http://localhost:4200 (Angular dev server)
  └─ http://localhost:3000 (Alternative frontend)

Allowed Methods:
  ├─ GET
  ├─ POST
  ├─ PUT
  ├─ DELETE
  └─ OPTIONS

Allowed Headers:
  └─ * (All headers)

Max Age: 3600 seconds (1 hour)
```

## Test Coverage Pyramid

```
              ┌─────────────┐
              │ Integration │ ← End-to-end flow tests
              │   Tests     │
              ├─────────────┤
              │   Controller│ ← REST endpoint tests
              │   & Service │
              │   Unit Tests│
              ├─────────────┤
              │   Domain    │ ← Game logic unit tests
              │   Unit Tests│
              └─────────────┘
```

## Performance Considerations

- **H2 In-Memory Database**: Fast for development, no disk I/O
- **Stateless Design**: Easy horizontal scaling
- **Transaction Management**: ACID compliance for data integrity
- **Connection Pooling**: Managed by Spring Boot default
- **Logging**: Configured at DEBUG level for trace-ability

---

This architecture provides a clean separation of concerns, making the code maintainable, testable, and scalable.
