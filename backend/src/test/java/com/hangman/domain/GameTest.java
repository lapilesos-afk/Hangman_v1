package com.hangman.domain;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class GameTest {
    
    @Test
    public void testGameInitialization() {
        Game game = new Game("AUTO");
        
        assertNotNull(game.getId());
        assertEquals("AUTO", game.getWord());
        assertTrue(game.getMaskedWord().contains("_"));
        assertEquals(0, game.getFailedAttempts());
        assertEquals(Game.GameStatus.ACTIVE, game.getStatus());
    }
    
    @Test
    public void testCorrectGuess() {
        Game game = new Game("AUTO");
        GameGuessResult result = game.guess('A');
        
        assertTrue(result.isCorrect());
        assertFalse(result.isGameOver());
        assertTrue(game.getMaskedWord().startsWith("A"));
        assertEquals(0, game.getFailedAttempts());
    }
    
    @Test
    public void testWrongGuess() {
        Game game = new Game("AUTO");
        GameGuessResult result = game.guess('Z');
        
        assertFalse(result.isCorrect());
        assertFalse(result.isGameOver());
        assertEquals(1, game.getFailedAttempts());
    }
    
    @Test
    public void testGameWon() {
        Game game = new Game("CAT");
        
        game.guess('C');
        game.guess('A');
        GameGuessResult result = game.guess('T');
        
        assertTrue(result.isGameOver());
        assertEquals(Game.GameStatus.WON, game.getStatus());
    }
    
    @Test
    public void testGameLost() {
        Game game = new Game("AUTO");
        
        game.guess('Z');
        game.guess('X');
        game.guess('Q');
        game.guess('W');
        game.guess('B');
        GameGuessResult result = game.guess('V');
        
        assertTrue(result.isGameOver());
        assertEquals(Game.GameStatus.LOST, game.getStatus());
        assertEquals(6, game.getFailedAttempts());
        assertEquals("AUTO", game.getMaskedWord()); // Word revealed
    }
    
    @Test
    public void testDuplicateGuess() {
        Game game = new Game("AUTO");
        
        game.guess('A');
        GameGuessResult result = game.guess('A');
        
        assertFalse(result.isCorrect());
        assertTrue(result.getMessage().contains("already guessed"));
    }
    
    @Test
    public void testGameCannotGuessAfterGameOver() {
        Game game = new Game("CAT");
        
        game.guess('C');
        game.guess('A');
        game.guess('T');
        
        assertTrue(game.isGameOver());
        assertEquals(Game.GameStatus.WON, game.getStatus());
    }
}
