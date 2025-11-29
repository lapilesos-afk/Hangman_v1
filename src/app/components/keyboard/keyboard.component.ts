import { Component, EventEmitter, Input, Output } from '@angular/core';
import { CommonModule } from '@angular/common';


@Component({
  selector: 'app-keyboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './keyboard.component.html',
  styleUrls: ['./keyboard.component.css']
})
export class KeyboardComponent {
  @Input() keyStates: Record<string, 'neutral' | 'correct' | 'wrong'> = {};
  @Output() letterClicked = new EventEmitter<string>();

  rows: string[][] = [
    ['A','B','C','D','E','F','G','H','I','J'],
    ['K','L','M','N','O','P','Q','R','S','T'],
    ['U','V','W','X','Y','Z']
  ];

  onClick(k: string) {
    this.letterClicked.emit(k);
  }
}
