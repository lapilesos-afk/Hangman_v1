import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';


@Component({
  selector: 'app-status-dialog',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './status-dialog.component.html',
  styleUrls: ['./status-dialog.component.css']
})
export class StatusDialogComponent {
  @Input() status: 'correct' | 'wrong' | 'neutral' = 'neutral';
  @Input() message: string = '';
}
