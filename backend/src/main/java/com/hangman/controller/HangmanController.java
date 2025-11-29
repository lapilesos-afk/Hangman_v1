package com.hangman.controller;

import com.hangman.domain.Game;
import com.hangman.dto.GameResponse;
import com.hangman.dto.GuessRequest;
import com.hangman.service.HangmanService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/games")
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:3000"})
public class HangmanController {
    
    private final HangmanService hangmanService;
    
    /**
     * Start a new game
     * Test Kommentar
     * POST /api/games
     * @return 201 Created with game details (id, maskedWord, failedAttempts)
     */
    @PostMapping
    public ResponseEntity<GameResponse> startGame() {
        log.info("Received request to start a new game");
        
        try {
            Game game = hangmanService.startNewGame();
            GameResponse response = GameResponse.fromGame(game);
            response.setMessage("Game started successfully");
            
            return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(response);
        } catch (Exception e) {
            log.error("Error starting game", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Submit a guess for a game
     * POST /api/games/guess
     * Request body: {"id": "game-id", "letter": "a"}
     * @param request the guess request
     * @return 200 OK with updated game state (maskedWord, failedAttempts)
     *         400 Bad Request if letter is invalid
     *         404 Not Found if game doesn't exist
     */
    @PostMapping("/guess")
    public ResponseEntity<GameResponse> guess(@RequestBody GuessRequest request) {
        log.info("Received guess request - gameId: {}, letter: {}", request.getId(), request.getLetter());
        
        // Validate request
        if (request.getId() == null || request.getId().isEmpty()) {
            log.warn("Missing game ID in request");
            return ResponseEntity.badRequest()
                .body(new GameResponse(null, null, 0, 0, null, "Game ID is required"));
        }
        
        if (request.getLetter() == null || request.getLetter().isEmpty()) {
            log.warn("Missing letter in request");
            return ResponseEntity.badRequest()
                .body(new GameResponse(null, null, 0, 0, null, "Letter is required"));
        }
        
        try {
            Game updatedGame = hangmanService.guess(request.getId(), request.getLetter());
            GameResponse response = GameResponse.fromGame(updatedGame);
            
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.warn("Invalid request: {}", e.getMessage());
            
            // Determine if it's a 400 or 404
            if (e.getMessage().contains("Game not found")) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new GameResponse(null, null, 0, 0, null, e.getMessage()));
            } else {
                return ResponseEntity.badRequest()
                    .body(new GameResponse(null, null, 0, 0, null, e.getMessage()));
            }
        } catch (Exception e) {
            log.error("Error processing guess", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new GameResponse(null, null, 0, 0, null, "Internal server error"));
        }
    }
    
    /**
     * Get game state
     * GET /api/games/{id}
     * @param id the game ID
     * @return 200 OK with game state
     *         404 Not Found if game doesn't exist
     */
    @GetMapping("/{id}")
    public ResponseEntity<GameResponse> getGame(@PathVariable String id) {
        log.info("Received request to get game: {}", id);
        
        try {
            Game game = hangmanService.getGame(id);
            GameResponse response = GameResponse.fromGame(game);
            
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.warn("Game not found: {}", id);
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(new GameResponse(null, null, 0, 0, null, e.getMessage()));
        } catch (Exception e) {
            log.error("Error retrieving game", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new GameResponse(null, null, 0, 0, null, "Internal server error"));
        }
    }
}
