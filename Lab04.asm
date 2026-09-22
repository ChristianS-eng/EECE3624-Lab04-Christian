/**************************************************************************
 *     File: Lab04.asm
 * Lab Name: What's Your Calling?
 *   Author: Christian Sorensen
 *  Created: September 21, 2026
 *
 * This program implements a recursive factorial function
 *************************************************************************/ 
 .def n = R16
.def result = R17
.org 0x0000 ; next instruction will be written to address 0x0000
            ; (the location of the reset vector)
rjmp main	; set reset vector to point to the main code entry point

main:       ; jump here on reset

		; initialize the stack (RAMEND = 0x10FF by default for the ATmega128A)
		ldi R16, HIGH(RAMEND)
		out SPH, R16
		ldi R16, low(RAMEND)
		out SPL, R16

		LDI  n, 5	; load a value into n
		PUSH n	; push it on the stack
		CALL factN	; calculate the factorial of n
		POP  result	; pop result off stack
here:
		RJMP here	; loop forever

factN:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 
	; factN is a recursive factorial function.
	;
	; It is a SIMPLE FUNCTION. It works on the values
	; 1 through 5.
	;
	; An input of 0 WILL NOT OUTPUT 1
	; AS MATHEMATICALLY EXPECTED, nor
	; are inputs greater than 5 supported.
	; 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; recursive factorial code begins here

	IN YL, SPL	
	IN YH, SPH	; Set pointer Y to match the stack pointer

	LDD R18, Y+3 ; Fetch the value pushed

	CPI R18, 0x01	; Test for base case
	BRNE recursiveCase ; Recurse as necessary

	RET	; Ready to pop to result

recursiveCase:

	DEC R18
	PUSH R18	; Decrement "old argument" and push "new argument"

	CALL factN ; Compute with new argument

	IN YL, SPL
	IN YH, SPH	; Set pointer Y to match the stack pointer

	POP R19
	LDD R18, Y+4 ; Fetch top two values of stack

	MUL R18, R19 ; Multiply them

	IN YL, SPL
	IN YH, SPH ; Adjust Y

	STD Y+3, R0	; Store product in address below
				; Each n per function call is now n!

	RET 
	; return from the factN subroutine