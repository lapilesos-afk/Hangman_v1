import { Component, EventEmitter, Input, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { GameService, GameVM } from '../../services/game.service';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-keyboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './keyboard.component.html',
  styleUrls: ['./keyboard.component.css']
})
export class KeyboardComponent {
  // Eingaben vom Parent (AppComponent)
  @Input() keyStates!: Record<string, 'neutral' | 'correct' | 'wrong'>;

  // Drei Reihen von Buchstaben
  lettersRow1: string[] = 'ABCDEFGHIJ'.split('');
  lettersRow2: string[] = 'KLMNOPQRST'.split('');
  lettersRow3: string[] = 'UVWXYZ'.split('');

  // Ausgabe-Event: Parent bekommt den geklickten Buchstaben
  @Output() letterClicked = new EventEmitter<string>();

  // ViewModel aus dem GameService
  vm$: Observable<GameVM>;

  constructor(private game: GameService) {
    this.vm$ = this.game.vm$;
  }

  // Methode, die beim Klick aufgerufen wird
  onGuess(letter: string) {
    this.letterClicked.emit(letter);
  }
}