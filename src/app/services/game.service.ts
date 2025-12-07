import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject } from 'rxjs';

export interface GameVM {
  maskedWord: string;
  errorsCount: number;
  keyStates: Record<string, 'neutral' | 'correct' | 'wrong'>;
  lastStatus: 'neutral' | 'correct' | 'wrong'; 
  lastMessage: string;
}

@Injectable({ providedIn: 'root' })
export class GameService {
  private vmSubject = new BehaviorSubject<GameVM>({
    maskedWord: '',
    errorsCount: 0,
    keyStates: {},
    lastStatus: 'neutral',
    lastMessage: ''
  });
  vm$ = this.vmSubject.asObservable();

  private baseUrl = 'http://localhost:8080/api/games';
  private currentGameId: string | null = null;

  constructor(private http: HttpClient) {}

  startGame(): void {
    const request = { maxAttempts: 15 };  // 15 maximale Fehler
    
    this.http.post<{ id: string; maskedWord: string; failedAttempts: number }>(
      `${this.baseUrl}`,
      request
    ).subscribe({
      next: res => {
        // 👇 WICHTIG: Game ID speichern!
        this.currentGameId = res.id;
        
        const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
        const keyStates: Record<string, 'neutral' | 'correct' | 'wrong'> = {};
        letters.forEach(l => keyStates[l] = 'neutral');

        this.vmSubject.next({
          maskedWord: res.maskedWord,
          errorsCount: res.failedAttempts,
          keyStates,
          lastStatus: 'neutral',
          lastMessage: ''
        });
      },
      error: err => {
        console.error('POST /start fehlgeschlagen:', err);
        this.vmSubject.next({
          ...this.vmSubject.value,
          lastStatus: 'wrong',
          lastMessage: err.status === 404 ? 'Spiel nicht gefunden' : 'Serverfehler'
        });
      }
    });
  }

  guessLetter(letter: string) {
    // Prüfe ob Game ID existiert
    if (!this.currentGameId) {
      console.error('Keine aktive Game ID. Starte neues Spiel.');
      this.startGame();
      return;
    }

    this.http.post<{ id: string; maskedWord: string; failedAttempts: number }>(
      `${this.baseUrl}/guess`,
      { "id": this.currentGameId, "letter": letter }
    ).subscribe({
      next: res => {
        const keyStates = { ...this.vmSubject.value.keyStates };
        keyStates[letter] = res.maskedWord.includes(letter) ? 'correct' : 'wrong';

        this.vmSubject.next({
          maskedWord: res.maskedWord,
          errorsCount: res.failedAttempts,
          keyStates,
          lastStatus: 'neutral',
          lastMessage: ''
        });
      },
      error: err => {
        console.error('POST /guess fehlgeschlagen:', err);
        this.vmSubject.next({
          ...this.vmSubject.value,
          lastStatus: 'wrong',
          lastMessage: err.status === 404 ? 'Spiel nicht gefunden' : 'Serverfehler'
        });
      }
    });
  }
}