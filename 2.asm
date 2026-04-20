org 100h
jmp start

a db 12
b db -3 
c db 4 
d db 3 
res dw ? 
x db ?
y dw ?           

start:
    mov cx, 8; цикл 8
    mov bl, -3

metka:
    mov x, bl;x=BL
    
    push cx; cчетчик в стек
    push bx; 
    
    cmp bl, 0;сравнение bl с 0 
    jl  CalcY1; bl<0
    je  CalcY2; bl=0a
    jg  CalcY3; bl>0

CalcY1:
    ; y1 = (a^2 + x) / c
    mov al, a;a->al
    mul al; ax=al^2           
    mov bx, ax;bx=ax
    
    mov al, x
    cbw; ax=al
    add ax, bx; ax= a^2+x
    
    mov bl, c
    div bl; al=(a^2+x)/c              
    cbw; ax=al                 
    mov y, ax           
    jmp PrintResult

CalcY2:
    ; y2 = (a + b) / d
    mov al, a
    add al, b;al=a+b
    cbw
    mov bl, d
    div bl; al=ax/d
    cbw
    mov y, ax
    jmp PrintResult

CalcY3:
    ; y3 = 3 * a * x
    mov al, a
    mov bl, x
    mul bl; ax = a * x              
    mov bl, 3
    mul bl; ax = ax * 3
    mov y, ax  
    jmp PrintResult

PrintResult:
    ; Print "x="
    mov ah, 02h; Dos: вывод символа
    mov dl, 'x'
    int 21h; вывод x
    mov dl, '='
    int 21h; вывод =
    
    ; Print x
    mov al, x
    cbw; ax = x
    call print_ax
    ; пробел между x и y
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    ; Print "y="
    mov dl, 'y'
    int 21h
    mov dl, '='
    int 21h
    
    ; Print y 
    mov ax, y
    call print_ax
    
    ; New line
    mov ah, 02h
    mov dl, 13; символ возврата коретки
    int 21h
    mov dl, 10; new line символ
    int 21h
    
    pop bx; востановить x, cx-счётчик цикла
    pop cx
    
    inc bl; x=x+1
    loop metka
    
    mov ax, 4c00h; конец программы
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