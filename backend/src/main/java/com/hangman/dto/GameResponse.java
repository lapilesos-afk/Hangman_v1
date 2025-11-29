package com.hangman.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.hangman.domain.Game;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GameResponse {
    private String id;
    private String maskedWord;
    private int failedAttempts;
    private int maxAttempts;
    private String status;
    private String message;
    
    public static GameResponse fromGame(Game game) {
        return new GameResponse(
            game.getId(),
            game.getMaskedWord(),
            game.getFailedAttempts(),
            game.getMaxAttempts(),
            game.getStatus().toString(),
            ""
        );
    }
    
    public static GameResponse fromGameWithMessage(Game game, String message) {
        GameResponse response = fromGame(game);
        response.setMessage(message);
        return response;
    }
}
