package com.hangman.integration;

import com.hangman.dto.GameResponse;
import com.hangman.dto.GuessRequest;
import com.hangman.dto.StartGameRequest;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.*;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class HangmanIntegrationTest {
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    private static final String BASE_URL = "/api/games";
    
    @Test
    public void testCompleteGameFlow() {
        // 1. Start new game
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        
        HttpEntity<StartGameRequest> startRequest = new HttpEntity<>(null, headers);
        ResponseEntity<GameResponse> startResponse = restTemplate.exchange(
            BASE_URL,
            HttpMethod.POST,
            startRequest,
            GameResponse.class
        );
        
        assertEquals(HttpStatus.OK, startResponse.getStatusCode());
        assertNotNull(startResponse.getBody());
        GameResponse gameStart = startResponse.getBody();
        
        assertNotNull(gameStart.getId());
        assertEquals(0, gameStart.getFailedAttempts());
        assertTrue(gameStart.getMaskedWord().contains("_"));
        assertEquals("ACTIVE", gameStart.getStatus());
        
        String gameId = gameStart.getId();
        
        // 2. Make some guesses
        GuessRequest guessRequest = new GuessRequest(gameId, "A");
        HttpEntity<GuessRequest> guessEntity = new HttpEntity<>(guessRequest, headers);
        
        ResponseEntity<GameResponse> guessResponse = restTemplate.exchange(
            BASE_URL + "/guess",
            HttpMethod.POST,
            guessEntity,
            GameResponse.class
        );
        
        assertEquals(HttpStatus.OK, guessResponse.getStatusCode());
        assertNotNull(guessResponse.getBody());
        
        // 3. Get game state
        ResponseEntity<GameResponse> getResponse = restTemplate.getForEntity(
            BASE_URL + "/" + gameId,
            GameResponse.class
        );
        
        assertEquals(HttpStatus.OK, getResponse.getStatusCode());
        assertNotNull(getResponse.getBody());
    }
    
    @Test
    public void testGuessWithInvalidGameId() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        
        GuessRequest guessRequest = new GuessRequest("invalid-id", "A");
        HttpEntity<GuessRequest> requestEntity = new HttpEntity<>(guessRequest, headers);
        
        ResponseEntity<GameResponse> response = restTemplate.exchange(
            BASE_URL + "/guess",
            HttpMethod.POST,
            requestEntity,
            GameResponse.class
        );
        
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }
    
    @Test
    public void testGuessWithInvalidLetter() {
        // First create a game
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        
        HttpEntity<StartGameRequest> startRequest = new HttpEntity<>(null, headers);
        ResponseEntity<GameResponse> startResponse = restTemplate.exchange(
            BASE_URL,
            HttpMethod.POST,
            startRequest,
            GameResponse.class
        );
        
        String gameId = startResponse.getBody().getId();
        
        // Try to guess with invalid letter
        GuessRequest guessRequest = new GuessRequest(gameId, "123");
        HttpEntity<GuessRequest> guessEntity = new HttpEntity<>(guessRequest, headers);
        
        ResponseEntity<GameResponse> response = restTemplate.exchange(
            BASE_URL + "/guess",
            HttpMethod.POST,
            guessEntity,
            GameResponse.class
        );
        
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }
}
