package com.hangman.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.UUID;

@Entity
@Table(name = "games")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Game {
    
    @Id
    @Column(name = "game_id")
    private String id;
    
    @Column(name = "word", nullable = false)
    private String word;
    
    @Column(name = "masked_word", nullable = false)
    private String maskedWord;
    
    @Column(name = "failed_attempts", nullable = false)
    private int failedAttempts;
    
    @Column(name = "guessed_letters", nullable = false)
    private String guessedLetters; // Comma-separated letters
    
    @Column(name = "game_status", nullable = false)
    @Enumerated(EnumType.STRING)
    private GameStatus status;
    
    @Column(name = "max_attempts", nullable = false)
    private int maxAttempts = 6;
    
    public Game(String word) {
        this.id = UUID.randomUUID().toString();
        this.word = word.toUpperCase();
        this.maskedWord = maskWord(word);
        this.failedAttempts = 0;
        this.guessedLetters = "";
        this.status = GameStatus.ACTIVE;
        this.maxAttempts = 6;
    }
    
    /**
     * Processes a guess letter and updates game state
     */
    public GameGuessResult guess(char letter) {
        letter = Character.toUpperCase(letter);
        
        // Check if letter was already guessed
        if (guessedLetters.contains(String.valueOf(letter))) {
            return new GameGuessResult(false, false, "Letter already guessed");
        }
        
        // Add letter to guessed letters
        guessedLetters = guessedLetters.isEmpty() 
            ? String.valueOf(letter) 
            : guessedLetters + "," + letter;
        
        // Check if letter or equivalent is in word
        if (checkLetterOrAequivalent(letter)) {
            // Update masked word
            maskedWord = maskLetterOrAequivalent(letter);
            
            // Check if won
            if (maskedWord.replace(" ", "").equals(word)) {
                status = GameStatus.WON;
                return new GameGuessResult(true, true, "Correct! You won!");
            }
            
            return new GameGuessResult(true, false, "Correct guess!");
        } else {
            // Wrong guess
            failedAttempts++;
            
            // Check if lost
            if (failedAttempts >= maxAttempts) {
                status = GameStatus.LOST;
                maskedWord = word; // Reveal word when lost
                return new GameGuessResult(false, true, "Game over! You lost!");
            }
            
            return new GameGuessResult(false, false, "Wrong guess. Try again!");
        }
    }
    
    /**
     * Checks if letter or its umlaut equivalent is in the word
     */
    private boolean checkLetterOrAequivalent(char letter) {
        String letterStr = String.valueOf(letter);
        if (word.contains(letterStr)) {
            return true;
        }
        
        // Check umlaut equivalents
        switch (letter) {
            case 'A': return word.contains("Ä");
            case 'Ä': return word.contains("A");
            case 'O': return word.contains("Ö");
            case 'Ö': return word.contains("O");
            case 'U': return word.contains("Ü");
            case 'Ü': return word.contains("U");
            default: return false;
        }
    }
    
    /**
     * Updates masked word by revealing the letter and its umlaut equivalent
     */
    private String maskLetterOrAequivalent(char letter) {
        StringBuilder result = new StringBuilder();
        String[] chars = word.split("");
        String[] masked = maskedWord.split(" ");
        
        for (int i = 0; i < chars.length; i++) {
            char wordChar = chars[i].charAt(0);
            if (isLetterMatch(wordChar, letter)) {
                result.append(wordChar);
            } else {
                result.append(masked[i].isEmpty() ? "_" : masked[i]);
            }
            
            if (i < chars.length - 1) {
                result.append(" ");
            }
        }
        
        return result.toString();
    }
    
    /**
     * Checks if two letters match or are umlaut equivalents
     */
    private boolean isLetterMatch(char wordChar, char guessedChar) {
        wordChar = Character.toUpperCase(wordChar);
        guessedChar = Character.toUpperCase(guessedChar);
        
        if (wordChar == guessedChar) {
            return true;
        }
        
        return (wordChar == 'A' && guessedChar == 'Ä') ||
               (wordChar == 'Ä' && guessedChar == 'A') ||
               (wordChar == 'O' && guessedChar == 'Ö') ||
               (wordChar == 'Ö' && guessedChar == 'O') ||
               (wordChar == 'U' && guessedChar == 'Ü') ||
               (wordChar == 'Ü' && guessedChar == 'U');
    }
    
    /**
     * Masks the word with underscores, revealing guessed letters
     */
    private String maskWord(String word) {
        return String.join(" ", word.split("")).replaceAll("\\p{L}", "_");
    }
    
    public boolean isGameOver() {
        return status == GameStatus.WON || status == GameStatus.LOST;
    }
    
    public enum GameStatus {
        ACTIVE, WON, LOST
    }
}
