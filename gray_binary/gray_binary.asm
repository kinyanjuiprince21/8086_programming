.MODEL medium

.DATA
;Definition of Variable        
    var     db  ?  
    counter db 10
    
;Menu Strings
    Menu        db "ENTER:1.Binary-Gray$"  
    Menu2       db "2.Gray-Binary$"
    Header      db " ECE LAB$"   
    Header2     db "GRAY-BINARY CONVERTR$"
    Prompt1     db "Enter Binary Number$"  
    Prompt2     db "Enter Gray Number$"
    result1     db "Gray equivalent:$"
    result2     db "Binary equivalent$"
    invalidentry  db "Sorry, Invalid entry$"
                                          
	
	;Result bits
	bit0 db ?
	bit1 db ?
	bit2 db ?
	bit3 db ?
	bit4 db ?
	bit5 db ?
	bit6 db ?
	bit7 db ?
	
	bit  db ?
    
;Port values
    PORTA_VAL DB 0
    PORTB_VAL DB 0
    PORTC_VAL DB 0 
    KEY       DB ? 
    
;Port Addresses     
    PORTA EQU 00H 	
	PORTB EQU 02H 	
	PORTC EQU 04H
	PCW   EQU 06H

.STACK 128  
;----------------------------------------------------------------
;This is a macro to set cursor position on the LCD
GOTO_XY MACRO x,y     
    MOV DL,y
   MOV DH,x
   CALL LCD_SET_CUR     
ENDM
;------------------------------------------------------------
.CODE

main:  ;program starts here
   ;Initialize data segment
   mov ax,@data
   mov ds,ax
   mov es,ax     
   
   ;Send Control word to PPI
   mov dx,PCW
   mov al,10001000b ; control word, mode 0
   out dx,al
   
   call LCD_INIT     ;Initialize LCD   
   call converter

proc converter
    	
	GOTO_XY 4,1
	
	LEA SI,Header
	CALL LCD_PRINTSTR 
	GOTO_XY 1,2
	
	LEA SI,Header2
	CALL LCD_PRINTSTR 
	
	MOV CX,60000
	CALL DELAY   	
	MOV CX,60000
	CALL DELAY
	CALL LCD_CLEAR
	
	
begin:
		
	GOTO_XY 1,1
	
	LEA SI,Menu
	CALL LCD_PRINTSTR 
	GOTO_XY 1,2 
	 
	LEA SI,Menu2
	CALL LCD_PRINTSTR 
	
	CALL get_KeyPress
    call select
endp  
	
;-----MENU SELECTION------------------    
select:
    cmp var, 1  
    je s1
    cmp var, 2  
    je s2  
    cmp var, 3  
    je s3  
    
    s1: call Binary_Gray
    s2: call Gray_Binary
    s3: call Exit                 
    ret
endp 
;-----------------------------------------------------------
proc Gray_Binary    
    CALL LCD_CLEAR
	
	GOTO_XY 1,1       
	LEA SI,Prompt2
	CALL LCD_PRINTSTR 
    GOTO_XY 1,2 
    
    mov counter,0
	keypress:
    	call get_KeyPress
    	call checkvalid         ;check if entererd value is 0 or 1
    	; switch case
    	    cmp counter,0
    	    je b0
    	    jne c1
    	      b0:mov al,var
    	      mov bit0,al
    	      
    	 c1:cmp counter,1
    	    je b1
    	    jne c2
    	      b1:mov al,var
    	         xor al,bit0    	         
    	         mov bit1,al
    	         
    	 c2:cmp counter,2
    	    je b2
    	    jne c3
    	      b2:mov al,var
    	         xor al,bit1
    	         mov bit2,al 
    	    
    	 c3:cmp counter,3
    	    je b3
    	    jne c4
    	      b3:mov al,var
    	         xor al,bit2
    	         mov bit3,al
    	    jne c4
    	 c4:cmp counter,4
    	    je b4
    	    jne c5
    	      b4:mov al,var
    	         xor al,bit3
    	         mov bit4,al
    	    
    	 c5:cmp counter,5
    	    je b5 
    	    jne c6
    	      b5:mov al,var
    	         xor al,bit4
    	         mov bit5,al
    	    jne c6
    	 c6:cmp counter,6  
    	    je b6
    	    jne c7
    	      b6:mov al,var
    	         xor al,bit5
    	         mov bit6,al
    	    
    	 c7:cmp counter,7
    	    je b7
    	    jne c8
    	      b7:mov al,var
    	         xor al,bit6
    	         mov bit7,al
    	
    c8:	mov al,counter
    	add al,1
    	mov counter,al
    	cmp counter,8    	
    	jne keypress 
    	je re
    	re:     	        
           CALL LCD_CLEAR
           GOTO_XY 1,1   
           LEA SI,result2 
           CALL LCD_PRINTSTR 
           jmp result
	ret	
endp 
;-------------------------------------------

proc result
   
   GOTO_XY 1,2
    
   mov al,bit0
   add al,30h      ;covert to ascii
   MOV AH,al
   CALL LCD_WRITE_CHAR
   mov al,bit1
   add al,30h   
   MOV AH,al
   CALL LCD_WRITE_CHAR
   mov al,bit2
   add al,30h   
   MOV AH,al
   CALL LCD_WRITE_CHAR
   mov al,bit3
   add al,30h   
   MOV AH,al
   CALL LCD_WRITE_CHAR
   mov al,bit4
   add al,30h   
   MOV AH,al
   CALL LCD_WRITE_CHAR
   mov al,bit5
   add al,30h   
   MOV AH,al
   CALL LCD_WRITE_CHAR
   mov al,bit6
   add al,30h   
   MOV AH,al
   CALL LCD_WRITE_CHAR
   mov al,bit7
   add al,30h   
   MOV AH,al
   CALL LCD_WRITE_CHAR
	
   rept: 
     call get_KeyPress
     cmp var,22
     je  begin
     jne begin
   jmp rept
    
    
endp

;-----------------------------------------------
proc Binary_Gray 
    CALL LCD_CLEAR
	
	GOTO_XY 1,1       
	LEA SI,Prompt1
	CALL LCD_PRINTSTR 
    GOTO_XY 1,2 
    
    mov counter,0
	press:
    	call get_KeyPress
    	call checkvalid
    	;case switch
    	    cmp counter,0
    	    je bb0
    	    jne cc1
    	      bb0:mov al,var
    	      mov bit0,al
    	      
    	 cc1:cmp counter,1
    	    je bb1
    	    jne cc2
    	      bb1:mov al,var 
    	          mov bl,var
    	         xor al,bit0    	         
    	         mov bit1,al 
    	         mov bit,bl
    	         
    	 cc2:cmp counter,2
    	    je bb2
    	    jne cc3
    	      bb2:mov al,var
    	          mov bl,var
    	         xor al,bit
    	         mov bit,bl
    	         mov bit2,al 
    	    
    	 cc3:cmp counter,3
    	    je bb3
    	    jne cc4
    	      bb3:mov al,var
    	          mov bl,var
    	         xor al,bit
    	         mov bit3,al
    	         mov bit,bl
    	    jne cc4
    	 cc4:cmp counter,4
    	    je bb4
    	    jne cc5
    	      bb4:mov al,var
    	          mov bl,var
    	         xor al,bit
    	         mov bit4,al
    	         mov bit,bl
    	    
    	 cc5:cmp counter,5
    	    je bb5 
    	    jne cc6
    	      bb5:mov al,var
    	          mov bl,var
    	         xor al,bit
    	         mov bit5,al
    	         mov bit,bl
    	 cc6:cmp counter,6  
    	    je bb6
    	    jne cc7
    	      bb6:mov al,var
    	          mov bl,var
    	         xor al,bit
    	         mov bit6,al
    	         mov bit,bl
    	    
    	 cc7:cmp counter,7
    	    je bb7
    	    jne cc8
    	      bb7:mov al,var 
    	          mov bl,var
    	         xor al,bit
    	         mov bit7,al
    	
    cc8:mov al,counter
    	add al,1
    	mov counter,al
    	cmp counter,8    	
    	jne press 
    	je re2
    	re2:     	
	       CALL LCD_CLEAR    
           GOTO_XY 1,1
           CALL LCD_CLEAR 
           LEA SI,result1 
           CALL LCD_PRINTSTR 
           jmp result    	
	        
 ret                                         ;
endp                                         ;
;-------------------------------------------------------- 
proc checkvalid 
    cmp var,0
    jne check2
    je return
    
    check2:
     cmp var,1
     jne invalid
     je return
    invalid: 
     call LCD_CLEAR
     GOTO_XY 1,1
     LEA SI,invalidentry 
     CALL LCD_PRINTSTR
     MOV CX,60000
     CALL DELAY 
     jmp begin  
     
     return:
     ret       
    
endp
;-----------------------------------------------------
proc Exit

    CALL LCD_CLEAR    
    GOTO_XY 1,1
    LEA SI,Header
    CALL LCD_PRINTSTR
    MOV CX,60000
    CALL DELAY
    CALL LCD_CLEAR
    GOTO_XY 1,2 
    CALL get_KeyPress
    CALL converter    

endp 
;------------------------------------------------------------------
;------------------------------------------------------------------
;DELAY Procedure
proc DELAY
;input: CX, this value controls the delay. CX=50 means 1ms
;output: none
	JCXZ @DELAY_END
	@DEL_LOOP:
	LOOP @DEL_LOOP	
	@DELAY_END:
	RET
endp DELAY  
;-------------------------------------------------------
;sends data to output port and saves them in a variable
;------------------------------------------------------
;input: AL
;output: PORTA_VAL
PROC OUT_A
	PUSH DX
	MOV DX,PORTA
	OUT DX,AL
	MOV PORTA_VAL,AL
	POP DX
	RET	
ENDP OUT_A
;----------------------------------
;input: AL
;output: PORTB_VAL
PROC OUT_B	
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

;-----------------------------------------------;
;                                               ;
;        LCD LIBRARY FUNCTIONS                  ;
;                                               ;
;-----------------------------------------------;
;-----------------------------------------------------
; LCD INITIALIZATION    
;input: none
;output: none
PROC LCD_INIT
;make RS=En=RW=0
	MOV AL,0
	CALL OUT_B
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
	
;function set
	MOV AH,38H                ;8 BIT 2 LINE 5*7 DOTS
	CALL LCD_CMD
	                          ;DISPLAY ON CUSOR OFF
	MOV AH,0CH
	CALL LCD_CMD
	
	MOV AH,01H                ;CLEAR DISPLAY
	CALL LCD_CMD
	
	MOV AH,06H                ;ENTRY MODE
	CALL LCD_CMD
	
	RET	
ENDP LCD_INIT

;-----------------------------------------------
;SEND COMMAND to LCD
;input: AH = command code
;output: none
PROC LCD_CMD
;save registers
	PUSH DX
	PUSH AX
;make rs=0
	MOV AL,PORTB_VAL
	AND AL,0FDH		;En-RS-RW   ;DATA TO SELECT INSTRUCTION REGISTER BY MAKING RS 0 AND RW 1(READ)
	CALL OUT_B
;set out data pins
	MOV AL,AH
	CALL OUT_A
;make En=1
	MOV AL,PORTB_VAL
	OR	AL,100B		;En-RS-RW   ;DATA TO MAKE ENABLE 1
	CALL OUT_B
;delay 1ms
	MOV CX,50
	CALL DELAY
;make En=0
	MOV AL,PORTB_VAL
	AND AL,0FBH		;En-RS-RW   ;DATA TO MAKE ENABLE 0 AND SELECT DATA REGISTER BY MAKING RS 1 AND RW 1(READ)
	CALL OUT_B
;delay 1ms
	MOV CX,50
	CALL DELAY
;restore registers
	POP AX
	POP DX	
	RET
ENDP LCD_CMD


;----------------------------------------------
;CLEAR DISPLAY
PROC LCD_CLEAR
	MOV AH,1             ; CLEAR DISPLAY
	CALL LCD_CMD
	RET	
ENDP LCD_CLEAR

;--------------------------------------------
;WRITE A CHARACTER on current cursor position 
;input: AH
;output: none
PROC LCD_WRITE_CHAR
;save registers
	PUSH AX
;set RS=1                ;DATA REG
	MOV AL,PORTB_VAL
	OR	AL,10B		;EN-RS-RW
	CALL OUT_B
;set out the data pins
	MOV AL,AH
	CALL OUT_A
;set En=1
	MOV AL,PORTB_VAL
	OR	AL,100B		;EN-RS-RW
	CALL OUT_B
;delay 1ms
	MOV CX,50
	CALL DELAY
;set En=0
	MOV AL,PORTB_VAL
	AND	AL,0FBH		;EN-RS-RW
	CALL OUT_B
;return
	POP AX
	RET	
ENDP LCD_WRITE_CHAR

;--------------------------------------
;PRINT STRING on current cursor position
;input: SI=string address, string should end with '$'
;output: none
PROC LCD_PRINTSTR
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

;-------------------------------------
;SET CURSOR 
;input: DL=ROW, DH=COL
;		DL = 1, means upper row
;		DL = 2, means lower row
;		DH = 1-16, 1st column is 1
;output: none
PROC LCD_SET_CUR
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

;----------------------------------
;CUSOR BLINKING
;input: none
;output: none
PROC LCD_SHOW_CUR
	PUSH AX
	MOV AH,0FH      ;DISPLAY ON CUSOR BLINKING
	CALL LCD_CMD
	POP AX
	RET
ENDP LCD_SHOW_CUR


;-----------------------------------
;Function to turn Cursor OFF
;input: none
;output: none
PROC LCD_HIDE_CUR
	PUSH AX
	MOV AH,0CH       ;DISPLAY ON CUSOR OFF
	CALL LCD_CMD
	POP AX
	RET
ENDP LCD_HIDE_CUR
;----------------------------------

end main; End of program  
                 