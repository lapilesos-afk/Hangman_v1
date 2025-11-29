package com.hangman.service;

import com.hangman.domain.Game;
import com.hangman.repository.GameRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class HangmanServiceTest {
    
    @Mock
    private GameRepository gameRepository;
    
    private HangmanService hangmanService;
    
    @BeforeEach
    public void setUp() {
        hangmanService = new HangmanService(gameRepository);
    }
    
    @Test
    public void testStartNewGame() {
        // Arrange
        when(gameRepository.save(any(Game.class))).thenAnswer(invocation -> invocation.getArgument(0));
        
        // Act
        Game game = hangmanService.startNewGame();
        
        // Assert
        assertNotNull(game);
        assertNotNull(game.getId());
        assertNotNull(game.getWord());
        assertEquals(0, game.getFailedAttempts());
        assertTrue(game.getMaskedWord().contains("_"));
        verify(gameRepository, times(1)).save(any(Game.class));
    }
    
    @Test
    public void testGuessCorrectLetter() {
        // Arrange
        Game game = new Game("AUTO");
        when(gameRepository.findById(game.getId())).thenReturn(Optional.of(game));
        when(gameRepository.save(any(Game.class))).thenAnswer(invocation -> invocation.getArgument(0));
        
        // Act
        Game result = hangmanService.guess(game.getId(), "A");
        
        // Assert
        assertNotNull(result);
        assertEquals(0, result.getFailedAttempts());
        assertTrue(result.getMaskedWord().startsWith("A"));
        verify(gameRepository, times(1)).findById(game.getId());
        verify(gameRepository, times(1)).save(any(Game.class));
    }
    
    @Test
    public void testGuessWrongLetter() {
        // Arrange
        Game game = new Game("AUTO");
        when(gameRepository.findById(game.getId())).thenReturn(Optional.of(game));
        when(gameRepository.save(any(Game.class))).thenAnswer(invocation -> invocation.getArgument(0));
        
        // Act
        Game result = hangmanService.guess(game.getId(), "Z");
        
        // Assert
        assertNotNull(result);
        assertEquals(1, result.getFailedAttempts());
        verify(gameRepository, times(1)).findById(game.getId());
        verify(gameRepository, times(1)).save(any(Game.class));
    }
    
    @Test
    public void testGuessGameNotFound() {
        // Arrange
        when(gameRepository.findById("invalid-id")).thenReturn(Optional.empty());
        
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> 
            hangmanService.guess("invalid-id", "A"));
        verify(gameRepository, times(1)).findById("invalid-id");
    }
    
    @Test
    public void testGuessInvalidLetter() {
        // Arrange
        Game game = new Game("AUTO");
        
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> 
            hangmanService.guess(game.getId(), "123"));
    }
}
