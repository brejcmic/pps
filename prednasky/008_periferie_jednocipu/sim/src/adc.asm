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
INI_POC1	equ	5		; pocet pruchodu
                                        ; vnejsiho cyklu
		WORDS
INI_Y		equ	50000		; pocet pruchodu
                                        ; vnitrniho cyklu

;	PROMENNE
;-----------------------------------------------------------
	segment 'ram0'

; promenna funkce wait v RAM
poc1	ds.b	1			; rezervace 1 byte

vysl    ds.b    1


;	PROGRAM
;-----------------------------------------------------------
	segment 'rom'
        
        ; inicializace vystupu LED
main.l	mov     PB_ODR, #INI_PB_ODR     ; stav vystupu pinu
        mov     PB_CR1, #INI_PB_CR1     ; typ totemu pinu
        mov     PB_DDR, #INI_PB_ODR     ; smer pinu
        
        ; inicializace ADC
        mov     ADC_TDRH, #%00000011    ; vyrazeni schmitt.
                                        ; KO na PE6 a PE7
        mov     ADC_CSR, #%000001001    ; volba AIN9
        mov     ADC_CR2, #%000000000    ; zarovnani vlevo
        mov     ADC_CR1, #%000000001    ; single, ADON=1

        ; start prevodu
start   bres    ADC_CSR, #7             ; nastaveni EOC=0
        bset    ADC_CR1, #0             ; znovu ADON=1
        
        ; cekani na vysledek
smycka  btjf    ADC_CSR, #7, smycka     ; skok pri EOC=0
        ld      A, ADC_DRH              ; A = ADC vysl.
        cpl     A                       ; negace A
        ld      PB_ODR, A               ; vystup LED = A
        
l                l¨jp      start                   ; skok na start

;	podprogram zpozdeni 0,5 s (pro fCPU = 2 MHz)
;-----------------------------------------------------------

wait	push	CC		; uschovani priznaku
	mov	poc1,#INI_POC1	; pocitadlo vnejsiho cyklu
w_2	ldw	Y,#INI_Y	; vnìjší cyklus 5x  <-------
				;			   |
			; vnitrni cyklus 50 000x           |
w_1	decw	Y	; dekrementuji 	<------------      |
			;			    |      |
	jrne	w_1	; dokud neni 0 opakuj -------      |
			; cykly (2+2)*50 000=200 000       |
			; tj. 0.1 s pro fCPU 2 MHz         |
			;                                  |
	dec	poc1		; pocitadlo vnejsiho cyklu |
	jrne	w_2		; test na nulu   -----------
	pop	CC		; rekonstrukce priznaku
	ret			; 5 x 0,1 s = 0,5 s
				
				
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
