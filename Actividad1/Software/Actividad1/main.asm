;
; Actividad1.asm

.cseg
.org 0x00

.def temp = r16
.def selector = r17 //definicion de registros

	ldi temp, high(RAMEND) //obtiene byte alto
	out SPH, temp
	ldi temp, low(RAMEND)  //obtiene byte bajo 
	out SPL, temp


	//configuracion de puertos
	//salida: bit 5 del puerto B (led)
	sbi DDRB, PB5		//bit 5 del puerto B como salida
	cbi PortB, PB5		//inicia el nivel bajo (0)


	//entradas: bit 2 y bit 3 del puerto D
	cbi DDRD, PD2		//bit 2 del puerto D como entrada
	cbi DDRD, PD3		//bit 3 del puerto D como entrada
	sbi PORTD, PD2		//activacion de la resistencia pull-up en PD2
	sbi PORTD, PD3		//activacion de la resistencia pull-up en PD3
	

	//evalua las entradas de seleccion (PD2 y PD3) para la seleccion de frecuencia
start:
	in selector, PIND		//lee el puerto de entrada D
	lsr selector
	lsr selector			//desplaza los bits 2 y 3 hacia la posicion 0 y 1
	andi selector, 0x03		//conservar solo los dos bits de seleccion 

	//seleccion de frecuencia segun los bits leidos
	cpi selector, 0x00
	breq frec_100k			// si es 00 = 100khz

	cpi selector, 0x01
	breq frec_500k			// si es 01 = 500khz

	cpi selector, 0x02
	breq frec_1m			// si es 10 = 1 Mhz

	rjmp frec_2m			// si es 11 = 2 Mhz

//Subrutinas de generacion de frecuencia 

	//frecuencia 1: 100khz, semiperiodo de 5us = 80 ciclos
frec_100k:
	sbi PINB, PINB5			//invierte estado de PB5
	ldi temp, 25			//carga contador para el retardo 
delay_100k:
	dec temp
	brne delay_100k
	rjmp start				//regresa a verificar entradas

	//frecuencia 2: 500khz, semiperiodo se 1us = 16 ciclos
frec_500k:
	sbi PINB, PINB5			//invierte estado de PB5
	ldi temp, 4				//carga contador para retardo
delay_500k:
	dec temp
	brne delay_500k
	rjmp start				//regresa a verificar entradas

	//frecuencia 3: 1Mhz, semiperiodo de 0.5us = 8 ciclos
frec_1m:
	sbi PINB, PINB5			//invierte estado de PB5
	nop						//ajuste manual de ciclos de reloj
	nop
	nop
	nop
	nop
	rjmp start				//regresa a verificar entradas

	//frecuencia 4: 2Mhz, semiperiodo de 0.25us = 4 ciclos
frec_2m:
	sbi PINB, PINB5			//invierte estado de PB5
	nop						//ajuste manual de ciclos
	rjmp start				//regresa a verificar entradas