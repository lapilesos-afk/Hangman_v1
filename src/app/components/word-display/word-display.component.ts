import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { GameService, GameVM } from '../../services/game.service';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-word-display',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './word-display.component.html',
  styleUrls: ['./word-display.component.css']
})
export class WordDisplayComponent {
  @Input() maskedWord!: string;      
  @Input() errorsCount!: number;  
  vm$: Observable<GameVM>;

  constructor(private gameService: GameService) {
    this.vm$ = this.gameService.vm$;
  }
}
