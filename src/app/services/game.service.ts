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

// private baseUrl = 'https://fec23180-6141-4c18-bf41-9c61221235d1.mock.pstmn.io/api/hangman';
 private baseUrl = 'http://localhost:8080/api/games';
 // private baseUrl = 'http://localhost:8080/api/hangman'; 
 
 constructor(private http: HttpClient) {}

  startGame() {
    this.http.post<{ id: Number; maskedWord: string; failedAttempts: number }>(
      `${this.baseUrl},  // /startGame`, //previous /start
      {id:0, Buchstabe:''}
    ).subscribe({
      next: res => {
        //console.log('POST /start erfolgreich, Antwort:', res);
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
    this.http.post<{ maskedWord: string; failedAttempts: number }>(
      `${this.baseUrl}/guess`,
      { "id": 1, "letter": letter }
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
        console.error('POST /start fehlgeschlagen:', err);
        this.vmSubject.next({
          ...this.vmSubject.value,
          lastStatus: 'wrong',
          lastMessage: err.status === 404 ? 'Spiel nicht gefunden' : 'Serverfehler'
        });
      }
    });
  }
}