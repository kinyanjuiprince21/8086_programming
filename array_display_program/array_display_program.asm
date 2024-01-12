.MODEL small   ;Data and code<=64KB
     org 100h  ;to set the assembler location counter.
             
     
.STACK 100     ;Initialize the stack
.DATA    
    ;Define a 10 X 10 array
     ;db - define a byte (8)   -data diretive
     array db 1, 2, 3, 4, 5, 6, 7, 8, 9, 0
           db 2, 3, 4, 5, 6, 7, 8, 9, 0, 1
           db 3, 4, 5, 6, 7, 8, 9, 0, 1, 2
           db 4, 5, 6, 7, 8, 9, 0, 1, 2, 3
           db 5, 6, 7, 8, 9, 0, 1, 2, 3, 4
           db 6, 7, 8, 9, 0, 1, 2, 3, 4, 5
           db 7, 8, 9, 0, 1, 2, 3, 4, 5, 6
           db 8, 9, 0, 1, 2, 3, 4, 5, 6, 7
           db 9, 0, 1, 2, 3, 4, 5, 6, 7, 8
           db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
     
     ;define the length of the array     
     ar_len EQU 10     ;constant    
     
     Input_ReqMsg1 db 10,13,"Enter the value of the Row of the Matrix:",10,13,"$"        ;10 is ascii code for newline, 13-cariage return
     Input_ReqMsg2 db 10,13,"Enter the value of the Column of the Matrix:",10,13,"$"     ;$ indicates end of string
     Input_ReqMsg3 db 10,13,"Key in "New" to enter new value or "S" to halt.",10,13,"$" 
     newline db 10,13,"$"                                                                                                    
                                                                                                           
     row    db ?       ;user input row value  =null value
     column db ?       ;user input column  
     color  db 1        ;color index starting at blue   
     
     New db "New$"
     S   db "S$"
     
     buffer   db  5,?,5 dup(" ")   ;to store user input of either
     
;----------------------------------------------------------------------     
;our defined macro to set cursor location
;Name of Macro: GOTO_XY
;Parameters: x cordinate, y cordinate
;Output: NOne     
GOTO_XY MACRO x,y
    push dx
    push bx
    push ax
    mov dh,y ;row
    mov dl,x ;column
    mov bh,0 ;page
    mov ah,2
    int 10h         ;interrupt to set cursor position
    pop ax          ;LIFO
    pop bx
    pop dx   
ENDM 
;------------------------------------------------------------------------
;Delay macro/function
;delay duration =2000000uS = 001E 8480H
delay_2s MACRO
    mov ah, 86h          ;int 15h/ah=86h BIOS wait function.
      mov cx, 001Eh        ;CX:DX = interval in microseconds
      mov dx, 8480h
    int 15h              ;BIOS wait function
ENDM
;------------------------------------------------------------------------
     
.CODE 

MAIN:
    ;Initialize data segment REGISTER
    mov ax, @data
    mov ds,ax
    mov es,ax
;---------------------
                                      
    start:
    ;---------------------  
    lea si,array ;get address of array    
                 ;(mov si, offset array)-Alternatively 
                 
    ;Prompt row input 
    lea dx,Input_ReqMsg1
    mov ah, 9h
    int 21h  
    
    mov al,0
    ;User row input      
    mov ah,1     
    int 21h
    sub al,30h    ;Convert ascii code to hex
    mov row,al     ;store 
        
    ;----------------------
    ;Prompt column input
    lea dx,Input_ReqMsg2
    mov ah,9h
    int 21h 
    
    mov al,0
    ;User column input 
    mov ah,1   
    int 21h
    sub al,30h
    mov column,al
    ;-----------------------
    ;Go to new line
    lea dx,newline
    mov ah, 9h
    int 21h 
    
;-----------------------------    
show:call show_element          ;
     delay_2s
     call poll_keyboard 
     jmp show
;-----------------------------------------------------------------------    
PROC show_element
    ;calculate element position in array
    mov al,row 
    mov bx,10
    mul bl         ;Result stored in ax=(al*bx)
    add al,column  ;result stored in al 
    mov bl,al  
    
    mov al,[si+bx]
    add al,30h       ;convert num to ascii
    
    ;goto_xy 40,12       ; To display at the center of the screen
    ;print in color 
    mov ah,9
     mov bh,0        ;page
     mov bl,color    ;color
     mov cx,1        ;number of time to print the character
    int 10h         ;print char in AL   
    
    ;Increment color value
    ;mov cl,1
    add color,cl
  ret 
ENDP 
;---------------------------------------------------- 
proc poll_keyboard
   mov ah,01h
   int 16h            ;check for keystroke  
   jnz userInterrupt  ;if
   ret    
endp  
;----------------------------------------------------- 
proc userInterrupt  
    lea dx,Input_ReqMsg3 ;prompt user input on interupt
    mov ah, 9h
    int 21h   
    
    ;User to input either New or s
    mov dx, offset buffer
    mov ah, 0ah
    int 21h              ;enter string
    
    Compare_new: 
    cld                         ;clear direction flag
    mov si,offset New           ;string(New) moved to SI
    mov di,offset buffer+2      ;input stored in DI
    mov cx,3                    ;compare 3 characters
    repe cmpsb                  ;compares strings in the source and destination 
    je start
    jne compare_S
    
    Compare_S:
    cld                         ;clear direction flag
    mov si,offset S             ;string(New) moved to SI
    mov di,offset buffer+2      ;input stored in DI
    mov cx,1
    repe cmpsb                  ;compares strings in the source and destination
    je stop
    jne userInterrupt
  ret
endp
;--------------------------------------------------------

stop:
GOTO_XY 0,0 
call show_element
delay_2s
mov ah, 4ch
int 21h
;------------------------------------------------------------------------------------------------------------
 