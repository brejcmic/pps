stm8/
	title Vzorovy program STM8s PPS 2021 Kit
	
	.nolist
	#include "mapping.inc"
	#include "STM8S208RB.inc"
	.list

;-----------------------------------------------------------
;	DEFINICE - DEFINICNI KONSTANTY
;-----------------------------------------------------------
		BYTES
CISLO_BIN	equ	%11111111	; 255 binarne
CISLO_DEC	equ	255	        ; 255 dekadicky
CISLO_HEX	equ	$FF	        ; 255 hexadecimalne

;-----------------------------------------------------------
;	PAMET RAM - POJMENOVANI PROMENNYCH
;-----------------------------------------------------------
	segment 'ram0'
	
moje_promenna	ds.b	1	        ; vyhrazeni 1 byte
                                        ; pro promennou

;-----------------------------------------------------------
;	PAMET FLASH - PROGRAM
;-----------------------------------------------------------
	segment 'rom'
zacni_program.l
        ld A, #CISLO_DEC
        ld moje_promenna, A
        
smycka  dec moje_promenna
        jreq zacni_program
	jp smycka

;-----------------------------------------------------------
;	FUNKCE PRERUSENI A VEKTORY
;-----------------------------------------------------------

	interrupt NonHandledInterrupt
NonHandledInterrupt.l
	iret

	segment 'vectit'
	dc.l {$82000000+zacni_program}	        ; reset
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
