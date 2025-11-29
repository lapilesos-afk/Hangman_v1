import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HangmanCanvas } from './hangman-canvas';

describe('HangmanCanvas', () => {
  let component: HangmanCanvas;
  let fixture: ComponentFixture<HangmanCanvas>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [HangmanCanvas]
    })
    .compileComponents();

    fixture = TestBed.createComponent(HangmanCanvas);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
