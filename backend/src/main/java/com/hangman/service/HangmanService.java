package com.hangman.service;

import com.hangman.domain.Game;
import com.hangman.domain.GameGuessResult;
import com.hangman.repository.GameRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class HangmanService {
    
    private final GameRepository gameRepository;
    
    /**
     * Starts a new game with a random word
     * @return the newly created Game
     */
    public Game startNewGame() {
        log.info("Starting new Hangman game");
        
        String randomWord = WordProvider.getRandomWord();
        Game game = new Game(randomWord);
        
        // Save to repository
        Game savedGame = gameRepository.save(game);
        log.info("Game created with ID: {}, Word: {}", savedGame.getId(), randomWord);
        
        return savedGame;
    }
    
    /**
     * Starts a new game with a random word and specified maximum attempts
     * @param maxAttempts the maximum number of attempts for the game
     * @return the newly created Game
     */
    public Game startNewGame(int maxAttempts) {
        log.info("Starting new Hangman game with max attempts: {}", maxAttempts);
        
        String randomWord = WordProvider.getRandomWord();
        Game game = new Game(randomWord);
        game.setMaxAttempts(maxAttempts);  // Set maximum attempts from client
        
        // Save to repository
        Game savedGame = gameRepository.save(game);
        log.info("Game created with ID: {}, Word: {}, Max Attempts: {}", 
                 savedGame.getId(), randomWord, maxAttempts);
        
        return savedGame;
    }
    
    /**
     * Processes a guess for a specific game
     * @param gameId the game ID
     * @param letter the guessed letter
     * @return the updated Game
     * @throws IllegalArgumentException if game not found or invalid letter
     */
    public Game guess(String gameId, String letter) {
        log.info("Processing guess for game {}: {}", gameId, letter);
        
        // Validate letter
        if (letter == null || letter.isEmpty() || letter.length() != 1) {
            log.warn("Invalid letter provided: {}", letter);
            throw new IllegalArgumentException("Letter must be a single character");
        }
        
        char guessChar = letter.charAt(0);
        if (!Character.isLetter(guessChar)) {
            log.warn("Non-letter character provided: {}", guessChar);
            throw new IllegalArgumentException("Input must be a letter");
        }
        
        // Find game
        Optional<Game> gameOptional = gameRepository.findById(gameId);
        if (gameOptional.isEmpty()) {
            log.error("Game not found with ID: {}", gameId);
            throw new IllegalArgumentException("Game not found with ID: " + gameId);
        }
        
        Game game = gameOptional.get();
        
        // Check if game is already over
        if (game.isGameOver()) {
            log.warn("Game {} is already over with status: {}", gameId, game.getStatus());
            throw new IllegalArgumentException("Game is already over");
        }
        
        // Process guess
        GameGuessResult result = game.guess(guessChar);
        log.info("Guess result for game {}: correct={}, gameOver={}, message={}",
                gameId, result.isCorrect(), result.isGameOver(), result.getMessage());
        
        // Save updated game
        Game updatedGame = gameRepository.save(game);
        
        return updatedGame;
    }
    
    /**
     * Retrieves a game by ID
     * @param gameId the game ID
     * @return the Game
     * @throws IllegalArgumentException if game not found
     */
    public Game getGame(String gameId) {
        return gameRepository.findById(gameId)
            .orElseThrow(() -> new IllegalArgumentException("Game not found with ID: " + gameId));
    }
}
