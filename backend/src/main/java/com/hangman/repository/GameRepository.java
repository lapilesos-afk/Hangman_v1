package com.hangman.repository;

import com.hangman.domain.Game;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GameRepository extends JpaRepository<Game, String> {
    // JpaRepository provides basic CRUD operations:
    // save(Game), findById(String), findAll(), delete(Game), etc.
}
