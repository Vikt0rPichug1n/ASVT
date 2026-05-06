.686
.model flat, stdcall
.stack 4096

.data
    X dw 23
    Y dw 6
    Z dw 16
    M dw ?

.code
ExitProcess PROTO STDCALL :DWORD

main PROC
    ; Загружаем значения
    mov ax, X        ; AX = X
    mov bx, Y        ; BX = Y
    mov cx, Z        ; CX = Z
    
    ; X' = X << 3
    shl ax, 3        ; AX = X' = 184
    
    ; Y' = Y << 3
    shl bx, 3        ; BX = Y' = 48
    
    ; Вычисляем Z * X'
    push ax          ; сохраняем X' в стеке
    mov ax, cx       ; AX = Z = 16
    pop cx           ; CX = X'
    mul cx           ; DX:AX = Z * X' = 16 * 184 = 2944
    
    ; Вычитаем Y (оригинальное Y)
    sub ax, Y        ; AX = Z*X' - Y = 2938
    
    ; Сохраняем результат первой части
    push ax
    
    ; Вычисляем X and Y'
    mov ax, X        ; AX = X = 23
    and ax, bx       ; AX = X and Y' = 0
    
    ; OR двух частей
    pop bx           ; BX = первая часть (2938)
    or bx, ax        ; BX = (Z*X'-Y) or (X and Y') = 2938
    
    ; Сохраняем результат
    mov M, bx
    
    invoke ExitProcess, 0
main ENDP
END main