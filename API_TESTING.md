# API Testing Guide

## Using cURL

### Start a New Game
```bash
curl -X POST http://localhost:8080/api/games \
  -H "Content-Type: application/json" \
  -v
```

Response Example:
```json
{
  "id": "a1b2c3d4-e5f6-4789-a012-b3c4d5e6f7a8",
  "maskedWord": "_ _ _ _",
  "failedAttempts": 0,
  "maxAttempts": 6,
  "status": "ACTIVE",
  "message": "Game started successfully"
}
```

### Submit a Guess
```bash
curl -X POST http://localhost:8080/api/games/guess \
  -H "Content-Type: application/json" \
  -d '{
    "id": "a1b2c3d4-e5f6-4789-a012-b3c4d5e6f7a8",
    "letter": "A"
  }' \
  -v
```

### Get Game State
```bash
curl -X GET http://localhost:8080/api/games/a1b2c3d4-e5f6-4789-a012-b3c4d5e6f7a8 \
  -H "Content-Type: application/json" \
  -v
```

## Using Postman

### 1. Create a new Request Collection: "Hangman API"

### 2. Start New Game
- **Method**: POST
- **URL**: `http://localhost:8080/api/games`
- **Headers**: `Content-Type: application/json`
- **Body**: (empty)

### 3. Submit Guess
- **Method**: POST
- **URL**: `http://localhost:8080/api/games/guess`
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "id": "{{gameId}}",
  "letter": "A"
}
```

### 4. Get Game State
- **Method**: GET
- **URL**: `http://localhost:8080/api/games/{{gameId}}`
- **Headers**: `Content-Type: application/json`

## Using TypeScript/Angular

```typescript
import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class GameApiService {
  private apiUrl = 'http://localhost:8080/api/games';

  constructor(private http: HttpClient) {}

  startGame(): Observable<any> {
    return this.http.post(this.apiUrl, {});
  }

  submitGuess(gameId: string, letter: string): Observable<any> {
    return this.http.post(`${this.apiUrl}/guess`, {
      id: gameId,
      letter: letter
    });
  }

  getGameState(gameId: string): Observable<any> {
    return this.http.get(`${this.apiUrl}/${gameId}`);
  }
}
```

## Using Python

```python
import requests
import json

BASE_URL = "http://localhost:8080/api/games"

# Start new game
response = requests.post(BASE_URL)
game = response.json()
print(f"Game ID: {game['id']}")
print(f"Masked Word: {game['maskedWord']}")

# Submit guess
guess_response = requests.post(
    f"{BASE_URL}/guess",
    json={
        "id": game['id'],
        "letter": "A"
    }
)
print(f"After guess: {guess_response.json()}")

# Get game state
state = requests.get(f"{BASE_URL}/{game['id']}")
print(f"Current state: {state.json()}")
```

## Using JavaScript/Node.js

```javascript
const BASE_URL = "http://localhost:8080/api/games";

// Start new game
async function startGame() {
  const response = await fetch(BASE_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' }
  });
  return await response.json();
}

// Submit guess
async function submitGuess(gameId, letter) {
  const response = await fetch(`${BASE_URL}/guess`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ id: gameId, letter: letter })
  });
  return await response.json();
}

// Get game state
async function getGameState(gameId) {
  const response = await fetch(`${BASE_URL}/${gameId}`);
  return await response.json();
}

// Usage
(async () => {
  const game = await startGame();
  console.log(`Started game: ${game.id}`);
  console.log(`Masked word: ${game.maskedWord}`);
  
  const result = await submitGuess(game.id, 'A');
  console.log(`After guess: ${result.maskedWord}`);
})();
```

## Error Scenarios

### Invalid Game ID
```bash
curl -X POST http://localhost:8080/api/games/guess \
  -H "Content-Type: application/json" \
  -d '{"id": "invalid-id", "letter": "A"}'
```
Response: 404 Not Found

### Invalid Letter
```bash
curl -X POST http://localhost:8080/api/games/guess \
  -H "Content-Type: application/json" \
  -d '{"id": "valid-id", "letter": "123"}'
```
Response: 400 Bad Request

### Missing Fields
```bash
curl -X POST http://localhost:8080/api/games/guess \
  -H "Content-Type: application/json" \
  -d '{"id": "valid-id"}'
```
Response: 400 Bad Request

## Testing Tools Recommendations

1. **Postman** - User-friendly GUI, great for learning
2. **cURL** - Command line, simple and powerful
3. **Insomnia** - Similar to Postman, lightweight
4. **VS Code REST Client** - Extension for VS Code
5. **Swagger UI** - If API documentation is added
