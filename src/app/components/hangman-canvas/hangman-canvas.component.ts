import { Component, ElementRef, Input, OnChanges, ViewChild } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-hangman-canvas',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './hangman-canvas.component.html',
  styleUrls: ['./hangman-canvas.component.css']
})
export class HangmanCanvasComponent implements OnChanges {
  @Input() errorsCount = 0;
  @Input() maxStrokes = 15;
  @ViewChild('canvas', { static: true }) canvasRef!: ElementRef<HTMLCanvasElement>;

  ngOnChanges() {
    // Nur zeichnen, wenn es mindestens einen Fehler gibt
    if (this.errorsCount > 0) {
      this.draw();
    } else {
      this.clear();
    }
  }

  private clear() {
    const canvas = this.canvasRef.nativeElement;
    const ctx = canvas.getContext('2d')!;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
  }

  private draw() {
    const canvas = this.canvasRef.nativeElement;
    const ctx = canvas.getContext('2d')!;
    const w = canvas.width, h = canvas.height;

    // Reset
    ctx.clearRect(0, 0, w, h);
    ctx.lineWidth = 3;
    ctx.strokeStyle = '#222';

    // Stroke definitions (15 steps): base, post, beam, rope, head, body, arms, legs, details
    const steps = [
      () => this.line(ctx, 50, h - 20, 150, h - 20), // Sockel
      () => this.line(ctx, 100, h - 20, 100, 40),    // Pfosten
      () => this.line(ctx, 100, 40, 200, 40),        // Querbalken
      () => this.line(ctx, 200, 40, 200, 80),        // Seil
      () => this.circle(ctx, 200, 100, 20),          // Kopf
      () => this.line(ctx, 200, 120, 200, 180),      // Körper
      () => this.line(ctx, 200, 140, 170, 160),      // Arm links
      () => this.line(ctx, 200, 140, 230, 160),      // Arm rechts
      () => this.line(ctx, 200, 180, 175, 220),      // Bein links
      () => this.line(ctx, 200, 180, 225, 220),      // Bein rechts
      () => this.line(ctx, 80, h - 20, 100, h - 35), // Sockel-Detail
      () => this.line(ctx, 100, h - 35, 120, h - 20),
      () => this.line(ctx, 190, 115, 210, 115),      // Mund
      () => this.circle(ctx, 192, 95, 2),            // Auge links
      () => this.circle(ctx, 208, 95, 2)             // Auge rechts
    ];

    const count = Math.min(this.errorsCount, this.maxStrokes);
    for (let i = 0; i < count; i++) steps[i]();
  }

  private line(ctx: CanvasRenderingContext2D, x1: number, y1: number, x2: number, y2: number) {
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();
  }

  private circle(ctx: CanvasRenderingContext2D, x: number, y: number, r: number) {
    ctx.beginPath();
    ctx.arc(x, y, r, 0, Math.PI * 2);
    ctx.stroke();
  }
}