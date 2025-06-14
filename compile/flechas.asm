section .data
    mensaje1 db "Flecha arriba", 0ah, 0dh, "$"
    mensaje2 db "Flecha abajo", 0ah, 0dh, "$"
    mensaje3 db "Flecha derecha", 0ah, 0dh, "$"
    mensaje4 db "Flecha izquierda", 0ah, 0dh, "$"

section .text
    global _start

_start:
    ; Ciclo principal
ciclo:
    ; Pide una tecla al usuario
    mov ah, 0
    int 16h
    
    ; Codigos de rastreo de las flechas
    ; Flecha arriba = 48h
    ; Flecha abajo = 50h
    ; Flecha derecha = 4Dh
    ; Flecha izquierda = 4Bh
    ; Enter 13h
    
    ; Si el código es 48h (flecha arriba), imprime "Flecha arriba"
    cmp al, 48h
    je flecha_arriba

    ; Si el código es 50h (flecha abajo), imprime "Flecha abajo"
    cmp al, 50h
    je flecha_abajo

    ; Si el código es 4Dh (flecha derecha), imprime "Flecha derecha"
    cmp al, 4Dh
    je flecha_derecha

    ; Si el código es 4Bh (flecha izquierda), imprime "Flecha izquierda"
    cmp al, 4Bh
    je flecha_izquierda

    ; Si el código es 13h (enter), termina el programa
    cmp al, 13h
    je fin

    ; Volver al ciclo principal
    jmp ciclo

flecha_arriba:
    ; Imprime "Flecha arriba"
    mov dx, mensaje1
    mov ah, 09h
    int 21h
    jmp ciclo

flecha_abajo:
    ; Imprime "Flecha abajo"
    mov dx, mensaje2
    mov ah, 09h
    int 21h
    jmp ciclo

flecha_derecha:
    ; Imprime "Flecha derecha"
    mov dx, mensaje3
    mov ah, 09h
    int 21h
    jmp ciclo

flecha_izquierda:
    ; Imprime "Flecha izquierda"
    mov dx, mensaje4
    mov ah, 09h
    int 21h
    jmp ciclo

fin:
    ; Código de salida de ejecución
    mov ah, 04Ch
    int 21h
