import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { HangmanCanvasComponent } from './components/hangman-canvas/hangman-canvas.component';
import { WordDisplayComponent } from './components/word-display/word-display.component';
import { KeyboardComponent } from './components/keyboard/keyboard.component';
import { StatusDialogComponent } from './components/status-dialog/status-dialog.component';
import { GameService } from './services/game.service';

//import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    CommonModule,              // wichtig für *ngIf, *ngFor
    HttpClientModule,
    HangmanCanvasComponent,    // deine Canvas-Komponente
    WordDisplayComponent,      // Wortanzeige
    KeyboardComponent,         // Tastatur
    StatusDialogComponent      // Statusmeldungen
  ],
  providers: [GameService],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  // Hier definierst du vm
  vm = {
    maskedWord: '',
    errorsCount: 0,
    keyStates: {} as Record<string, 'neutral' | 'correct' | 'wrong'>,
    lastStatus: 'neutral' as 'neutral' | 'correct' | 'wrong',
    lastMessage: ''
  };

  constructor(private game: GameService) {}

  ngOnInit() {
    // Falls dein GameService ein Observable liefert
    this.game.vm$.subscribe(s => this.vm = s);
    this.game.startGame();
  }

  onLetterClicked(letter: string) {
    this.game.guessLetter(letter);
  }
}
