stm8/
	title Program STM8s PPS 2021 Kit
	
	.nolist
	#include "mapping.inc"
	#include "STM8S208RB.inc"
	.list

;	DEFINICNI KONSTANTY
;-----------------------------------------------------------
		BYTES
; konstanty pro nastaveni pinu portu B = LED
INI_PB_DDR	equ	%11111111	; vse vystup
INI_PB_CR1	equ	%11111111	; vse push/pull
INI_PB_ODR	equ	%11111111	; 1 zhasne LED

; konstanty funkce wait
INI_TIM2PSCR	equ	9		; preddelicka 512
INI_TIM2CR1     equ     %00000001       ; spustit citac
INI_TIM2IER     equ     %00000000       ; bez preruseni

		WORDS
INI_TIM2ARR	equ	15625	        ; cilova hodnota

;	PROMENNE
;-----------------------------------------------------------
	segment 'ram0'

;	PROGRAM
;-----------------------------------------------------------
	segment 'rom'
        
        ; inicializace vystupu LED
main.l	mov     PB_ODR, #INI_PB_ODR     ; stav vystupu pinu
        mov     PB_CR1, #INI_PB_CR1     ; typ totemu pinu
        mov     PB_DDR, #INI_PB_ODR     ; smer pinu
        
        ; inicializace TIM2
        mov     TIM2_ARRH, #{high {INI_TIM2ARR}}
        mov     TIM2_ARRL, #{low {INI_TIM2ARR}}
        mov     TIM2_PSCR, #INI_TIM2PSCR
        mov     TIM2_IER, #INI_TIM2IER    
        mov     TIM2_CR1, #INI_TIM2CR1
        
        ; cekani na vystaveni vlajky UIF
smycka  btjf    TIM2_SR1, #0, smycka    ; skok pri UIF=0
        bres    TIM2_SR1, #0            ; shozeni vlajky UIF
        bcpl    PB_ODR, #0              ; negace bitu 0
        jp      smycka                  ; skok na start
				
				
;	vektory
;-----------------------------------------------------------

	interrupt NonHandledInterrupt
NonHandledInterrupt.l
	iret

	segment 'vectit'
	dc.l {$82000000+main}			; reset
	dc.l {$82000000+NonHandledInterrupt}	; trap
	dc.l {$82000000+NonHandledInterrupt}	; irq0
	dc.l {$82000000+NonHandledInterrupt}	; irq1
	dc.l {$82000000+NonHandledInterrupt}	; irq2
	dc.l {$82000000+NonHandledInterrupt}	; irq3
	dc.l {$82000000+NonHandledInterrupt}	; irq4
	dc.l {$82000000+NonHandledInterrupt}	; irq5
	dc.l {$82000000+NonHandledInterrupt}	; irq6
	dc.l {$82000000+NonHandledInterrupt}	; irq7
	dc.l {$82000000+NonHandledInterrupt}	; irq8
	dc.l {$82000000+NonHandledInterrupt}	; irq9
	dc.l {$82000000+NonHandledInterrupt}	; irq10
	dc.l {$82000000+NonHandledInterrupt}	; irq11
	dc.l {$82000000+NonHandledInterrupt}	; irq12
	dc.l {$82000000+NonHandledInterrupt}	; irq13
	dc.l {$82000000+NonHandledInterrupt}	; irq14
	dc.l {$82000000+NonHandledInterrupt}	; irq15
	dc.l {$82000000+NonHandledInterrupt}	; irq16
	dc.l {$82000000+NonHandledInterrupt}	; irq17
	dc.l {$82000000+NonHandledInterrupt}	; irq18
	dc.l {$82000000+NonHandledInterrupt}	; irq19
	dc.l {$82000000+NonHandledInterrupt}	; irq20
	dc.l {$82000000+NonHandledInterrupt}	; irq21
	dc.l {$82000000+NonHandledInterrupt}	; irq22
	dc.l {$82000000+NonHandledInterrupt}	; irq23
	dc.l {$82000000+NonHandledInterrupt}	; irq24
	dc.l {$82000000+NonHandledInterrupt}	; irq25
	dc.l {$82000000+NonHandledInterrupt}	; irq26
	dc.l {$82000000+NonHandledInterrupt}	; irq27
	dc.l {$82000000+NonHandledInterrupt}	; irq28
	dc.l {$82000000+NonHandledInterrupt}	; irq29

				; konec zdrojoveho textu
	end
