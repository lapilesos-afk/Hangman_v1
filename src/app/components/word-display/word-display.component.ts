import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';


@Component({
  selector: 'app-word-display',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './word-display.component.html',
  styleUrls: ['./word-display.component.css']
})
export class WordDisplayComponent {
  @Input() maskedWord: string = '';   // z. B. "_ _ _ _"
  @Input() errorsCount: number = 0;   // Anzahl der Fehlversuche
}
