## Sequence Diagram Implementation

This backend implementation follows the PlantUML sequence diagram provided. Here's how each component maps:

### Game Start Flow
```
Client                     HangmanController           HangmanService          GameRepository          Game(Domain)
  |                              |                           |                      |                      |
  |---POST /games------->|                                    |                      |                      |
  |                       |---startNewGame()--------->|                             |                      |
  |                       |                          |---new Game()-------->|                              |
  |                       |                          |                     |---init: id, mask word----|
  |                       |                          |<------Game---------|                              |
  |                       |---save(Game)---------->|                      |                              |
  |                       |                        |---persist entity----|                              |
  |                       |<------saved----------|                      |                              |
  |<---201 Created--------|                        |                      |                              |
  |{id, maskWord, fails}  |                        |                      |                              |
```

### Guess Flow
```
Client                     HangmanController           HangmanService          GameRepository          Game(Domain)
  |                              |                           |                      |                      |
  |---POST /guess-------->|                                    |                      |                      |
  |{id, letter}           |                                    |                      |                      |
  |                       |---validate(letter)                |                      |                      |
  |                       |                                    |                      |                      |
  |                       |---guess(id, letter)----->|                             |                      |
  |                       |                          |---findById(id)---->|                              |
  |                       |                          |<---Game----------|                              |
  |                       |                          |---guess(letter)----->|---guess logic----|       |
  |                       |                          |                    |<---result---------|       |
  |                       |                          |---save(Game)----->|                              |
  |                       |                          |<---saved---------|                              |
  |<------200 OK----------|                          |                      |                      |
  |{maskWord, fails}      |                          |                      |                      |
```

### Error Handling
```
Bad Request (400):
- Invalid letter format
- Missing game ID
- Non-letter character

Not Found (404):
- Game ID not found in database

Success (200/201):
- Valid request processed
- Returns updated game state
```

## Implementation Details Aligned with Diagram

### 1. StartNewGame (POST /games)
- ✅ HangmanController receives request
- ✅ Calls HangmanService.startNewGame()
- ✅ Service creates Game with random word
- ✅ Game generates masked word internally
- ✅ Service saves via GameRepository
- ✅ Returns GameResponse with id, maskedWord, failedAttempts
- ✅ HTTP 201 Created response

### 2. Guess Processing (POST /games/guess)
- ✅ HangmanController validates letter
- ✅ Returns 400 if invalid
- ✅ Calls HangmanService.guess(id, letter)
- ✅ Service calls GameRepository.findById(id)
- ✅ Returns 404 if not found
- ✅ Service calls Game.guess(letter)
- ✅ Game updates masked word and/or failed attempts
- ✅ Service saves via GameRepository
- ✅ Returns updated game state
- ✅ HTTP 200 OK response

### 3. Game Logic (Game Domain)
- ✅ Tracks: id, word, maskedWord, failedAttempts, guessedLetters, status
- ✅ Handles correct guesses: updates masked word
- ✅ Handles wrong guesses: increments failed attempts
- ✅ Detects win condition: masked word complete
- ✅ Detects loss condition: failed attempts == max
- ✅ Prevents duplicate guesses

### 4. Client-Side Logic Notes (for Angular frontend)
The diagram indicates client should:
- ✅ Store game ID locally after start
- ✅ Maintain local list of guessed letters
- ✅ Prevent duplicate submissions
- ✅ Update display based on maskedWord
- ✅ Draw hangman based on failedAttempts
- ✅ Detect win: no underscores in masked word
- ✅ Detect loss: failedAttempts == maxAttempts (6)
- ✅ Show word on loss (server sends it masked as separate response)

## Files Mapping

| Component | File |
|-----------|------|
| REST Controller | `HangmanController.java` |
| Service Layer | `HangmanService.java` |
| Repository | `GameRepository.java` |
| Domain Model | `Game.java` |
| DTOs | `GameResponse.java`, `GuessRequest.java` |
| Utils | `WordProvider.java` |

## Testing Coverage

All components have corresponding test files:
- `HangmanControllerTest.java` - REST endpoint testing
- `HangmanServiceTest.java` - Service logic testing
- `GameTest.java` - Domain model testing
- `HangmanIntegrationTest.java` - End-to-end testing
