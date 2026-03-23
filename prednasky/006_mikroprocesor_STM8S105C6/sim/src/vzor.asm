stm8/
	title Vzorovy program STM8s PPS 2021 Kit
	
	.nolist
	#include "mapping.inc"
	#include "STM8S208RB.inc"
	.list
	
;***********************************************************
;	vzorovy program pro pripravek STM8S Discovery Kit
;	s mikroprocesorem STM8S105c6
;
;	blikani jednou LED
;***********************************************************

;	definice ridicich slov
;-----------------------------------------------------------
		BYTES
CW_PB_DDR	equ	%11111111	; vse vystup
CW_PB_CR1	equ	%11111111	; vse push/pull
INI_PB_ODR	equ	%11111111	; inicializace - zhasne LED
INI_POC1	equ	5		; pocitadlo vnejsiho cyklu
		WORDS
INI_Y		equ	50000		; pocitadlo vnitrniho cyklu 

;	vyhrazeni mista pro promenne
;-----------------------------------------------------------
	segment 'ram0'
	
poc1	ds.b	1			; rezervace 1 bytu v pameti


;	hlavni program
;-----------------------------------------------------------
	
	segment 'rom'
main.l
	call	ini_hw		; inicializace registr;
	
hop	bcpl	PB_ODR,#0	; negace nejnizsiho bitu sviti/nesviti
	call	wait		; pockame
	jp	hop		; a znova


;	podprogram inicializace hw
;-----------------------------------------------------------
ini_hw	mov	PB_ODR,#INI_PB_ODR	; uvodni nastaveni zhasne 
	mov	PB_CR1,#CW_PB_CR1	; nastaveni brany PB na vystup
	mov	PB_DDR,#CW_PB_DDR	; nastaveni brany PB na vystup
	ret				; dalsi registry nastavuje RESET	


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
