org 100h

.data
pool db 'apple', 0, 'app',0,'bicycle', 0 , 'town',0, 'red',0,'blue',0,'mouse',0,
     db 'stack', 0, 'memory', 0, 'juja', 0, 'game', 0, 

win    db 10,13,"Congratulations!$"

result db 10,13,"Total correct guesses: $" 
entry  db 10,13,"Enter new word: $"
space  db ": $" 
trial  db 10,13,"Trial No.$"
tries  db ?
P1 LABEL BYTE
    M1  DB 0FFH
    L1  Db ?
    P11 DB 0FFH DUP ('$') 
    

.code 
begin:
    mov ax, @data
    mov ds, ax
    
    mov cx, 255 
    mov dx, offset trial
    mov ah, 09
    int 21h 
    
    add tries, 30h
    add tries, 1h
    
    mov dl,  tries
    mov ah, 02
    int 21h   
    
    sub tries, 1h
    sub tries, 30h 
    
    mov dx, offset entry
    mov ah, 09
    int 21h
     
    LEA DX,P1
    MOV AH,0AH    
    INT 21H

comp:
    mov dl, l1
    mov dh, 0
    
    cmp di, dx
    je wordeol
    
    mov al, pool[si]
    
    push ax
    
    mov ah, 0eh
    int 10h 
    
    mov al, space
    mov ah, 0eh
    int 10h
    
    mov al, p11[di]
    mov ah, 0eh
    int 10h
    
    pop ax
    
    cmp bp, 0bh
    je POOLEND
    
    cmp al, p11[di]             
    jne NOTEQUAL
    
    inc si
    inc di
    
    loop comp
    
WORDEOL:
    dec di
    
    cmp al, p11[di]
    jne notequal
    
    mov al, pool[si]
    cmp al, 0
    jne notequal 
    
    inc bl  ;stores wins  
    
    mov dx, offset win
    mov ah, 09
    int 21h
    
    jmp poolend
    
NOTEQUAL:
    mov al, pool[si]
    
    cmp al, 0
    je reset 
    
    inc si
    
    loop NOTEQUAL

reset:                          
    inc si
    xor di, di
    inc bp
    
    jmp COMP
    
POOLEND:            ;word found reset pool too
    xor si, si
    xor di, di
    xor bp, bp
    
    mov dl, tries
    inc dl    
    
    mov tries, dl
    cmp tries, 5h
    je results
    
    mov dx, offset trial
    mov ah, 09
    int 21h
    
    add tries, 30h
    add tries, 1h
    
    mov dl,  tries
    mov ah, 02
    int 21h   
    
    sub tries, 1h
    sub tries, 30h

input:
    mov dx, offset entry
    mov ah, 09
    int 21h
    
    LEA DX,P1
        MOV AH,0AH    
        INT 21H
        jmp comp
    
results: 
    mov dx, offset result
    mov ah, 09
    int 21h
    
    mov dl, bl
    add dl, 30h
    mov ah, 02  
    int 21h 
    
exit: 
    mov ah, 4ch
    int 21h
