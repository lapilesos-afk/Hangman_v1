import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject } from 'rxjs';

export interface GameVM {
  maskedWord: string;
  errorsCount: number;
  maxAttempts: number;
  keyStates: Record<string, 'neutral' | 'correct' | 'wrong'>;
  lastStatus: 'neutral' | 'correct' | 'wrong'; 
  lastMessage: string;
  gameStatus: 'ACTIVE' | 'WON' | 'LOST';
  isGameOver: boolean;
}

@Injectable({ providedIn: 'root' })
export class GameService {
  private vmSubject = new BehaviorSubject<GameVM>({
    maskedWord: '',
    errorsCount: 0,
    maxAttempts: 15,
    keyStates: {},
    lastStatus: 'neutral',
    lastMessage: '',
    gameStatus: 'ACTIVE',
    isGameOver: false
  });
  vm$ = this.vmSubject.asObservable();

  private baseUrl = 'http://localhost:8080/api/games';
  private currentGameId: string | null = null;

  constructor(private http: HttpClient) {}

  startGame(): void {
    const request = { maxAttempts: 15 };
    
    this.http.post<{ id: string; maskedWord: string; failedAttempts: number; maxAttempts: number; status: string }>(
      `${this.baseUrl}`,
      request
    ).subscribe({
      next: (res) => {
        this.currentGameId = res.id;
        
        const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ'.split('');
        const keyStates: Record<string, 'neutral' | 'correct' | 'wrong'> = {};
        letters.forEach(l => keyStates[l] = 'neutral');

        this.vmSubject.next({
          maskedWord: res.maskedWord,
          errorsCount: res.failedAttempts,
          maxAttempts: res.maxAttempts || 15,
          keyStates,
          lastStatus: 'neutral',
          lastMessage: 'Neues Spiel gestartet!',
          gameStatus: 'ACTIVE',
          isGameOver: false
        });
      },
      error: (err) => {
        console.error('POST /start fehlgeschlagen:', err);
        this.vmSubject.next({
          ...this.vmSubject.value,
          lastStatus: 'wrong',
          lastMessage: err.status === 404 ? 'Spiel nicht gefunden' : 'Serverfehler'
        });
      }
    });
  }

  guessLetter(letter: string): void {
    if (!this.currentGameId) {
      console.error('Keine aktive Game ID. Starte neues Spiel.');
      this.startGame();
      return;
    }

    const currentVm = this.vmSubject.value;
    if (currentVm.isGameOver) {
      console.warn('Spiel ist bereits beendet!');
      return;
    }

    this.http.post<{ id: string; maskedWord: string; failedAttempts: number; maxAttempts: number; status: string; message?: string }>(
      `${this.baseUrl}/guess`,
      { "id": this.currentGameId, "letter": letter }
    ).subscribe({
      next: (res) => {
        const keyStates = { ...this.vmSubject.value.keyStates };
        const wasCorrect = res.maskedWord.includes(letter) || this.checkUmlautEquivalent(letter, res.maskedWord);
        keyStates[letter] = wasCorrect ? 'correct' : 'wrong';
        
        // Mark equivalent letter with same state
        const equivalent = this.getUmlautEquivalent(letter);
        if (equivalent) {
          keyStates[equivalent] = wasCorrect ? 'correct' : 'wrong';
        }

        const gameStatus = res.status as 'ACTIVE' | 'WON' | 'LOST';
        const isGameOver = gameStatus === 'WON' || gameStatus === 'LOST';
        
        let lastMessage = '';
        if (gameStatus === 'LOST') {
          lastMessage = '😢 Verloren! Das Wort war: ' + res.maskedWord;
        } else if (gameStatus === 'WON') {
          lastMessage = '🎉 Gewonnen! Das Wort wurde erraten!';
        } else if (wasCorrect) {
          lastMessage = '✅ Richtig geraten!';
        } else {
          lastMessage = '❌ Falsch geraten!';
        }

        this.vmSubject.next({
          maskedWord: res.maskedWord,
          errorsCount: res.failedAttempts,
          maxAttempts: res.maxAttempts || this.vmSubject.value.maxAttempts,
          keyStates,
          lastStatus: wasCorrect ? 'correct' : 'wrong',
          lastMessage,
          gameStatus,
          isGameOver
        });

        if (isGameOver) {
          setTimeout(() => {
            if (confirm(lastMessage + '\n\nNeues Spiel starten?')) {
              this.startGame();
            }
          }, 1000);
        }
      },
      error: (err) => {
        console.error('POST /guess fehlgeschlagen:', err);
        this.vmSubject.next({
          ...this.vmSubject.value,
          lastStatus: 'wrong',
          lastMessage: err.status === 404 ? 'Spiel nicht gefunden' : 'Serverfehler'
        });
      }
    });
  }
  
  private checkUmlautEquivalent(letter: string, maskedWord: string): boolean {
    const equivalents: Record<string, string> = {
      'A': 'Ä', 'Ä': 'A',
      'O': 'Ö', 'Ö': 'O',
      'U': 'Ü', 'Ü': 'U'
    };
    const equivalent = equivalents[letter];
    return equivalent ? maskedWord.includes(equivalent) : false;
  }
  
  private getUmlautEquivalent(letter: string): string | null {
    const equivalents: Record<string, string> = {
      'A': 'Ä', 'Ä': 'A',
      'O': 'Ö', 'Ö': 'O',
      'U': 'Ü', 'Ü': 'U'
    };
    return equivalents[letter] || null;
  }
}