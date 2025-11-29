package com.hangman.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GameGuessResult {
    private boolean correct;
    private boolean gameOver;
    private String message;
}
