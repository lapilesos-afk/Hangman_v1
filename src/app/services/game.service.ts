import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { HttpClient } from '@angular/common/http';

export type GuessStatus = 'correct' | 'wrong' | 'neutral';

export interface GameVM {
  maskedWord: string;
  errorsCount: number;
  keyStates: Record<string, 'neutral' | 'correct' | 'wrong'>;
  lastStatus: GuessStatus;
  lastMessage: string;
}

interface GameResponse {
  id: string;
  maskedWord: string;
  failedAttempts: number;
  maxAttempts: number;
  status: string;
  message?: string;
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

  // Use full backend URL in dev (Angular dev server runs on 4200)
  private apiBase = 'http://localhost:8080/api/games';
  private currentGameId: string | null = null;

  constructor(private http: HttpClient) {}

  startGame() {
    this.http.post<GameResponse>(this.apiBase, {}).subscribe({
      next: res => {
        this.currentGameId = res.id;
        const keyStates: Record<string, 'neutral' | 'correct' | 'wrong'> = {};
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').forEach(l => keyStates[l] = 'neutral');

        // If maskedWord contains letters, mark those keys as correct
        const visible = (res.maskedWord || '').toUpperCase();
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').forEach(l => {
          if (visible.includes(l)) keyStates[l] = 'correct';
        });

        this.vmSubject.next({
          maskedWord: res.maskedWord || '',
          errorsCount: res.failedAttempts || 0,
          keyStates,
          lastStatus: 'neutral',
          lastMessage: res.message || ''
        });
      },
      error: err => {
        this.vmSubject.next({
          maskedWord: '',
          errorsCount: 0,
          keyStates: {},
          lastStatus: 'neutral',
          lastMessage: 'Failed to start game: ' + (err?.message || err)
        });
      }
    });
  }

  guessLetter(letter: string) {
    if (!letter) return;
    if (!this.currentGameId) {
      // start a new game if none exists
      this.startGame();
      return;
    }

    const payload = { id: this.currentGameId, letter };
    this.http.post<GameResponse>(`${this.apiBase}/guess`, payload).subscribe({
      next: res => {
        // Update key state for the guessed letter
        const current = this.vmSubject.getValue();
        const keyStates = { ...current.keyStates };
        const upLetter = letter.toUpperCase();
        const isCorrect = (res.maskedWord || '').toUpperCase().includes(upLetter);
        keyStates[upLetter] = isCorrect ? 'correct' : 'wrong';

        this.vmSubject.next({
          maskedWord: res.maskedWord || current.maskedWord,
          errorsCount: res.failedAttempts || current.errorsCount,
          keyStates,
          lastStatus: isCorrect ? 'correct' : 'wrong',
          lastMessage: res.message || ''
        });
      },
      error: err => {
        const current = this.vmSubject.getValue();
        this.vmSubject.next({
          ...current,
          lastStatus: 'neutral',
          lastMessage: 'Error sending guess: ' + (err?.message || err)
        });
      }
    });
  }
}