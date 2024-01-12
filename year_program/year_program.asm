.model small
org 100h
.data
    months  db   "JanFebMarAprMayJunJulAugSepOctNovDecZ$"
    days    db   "SunMonTueWedThuFriSatZ$"
    counter dw ? 
    daynum  db   "01020304050607080910111213141516171819202122232425262728293031Z$"
    monthcode db "033614625035$" 
    yearp   db ?  
    yeara   db ?
    headline  db " CALENDAR$" 
    query   db   "Enter a year: $"
    yearcode  db ?
    centcode  db ?  
    day1 db ?
    P1 LABEL BYTE
    M1 DB 0FFH
    L1 DB ?
    P11 DB 0FFH DUP ('$')
    p11asc dw ? 
.code
begin:
    mov ax, @data
    mov ds, ax 
    
    push dx
    push cx
    push si  
    
    lea dx, query
    mov ah, 9h
    int 21h 
    
 
    LEA DX,P1
    MOV AH,0AH    
    INT 21H 
    
    mov al, 03h
    mov ah, 0
    int 10h
    
    mov cl, l1
    mov ch, 0
    xor si,si
    
    mov dh, 0
    mov dl, 10
    mov bh, 0
    mov ah, 2
    int 10h    
    
head:
    mov al, p11[si]
    mov ah, 0eh
    int 10h
    inc si
    loop head 
    
    mov cl, l1
    mov ch, 0
    xor si,si
 
getdate:
    sub p11[si], 48
    inc si
    loop  getdate
    
    mov al, p11[0]
    mov dl, 10
    mul dl
    mov yearp, al
    mov dl, p11[1]
    add yearp, dl
    
    mov al, p11[2]
    mov dl, 10
    mul dl
    mov yeara, al
    mov dl, p11[3]
    add yeara, dl 
    
    lea dx, headline
    mov ah, 9h
    int 21h 
    xor si,si
    mov cl, l1
    mov ch, 0
getascii:
    add p11[si], 48
    inc si
    loop  getascii
    pop si
    pop cx
    pop dx

    mov cx,24h
    xor si, si 
 
    jmp findyearstart
    
  
findyearstart:  
    push ax 
    push cx
    
    mov al, yeara
    cbw
    mov cl, 4
    div cl
    mov yearcode, al
    
       
    pop cx
    pop ax 

c1:
    cmp yearp, 14h
    je year20
    jne c2
    year20: mov centcode, 6h
    jmp softbegin
c2:
    cmp yearp, 13h
    je year19
    jne c3
    year19: mov centcode, 0
    jmp softbegin
c3:
    cmp yearp, 12h 
    je year18
    jne softbegin
    year18:mov centcode, 2h
 
softbegin: 
    push bx
    
    mov bl, 0
    add bl, yeara     ;23
    add bl, yearcode  ;5
    add bl, centcode  ;6
    add bl, 1h        ;firstjanuary
    mov yearcode, bl
    
    pop bx
    
    push ax 
    push cx
    
    mov al, yearcode
    cbw
    mov cl, 7
    div cl
    mov yearcode, ah   
    
    call check_leapy
    
    
    pop cx
    pop ax 
    
    mov day1, 0 
    jmp yearstart
proc check_leapy
    mov al, yeara
    cbw
    mov cl, 4
    div cl
    cmp ah, 0
    je leapy
    ret
    leapy:
    sub yearcode, 1
    ret
    
       endp
    
yearstart:

comp1:
    cmp yearcode, 00h
    jne comp2
    mov day1, 0  
    jmp jan1start 
    
comp2:
    cmp yearcode, 01h
    jne comp3
    mov day1, 5h 
    jmp jan1start 
    
comp3:
    cmp yearcode, 02h
    jne comp4      
    mov day1, 0ah
    jmp jan1start
    
comp4:   
    cmp yearcode, 03h
    jne comp5
    mov day1, 0fh
    jmp jan1start         
    
comp5:                    
    cmp yearcode, 04h 
    jne comp6     
    mov day1, 14h
    jmp jan1start
    
comp6:  
    cmp yearcode, 05h 
    jne comp7
    mov day1, 19h
    jmp jan1start
    
comp7:   
    cmp yearcode, 06h
    jne comp8       
    mov day1, 1eh
    jmp jan1start
    
comp8:   
    cmp yearcode,0FFh 
    mov day1, 1eh
    jmp jan1start

jan1start:
    mov dl, day1       
    mov ah, 02h
    int 10h
    
    mov cx, 24h
      
    push cx
    push si  
    
    jmp monthindent

                     
;function to print the indentation of the month
;after this is the one to print the month itself
monthindent:              
    pop si
    pop cx
    push dx 
    
condit4:
    cmp si,9h
    je scrollup
    jne condit7


condit7: 
    cmp si,12h
    je scrollup
    jne condit10


condit10:
    cmp si,1bh
    je scrollup
    jne normal
    
scrollup:
mov dh, 3
push dx
push cx
push ax 
push si
;mov     ah, 06h ; scroll up function id.
;mov     al, 19h   ; lines to scroll.
;mov     bh, 07  ; attribute for new lines.
;mov     cl, 0   ; upper col.
;mov     ch, 1   ; upper row.
;mov     dl, 20h   ; lower col.
;mov     dh, 17h  ; lower row.
;int     10h 
               
    


mov al, 03h
    mov ah, 0
    int 10h
xor si, si 
mov cl, l1
mov ch, 0  
 mov dh, 0
    mov dl, 10
    mov bh, 0
    mov ah, 2
    int 10h 
head2:
    mov al, p11[si]
    mov ah, 0eh
    int 10h
    inc si
    loop head2 
             lea dx, headline
    mov ah, 9h
    int 21h 
    
    
pop si
pop ax
pop cx
pop dx 
mov dh, 1
mov dl, 14
mov ah, 2
int 10h
 
jmp printmonth

normal:
    inc dh
    mov dl, 14
    mov ah, 2
    int 10h
    jmp printmonth  
    
                                   
;function to print the month strings    
printmonth: 
    mov al, months[si] 
    cmp al, "Z"
    je exit
    cmp si, 3
      
    
    mov ah, 0eh
    int 10h   
    
    inc si
    
    mov ax, si    ;divide SI by 3, if modulus is 3 then
                  ; its end of month name
    push cx
    mov cl, 3 
    div cl
    pop cx 
    
    cmp ah, 0
    jz newmonth 
    
    loop  printmonth 


newmonth:     ;set cursor positions for the strings sunday to monday
    push cx    ;push the value of month si to stack
    push si    ;push value of month counter to stack
    
    mov si,0     ;reset to make day of week si
    mov cx ,15h  ;reset to make day of week counter
    
    inc dh       ;increase column 
    mov dl, 0    ;reset position of cursor
    mov ah, 2
    int 10h
    
    jmp newdays
    
newdays:           ;print sunday to monday
    mov al, days[si]
    cmp al, "Z"
    je monthindent   
    
    mov ah, 0eh
    int 10h
    
    inc si
    push cx
    
    mov ax, si
    mov cl, 3 
    div cl
    cmp ah, 0
    
    pop cx
    jz dayindent 
    
    loop newdays
    
dayindent:
    add dl, 5
    mov ah, 2
    int 10h
    
    loop newdays
  
    jmp monthselect  
    
monthselect:
    pop si
    pop cx
    pop dx
    
    push cx
    push si
    sub si, 3h 

cond1:
    cmp si, 0h
    je month31
    jne cond2

cond2:
    cmp si,3h
    je  feb
    jne cond3

cond3:
    cmp si,6h
    je month31
    jne cond4

cond4:
    cmp si,9h
    je month30
    jne cond5

cond5:
    cmp si,0CH
    je month31
    jne cond6

cond6:
    cmp si,0FH
    je month30
    jne cond7

cond7: 
    cmp si,12h
    je month31
    jne cond8

cond8:
    cmp si,15h
    je month31
    jne cond9

cond9:
    cmp si,18h
    je month30
    jne cond10

cond10:
    cmp si,1bh
    je month31
    jne cond11

cond11:
    cmp si,1eh
    je month30
    jne cond12

cond12:
    cmp si,21h
    je month31
    jne exit
    
    
feb:
    pop si
    push si    
    add dh, 3 
    mov ah, 02
    int 10h
    
    call check_leap
    
    jmp new

month31:   
    pop si
    push si
        
    add dh, 3 
    mov ah, 02
    int 10h
    
    mov cx, 1Fh
    
    jmp new

month30:   
 pop si
    push si
    add dh, 3
    mov ah, 02
    int 10h
    
    mov cx, 1Eh
    
    jmp new 

proc check_leap
    mov al, yeara
    mov cl, 4
    div cl
    cmp ah, 0
    
    je leap
    jne not_leap
    
    leap:
    mov cx, 1dh
    ret
    
    not_leap:
    mov cx, 1ch 
    ret   
    
new:    
    sub si, 3
    monthc4:
    cmp si,9h
    jne monthc7
    mov dh, 3
     mov ah, 02
    int 10h
    
monthc7: 
    cmp si,12h
    jne monthc10
    mov dh, 3
     mov ah, 02
    int 10h
    


monthc10:
    cmp si,1bh
    jne zerosi
    mov dh, 3
     mov ah, 02
    int 10h
     
zerosi:
xor si, si
    
    
    normalday:
    
    mov al, daynum[si]
    mov ah, 0eh
    int 10h 
    
    mov al, daynum[si+1]
    mov ah, 0eh
    int 10h
    
    add si,2 
    
    add dl, 5   
    cmp dl, 23h
    je setcursor
    
    mov ah, 02
    int 10h
    
    loop normalday
    jmp monthindent
  
setcursor:
    
    inc dh 
    mov dl, 0
    mov ah, 02
    int 10h 

    cmp cx, 1
    je loopdone
    loop normalday 
    
    loopdone:
    jmp monthindent


exit:
    mov ax, 4c00h ; exit to operating system.
    int 21h 

end