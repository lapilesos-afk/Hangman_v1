package com.hangman.controller;

import com.hangman.domain.Game;
import com.hangman.dto.GameResponse;
import com.hangman.dto.GuessRequest;
import com.hangman.dto.StartGameRequest;
import com.hangman.service.HangmanService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class HangmanControllerTest {
    
    @Mock
    private HangmanService hangmanService;
    
    private HangmanController controller;
    
    @BeforeEach
    public void setUp() {
        controller = new HangmanController(hangmanService);
    }
    
    // ============= START GAME TESTS =============
    
    @Test
    public void testStartGame_Success() {
        // Arrange
        Game mockGame = new Game("JAVA");
        when(hangmanService.startNewGame(anyInt())).thenReturn(mockGame);
        
        // Act
        ResponseEntity<GameResponse> response = controller.startGame(null);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(mockGame.getId(), response.getBody().getId());
        assertTrue(response.getBody().getMaskedWord().contains("_"));
        assertEquals(0, response.getBody().getFailedAttempts());
        assertEquals("ACTIVE", response.getBody().getStatus());
        verify(hangmanService, times(1)).startNewGame(15); // Default max attempts
    }
    
    @Test
    public void testStartGame_WithCustomMaxAttempts() {
        // Arrange
        Game mockGame = new Game("JAVA");
        mockGame.setMaxAttempts(10);
        StartGameRequest request = new StartGameRequest();
        request.setMaxAttempts(10);
        when(hangmanService.startNewGame(10)).thenReturn(mockGame);
        
        // Act
        ResponseEntity<GameResponse> response = controller.startGame(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(10, response.getBody().getMaxAttempts());
        verify(hangmanService, times(1)).startNewGame(10);
    }
    
    // ============= GUESS TESTS =============
    
    @Test
    public void testGuess_CorrectLetter_Success() {
        // Arrange
        Game mockGame = new Game("JAVA");
        mockGame.guess('J'); // First correct guess
        GuessRequest request = new GuessRequest(mockGame.getId(), "J");
        when(hangmanService.guess(mockGame.getId(), "J")).thenReturn(mockGame);
        
        // Act
        ResponseEntity<GameResponse> response = controller.guess(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(0, response.getBody().getFailedAttempts());
        verify(hangmanService, times(1)).guess(mockGame.getId(), "J");
    }
    
    @Test
    public void testGuess_WrongLetter_Success() {
        // Arrange
        Game mockGame = new Game("JAVA");
        mockGame.guess('Z'); // Wrong guess
        GuessRequest request = new GuessRequest(mockGame.getId(), "Z");
        when(hangmanService.guess(mockGame.getId(), "Z")).thenReturn(mockGame);
        
        // Act
        ResponseEntity<GameResponse> response = controller.guess(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(1, response.getBody().getFailedAttempts());
        verify(hangmanService, times(1)).guess(mockGame.getId(), "Z");
    }
    
    @Test
    public void testGuess_GameWon() {
        // Arrange
        Game mockGame = new Game("CAT");
        mockGame.guess('C');
        mockGame.guess('A');
        mockGame.guess('T'); // Should win
        GuessRequest request = new GuessRequest(mockGame.getId(), "T");
        when(hangmanService.guess(mockGame.getId(), "T")).thenReturn(mockGame);
        
        // Act
        ResponseEntity<GameResponse> response = controller.guess(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals("WON", response.getBody().getStatus());
        assertEquals("C A T", response.getBody().getMaskedWord()); // Masked word has spaces
        verify(hangmanService, times(1)).guess(mockGame.getId(), "T");
    }
    
    @Test
    public void testGuess_GameLost() {
        // Arrange
        Game mockGame = new Game("AUTO");
        // Make 6 wrong guesses
        mockGame.guess('Z');
        mockGame.guess('X');
        mockGame.guess('Q');
        mockGame.guess('W');
        mockGame.guess('B');
        mockGame.guess('V'); // 6th wrong guess - game lost
        GuessRequest request = new GuessRequest(mockGame.getId(), "V");
        when(hangmanService.guess(mockGame.getId(), "V")).thenReturn(mockGame);
        
        // Act
        ResponseEntity<GameResponse> response = controller.guess(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals("LOST", response.getBody().getStatus());
        assertEquals(6, response.getBody().getFailedAttempts());
        assertEquals("AUTO", response.getBody().getMaskedWord()); // Word revealed
        verify(hangmanService, times(1)).guess(mockGame.getId(), "V");
    }
    
    @Test
    public void testGuess_MissingGameId_BadRequest() {
        // Arrange
        GuessRequest request = new GuessRequest(null, "A");
        
        // Act
        ResponseEntity<GameResponse> response = controller.guess(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals("Game ID is required", response.getBody().getMessage());
        verify(hangmanService, never()).guess(any(), any());
    }
    
    @Test
    public void testGuess_EmptyGameId_BadRequest() {
        // Arrange
        GuessRequest request = new GuessRequest("", "A");
        
        // Act
        ResponseEntity<GameResponse> response = controller.guess(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals("Game ID is required", response.getBody().getMessage());
        verify(hangmanService, never()).guess(any(), any());
    }
    
    @Test
    public void testGuess_MissingLetter_BadRequest() {
        // Arrange
        GuessRequest request = new GuessRequest("some-id", null);
        
        // Act
        ResponseEntity<GameResponse> response = controller.guess(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals("Letter is required", response.getBody().getMessage());
        verify(hangmanService, never()).guess(any(), any());
    }
    
    @Test
    public void testGuess_EmptyLetter_BadRequest() {
        // Arrange
        GuessRequest request = new GuessRequest("some-id", "");
        
        // Act
        ResponseEntity<GameResponse> response = controller.guess(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals("Letter is required", response.getBody().getMessage());
        verify(hangmanService, never()).guess(any(), any());
    }
    
    @Test
    public void testGuess_GameNotFound_NotFound() {
        // Arrange
        GuessRequest request = new GuessRequest("invalid-id", "A");
        when(hangmanService.guess("invalid-id", "A"))
            .thenThrow(new IllegalArgumentException("Game not found with ID: invalid-id"));
        
        // Act
        ResponseEntity<GameResponse> response = controller.guess(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().getMessage().contains("Game not found"));
        verify(hangmanService, times(1)).guess("invalid-id", "A");
    }
    
    @Test
    public void testGuess_InvalidLetter_BadRequest() {
        // Arrange
        GuessRequest request = new GuessRequest("some-id", "1");
        when(hangmanService.guess("some-id", "1"))
            .thenThrow(new IllegalArgumentException("Input must be a letter"));
        
        // Act
        ResponseEntity<GameResponse> response = controller.guess(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().getMessage().contains("letter"));
        verify(hangmanService, times(1)).guess("some-id", "1");
    }
    
    @Test
    public void testGuess_GameAlreadyOver_BadRequest() {
        // Arrange
        GuessRequest request = new GuessRequest("some-id", "A");
        when(hangmanService.guess("some-id", "A"))
            .thenThrow(new IllegalArgumentException("Game is already over"));
        
        // Act
        ResponseEntity<GameResponse> response = controller.guess(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().getMessage().contains("already over"));
        verify(hangmanService, times(1)).guess("some-id", "A");
    }
    
    @Test
    public void testGuess_InternalServerError() {
        // Arrange
        GuessRequest request = new GuessRequest("some-id", "A");
        when(hangmanService.guess("some-id", "A"))
            .thenThrow(new RuntimeException("Database error"));
        
        // Act
        ResponseEntity<GameResponse> response = controller.guess(request);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals("Internal server error", response.getBody().getMessage());
        verify(hangmanService, times(1)).guess("some-id", "A");
    }
    
    // ============= GET GAME TESTS =============
    
    @Test
    public void testGetGame_Success() {
        // Arrange
        Game mockGame = new Game("JAVA");
        String gameId = mockGame.getId();
        when(hangmanService.getGame(gameId)).thenReturn(mockGame);
        
        // Act
        ResponseEntity<GameResponse> response = controller.getGame(gameId);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals(gameId, response.getBody().getId());
        assertEquals(mockGame.getMaskedWord(), response.getBody().getMaskedWord());
        assertEquals("ACTIVE", response.getBody().getStatus());
        verify(hangmanService, times(1)).getGame(gameId);
    }
    
    @Test
    public void testGetGame_NotFound() {
        // Arrange
        String gameId = "invalid-id";
        when(hangmanService.getGame(gameId))
            .thenThrow(new IllegalArgumentException("Game not found with ID: " + gameId));
        
        // Act
        ResponseEntity<GameResponse> response = controller.getGame(gameId);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody().getMessage().contains("Game not found"));
        verify(hangmanService, times(1)).getGame(gameId);
    }
    
    @Test
    public void testGetGame_InternalServerError() {
        // Arrange
        String gameId = "some-id";
        when(hangmanService.getGame(gameId))
            .thenThrow(new RuntimeException("Database connection failed"));
        
        // Act
        ResponseEntity<GameResponse> response = controller.getGame(gameId);
        
        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals("Internal server error", response.getBody().getMessage());
        verify(hangmanService, times(1)).getGame(gameId);
    }
}
