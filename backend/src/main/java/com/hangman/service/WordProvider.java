package com.hangman.service;

import java.util.Arrays;
import java.util.List;
import java.util.Random;

public class WordProvider {
    private static final List<String> WORDS = Arrays.asList(
        "AUTO", "KATZE", "HUND", "BAUM", "HAUS", "COMPUTER", "PROGRAMM",
        "JAVA", "SPRING", "BOOT", "DATABASE", "ENTWICKLER", "HANGMAN",
        "ALPHABET", "BUCHSTABE", "SPIEL", "SIEG", "NIEDERLAGE", "WORT",
        "SCHULE", "STUDIUM", "PROJEKT", "LÖSUNG", "FEHLER", "VERSUCH",
        "MÜNCHEN", "KÖLN", "ZÜRICH", "GRÜN", "SCHÖN", "ÜBUNG", "TÜR"
    );
    
    private static final Random RANDOM = new Random();
    
    public static String getRandomWord() {
        return WORDS.get(RANDOM.nextInt(WORDS.size()));
    }
}
