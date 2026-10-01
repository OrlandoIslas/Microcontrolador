;
; Actividad1.asm
;
; Created: 30/09/2026 08:04:24 p. m.
; Author : Orlando Islas

.cseg
.org 0x00

.def temp = r16
.def selector = r17

	ldi temp, high(RAMEND)
	out SPH, temp
	ldi temp, low(RAMEND)
	out SPL, temp

	sbi DDRB, PB5
	cbi PortB, PB5

	cbi DDRD, PD2
	cbi DDRD, PD3
	sbi PORTD, PD2
	sbi PORTD, PD3
	
start:
	in selector, PIND
	lsr selector
	lsr selector
	andi selector, 0x03

	cpi selector, 0x00
	breq frec_100k

	cpi selector, 0x01
	breq frec_500k

	cpi selector, 0x02
	breq frec_1m

	rjmp frec_2m


frec_100k:
	sbi PINB, PINB5
	ldi temp, 25
delay_100k:
	dec temp
	brne delay_100k
	rjmp start 

frec_500k:
	sbi PINB, PINB5
	ldi temp, 4
delay_500k:
	dec temp
	brne delay_500k
	rjmp start


frec_1m:
	sbi PINB, PINB5 
	nop 
	nop
	nop
	nop
	nop
	rjmp start 

frec_2m:
	sbi PINB, PINB5
	nop
	rjmp start