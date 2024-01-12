.MODEL medium

DATA SEGMENT
    VALUE DB 30H
    DECVALUE DB 39H
    var     db  ?
    TIMER DB 0  
    Menu        db "ENTER:1.Up Counter$"  
    Menu2       db "2.Down Counter$" 
    Header      db " ECE LAB$"
    UPCOUNTER DB "UP COUNTER:$"
    DOWNCOUNTER DB "DOWN COUNTER:$"
    STRING DB "HALT"   
    PORTA_VAL DB 0		 ;variable to keep track of portB data
    PORTB_VAL DB 0
    PORTC_VAL DB 0  
    KEY       DB ? 
;port addresses  
    PORTA EQU 00H 	;PORTA IS CONNECTED TO THE D7-D0
	PORTB EQU 02H 	;PORTB0 IS RW, PORTB1 IS RS, PORTB2 IS EN 
	PORTC EQU 04H
	PCW   EQU 06H	;PORT FOR IO CONTROL
    
ENDS

STACK SEGMENT
    DW   128  DUP(0)
ENDS

CODE SEGMENT
START:
;define IO ports
    MOV DX,PCW
    MOV AL,10001000b   ;to make all ports output (MODE 0)
    OUT DX,AL 
    
    MOV CX,60000
	CALL DELAY 
    	   
	CALL LCD_INIT
	
    MOV AX, @DATA   
    MOV DS, AX  
    
proc BEGIN
    MOV DL,1
    MOV DH,1
    CALL LCD_SET_CUR
    LEA SI,Menu
    CALL LCD_PRINTSTR
    
    MOV DL,2
    MOV DH,1
    CALL LCD_SET_CUR
    LEA SI,Menu2
    CALL LCD_PRINTSTR
    
    CALL get_KeyPress
    CALL select 
endp    
    
;-----MENU SELECTION------------------    
select:
    cmp var, 1  
    je s1
    cmp var, 2  
    je s2  
    cmp var, 3  
    je s3  
    
    s1: call UP
    s2: call DOWN
    s3: call Exit                 
    ret
endp        

proc UP 
    MOV DL,1
	MOV DH,1
	CALL LCD_SET_CUR
	
	LEA SI,UPCOUNTER
	CALL LCD_PRINTSTR
	
    MOV DL,2
	MOV DH,1
	CALL LCD_SET_CUR
	
    MOV AH, VALUE       ;move value into AH to be printed
	CALL LCD_WRITE_CHAR ;function to print on lcd
    MOV CX,50000
	CALL DELAY
    INC VALUE
    INC TIMER
    CALL LCD_CLEAR 
    CMP TIMER, 9
    JBE UP
    
    MOV DL,1
	MOV DH,1
	CALL LCD_SET_CUR
	
    MOV CX,60000
	CALL DELAY
	
	CALL LCD_CLEAR
	
	MOV TIMER, 0 
	CALL BEGIN
	HLT  
	
endp	

proc DOWN
    MOV DL,1
	MOV DH,1
	CALL LCD_SET_CUR
	
	LEA SI,DOWNCOUNTER
	CALL LCD_PRINTSTR
	
    MOV DL,2
	MOV DH,1
	CALL LCD_SET_CUR
	
	DEC DECVALUE
    MOV AH, DECVALUE       ;move remainder into AH to be printed
	CALL LCD_WRITE_CHAR ;function to print on lcd
    MOV CX,50000
	CALL DELAY
    INC TIMER
    CALL LCD_CLEAR 
    CMP TIMER, 9
    JBE DOWN
    
    MOV DL,1
	MOV DH,1
	CALL LCD_SET_CUR
	
	
	MOV CX,60000
	CALL DELAY
	
	
	CALL LCD_CLEAR
	
	MOV TIMER, 0 
	CALL BEGIN
	 
	HLT
endp

proc Exit

    CALL LCD_CLEAR    
    CALL BEGIN
    MOV CX,60000
    CALL DELAY
    CALL LCD_CLEAR
    MOV DL,1
    MOV DH,2
    CALL LCD_SET_CUR 
    CALL get_KeyPress
    HLT    

endp

;sends data to output port and saves them in a variable
PROC OUT_A
;input: AL
;output: none
	PUSH DX
	MOV DX,PORTA
	OUT DX,AL  ;output content of AL to address in DX
	POP DX
	RET	
ENDP OUT_A

PROC OUT_B
;input: AL
;output: PORTB_VAL	
	PUSH DX
	MOV DX,PORTB
	OUT DX,AL
	MOV PORTB_VAL,AL
	POP DX
	RET
ENDP OUT_B 

;---------------------------------
;Punction to output value in port C
;input: AL
;output: PORTC_VAL
proc OUT_C	
	PUSH DX
	MOV DX,PORTC
	OUT DX,AL
	MOV PORTC_VAL,AL
	POP DX
	RET
endp OUT_C  
  
;----------------------------------
;-----------------------------------------------;
;                                               ;
;        KEY PRESS FUNCTION                     ; 
;                                               ; 
;-----------------------------------------------; 
proc get_KeyPress  
    push cx
    keypad:
   ; MOV CX,00FFH            ; fill in the value of CX with 00ffH
    MOV AL,11111110b        ; value = 1111 1110, set column 0 low
    MOV DX,PORTC            ; mov PORTC to DX
    OUT DX,AL               ;Give this value to PORTA
     
    COLUMN0: 
	 ;Check ROW0
     IN AL,PORTC            ; Get PORTB value 
     MOV KEY,AL    
     CMP KEY,11101110b      ; If PORTB =1111 1110 - button 1 Keypad is pressed?
     JNE ROW1               ; If not, go to ROW1   
     MOV CX,20000           ; delay abit
     CALL DELAY
     MOV AH,'1'             ; Output '1' 
     CALL LCD_WRITE_CHAR 
	 MOV AH,1 
	 MOV VAR,AH             ;store the key pressed
     JMP GOE                 ; continue loop

     ROW1: 
     CMP AL,11011110B       ; Is PORTB == 11011110B  or (4)Keypad button pressed?
     JNE ROW2               ; If not, go to ROW2 of column 1
     MOV CX,20000
	 CALL DELAY
     MOV AH,'4'
	 CALL LCD_WRITE_CHAR
     MOV AH,4 
	 MOV VAR,AH 
     JMP GOE                 ; Continue looop
     
     ROW2: 
     CMP AL,10111110B       ; Is PORTB == 10111110B or 7 Keypad button pressed?
     JNE ROW3               ; If not, go to ROW3
     MOV CX,20000
	 CALL DELAY
	 MOV AH,'7'
	 CALL LCD_WRITE_CHAR
     MOV AH,7 
	 MOV VAR,AH 
     JMP GOE                 ; Go to GO
     
     ROW3: 
     CMP AL,01111110B           ; Is PORTB == 01111110B or keypad star button pressed?
     JNE GO                 ; continue loop
     MOV CX,20000
	 CALL DELAY
     MOV AH,'*'
     CALL LCD_WRITE_CHAR
     MOV AH,11 
	 MOV VAR,AH 
	 JMP GOE
     
     GO:
    ;LOOP COLUMN0             ; Looping to COLUMN1 is CX
    
    MOV CX,00FFH            ; Initialize counter
    MOV AL,11111101B             ; value = 1111 1101, set column 1 low
    MOV DX,PORTC            ; enter PORTA to DX
    OUT DX,AL               ; Give this value to PORTA
     
    COLUMN1: 
                            
     IN AL,PORTC  
     MOV KEY,AL
     CMP KEY,11101101B      ; Is PORTB == 11101101B or 2 Keypad button pressed?           
     JNE ROW11             ; If not, go to ROW12
     MOV CX,20000
	 CALL DELAY  
     MOV AH,'2'
	 CALL LCD_WRITE_CHAR 
	 MOV AH,2
	 MOV VAR,AH 
     JMP GOE
     
     ROW11: 
     CMP AL,0FDH            ; Is PORTB == 0FDH or 5 Keypad button pressed?
     CMP KEY,11011101B
     JNE ROW21              ; If not, go to ROW22
     MOV CX,20000
	 CALL DELAY
	 MOV AH,'5'
	 CALL LCD_WRITE_CHAR
	 MOV AH,5 
	 MOV VAR,AH
     JMP GOE       
      
     ROW21: 
     CMP AL,10111101B            ; Is PORTB == 0F10111101BBH or keypad 8 keypad being pressed?
     JNE ROW31             ;If not, go to ROW32
     MOV CX,20000
	 CALL DELAY
	 MOV AH,'8'
	 CALL LCD_WRITE_CHAR
	 MOV AH,8 
	 MOV VAR,AH
     JMP GOE                ; continue loop
     
     ROW31:               
     CMP AL,01111101B           ; Is PORTB == 01111101B or keypad 0 keypad being pressed?
     JNE GO2                ; If not, go to GO2
     MOV CX,20000
	 CALL DELAY
	 MOV AH,'0'
	 CALL LCD_WRITE_CHAR
	 MOV AH,0 
	 MOV VAR,AH
     JMP GOE 
     
     GO2:                   
    ;LOOP COLUMN1            ; Looping to COLUMN2 is CX
     
    MOV CX,00FFH            ; fill in the value of CX with 00ffH 
    MOV AL,11111011B             ; value = 1111 1011, set column 2 low
    MOV DX,PORTC            ; enter PORTC to DX
    OUT DX,AL               ; Give this value to PORTC
    
     COLUMN2: 
    
     IN AL,PORTC            ; Get PORTB value
     MOV KEY,AL
     CMP KEY,11101011B      ; Is PORTB == 11101011B or button 3 Keypad is pressed?
     JNE ROW12             ; If not, go to ROW13
     MOV CX,20000
	 CALL DELAY
	 MOV AH,'3'
	 CALL LCD_WRITE_CHAR
	 MOV AH,3 
	 MOV VAR,AH
     JMP GOE                ; Continue loop
     
     ROW12: 
     CMP KEY,11011011B    ; Is PORTB == 11011011B or 6 Keypad button pressed?
     JNE ROW22            ;If not, go to ROW23
     MOV CX,20000
	 CALL DELAY
	 MOV AH,'6'
	 CALL LCD_WRITE_CHAR
	 MOV AH,6 
	 MOV VAR,AH
     JMP GOE                ; continue loop
     
     ROW22: 
     CMP KEY,10111011B     ; Is PORTB == 10111011B or keypad 9 key pressed?
     JNE ROW32             ; If not, go to ROW33
     MOV CX,20000
	 CALL DELAY
	 MOV AH,'9'
	 CALL LCD_WRITE_CHAR
	 MOV AH,9 
	 MOV VAR,AH
     JMP GOE                ; Continue loop
     
      ROW32:               ; Is PORTB == 0F7H or Keypad # button pressed?
     CMP KEY,01111011B           
     JNE GO3                
     MOV CX,20000
     CALL DELAY
     MOV AL,VAR
     ;PUSH AX
     MOV AH,22
     MOV VAR,AH
     JMP GOE      
     
     GO3:
    ;LOOP COLUMN2            ; Looping to COLUMN2 by CX    
    JMP keypad               ; Repeat the program again  
    
    GOE:
    ;CMP VAR,22
    ;JNE keypad
    ;POP AX
    ;MOV VAR,AL   
    pop cx
    ret
endp
	
;end of main procedure

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                    ;
;		LCD function library.        ;
;                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PROC DELAY
;input: CX, this value controls the delay. CX=50 means 1ms
	JCXZ @DELAY_END
	@DEL_LOOP:
	LOOP @DEL_LOOP	
	@DELAY_END:
	RET
ENDP DELAY

; LCD initialization
PROC LCD_INIT
;input: none
;output: none

;make RS=En=RW=0
	MOV AL,0
	CALL OUT_B;OUT_B subroutine to output the value of AL to the appropriate port
;delay 20ms
	MOV CX,1000
	CALL DELAY
;reset sequence
	MOV AH,30H
	CALL LCD_CMD
	MOV CX,250
	CALL DELAY
	
	MOV AH,30H
	CALL LCD_CMD
	MOV CX,50
	CALL DELAY
	
	MOV AH,30H
	CALL LCD_CMD
	MOV CX,500
	CALL DELAY
	
;38H represents the function set command for configuring the LCD module
	MOV AH,38H
	CALL LCD_CMD
	
	MOV AH,0CH;turn on the display
	CALL LCD_CMD
	
	CALL LCD_CLEAR
	
	MOV AH,06H;configure the cursor movement
	CALL LCD_CMD
	
	RET	
ENDP LCD_INIT

;sends commands to LCD
PROC LCD_CMD
;input: AH = command code
;output: none

;save registers
	PUSH DX  ;preserve their original values
	PUSH AX
;make rs=0
	MOV AL,PORTB_VAL
	AND AL,0FDH ;clears the bit just before the LSB (RS bit) of AL. RS=0
	CALL OUT_B
;set out data pins
	MOV AL,AH
	CALL OUT_A ;output the value of AL to the data pins of the LCD module
;make En=1
	MOV AL,PORTB_VAL
	OR	AL,100B		;set En=1
	CALL OUT_B
;delay 1ms
	MOV CX,50
	CALL DELAY
;make En=0
	MOV AL,PORTB_VAL
	AND AL,0FBH		;set En=0
	CALL OUT_B
;delay 1ms
	MOV CX,50
	CALL DELAY
;restore registers
	POP AX  ; revert them to their original values
	POP DX	
	RET
ENDP LCD_CMD

PROC LCD_CLEAR
	MOV AH,1   ;clear screen
	CALL LCD_CMD
	RET	
ENDP LCD_CLEAR

;writes a character on current cursor position
PROC LCD_WRITE_CHAR
;input: AH
;output: none

;save registers
	PUSH AX
;set RS=1
	MOV AL,PORTB_VAL
	OR	AL,10B	
	CALL OUT_B
;set out the data pins
	MOV AL,AH
	CALL OUT_A
;set En=1
	MOV AL,PORTB_VAL
	OR	AL,100B		
	CALL OUT_B
;delay 1ms
	MOV CX,50
	CALL DELAY
;set En=0
	MOV AL,PORTB_VAL
	AND	AL,0FBH		
	CALL OUT_B
;return
	POP AX
	RET	
ENDP LCD_WRITE_CHAR

;prints a string on current cursor position
PROC LCD_PRINTSTR
;input: SI=string address, string should end with '$'
;output: none

;save registers
	PUSH SI
	PUSH AX
;read and write character
	@LCD_PRINTSTR_LT:
		LODSB
		CMP AL,'$'
		JE @LCD_PRINTSTR_EXIT
		MOV AH,AL
		CALL LCD_WRITE_CHAR	
	JMP @LCD_PRINTSTR_LT
	
;return
	@LCD_PRINTSTR_EXIT:
	POP AX
	POP SI
	RET	
ENDP LCD_PRINTSTR

;sets the cursor
PROC LCD_SET_CUR
;input: DL=ROW, DH=COL
;		DL = 1, means upper row
;		DL = 2, means lower row
;		DH = 1-8, 1st column is 1
;output: none

;save registers
	PUSH AX
;LCD uses 0 based column index
	DEC DH
;select case	
	CMP DL,1
	JE	@ROW1
	CMP DL,2
	JE	@ROW2
	JMP @LCD_SET_CUR_END
	
;if DL==1 then
	@ROW1:
		MOV AH,80H
	JMP @LCD_SET_CUR_ENDCASE
	
;if DL==2 then
	@ROW2:
		MOV AH,0C0H
	JMP @LCD_SET_CUR_ENDCASE
		
;execute the command
	@LCD_SET_CUR_ENDCASE:	
	ADD AH,DH
	CALL LCD_CMD
	
;exit from procedure
	@LCD_SET_CUR_END:
	POP AX
	RET
ENDP LCD_SET_CUR



CODE ENDS ;end of CODE segment
END START ; set entry point and stop the assembler.
       




