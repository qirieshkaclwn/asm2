org 100h
jmp start

a db 12
b db -3 
c db 4 
d db 3 
res dw ? 
x db ?
y dw ?              ; Changed from db to dw (word)

start:
    mov cx, 8
    mov bl, -3

metka:
    mov x, bl
    
    push cx
    push bx
    
    cmp bl, 0
    jl  CalcY1
    je  CalcY2
    jg  CalcY3

CalcY1:
    ; y1 = (a² + x) / c
    mov al, a
    mul al              ; AX = a²
    mov bx, ax
    
    mov al, x
    cbw
    add ax, bx
    
    mov bl, c
    div bl              ; AL = quotient
    cbw                 ; AX = AL 
    mov y, ax           ; Store word
    jmp PrintResult

CalcY2:
    ; y2 = (a + b) / d
    mov al, a
    add al, b
    cbw
    mov bl, d
    div bl
    cbw
    mov y, ax
    jmp PrintResult

CalcY3:
    ; y3 = 3 * a * x
    mov al, a
    mov bl, x
    mul bl              ; AX = a * x
    mov bl, 3
    mul bl              ; AX = 3 * a * x
    mov y, ax           ; Store word (can hold up to 32767)
    jmp PrintResult

PrintResult:
    ; Print "x="
    mov ah, 02h
    mov dl, 'x'
    int 21h
    mov dl, '='
    int 21h
    
    ; Print x
    mov al, x
    cbw
    call print_ax
    
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    ; Print "y="
    mov dl, 'y'
    int 21h
    mov dl, '='
    int 21h
    
    ; Print y directly from memory (word)
    mov ax, y           ; Load word
    call print_ax
    
    ; New line
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    pop bx
    pop cx
    
    inc bl
    loop metka
    
    mov ax, 4c00h
    int 21h

print_ax:
   push bx
   push cx
   push dx
   
   test ax, ax
   jns oi1
   mov cx, ax
   mov ah, 02h  
   mov dl, '-'
   int 21h
   mov ax, cx
   neg ax
oi1:  
    xor cx, cx
    mov bx, 10
oi2:
    xor dx,dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz oi2
    mov ah, 02h
oi3:
    pop dx
    add dl, '0'
    int 21h
    loop oi3
    
    pop dx
    pop cx
    pop bx
    ret