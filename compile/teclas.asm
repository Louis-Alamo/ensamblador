section .data
    mensaje db "Tecla presionada: $"

section .text
    global _start

_start:
    ; Inicializar segmento de datos
    mov ax, 0x07C0       ; Segmento de datos en DOS
    mov ds, ax

ciclo:
    ; Captura una tecla presionada
    mov ah, 00h          ; Función 00h de la interrupción 16h
    int 16h

    ; Verificar si el valor en AL es una tecla imprimible (ASCII entre 20h y 7Eh)
    cmp al, 20h          ; Compara si la tecla es >= 20h (espacio)
    jl no_imprimible     ; Si es menor, no es imprimible

    cmp al, 7Eh          ; Compara si la tecla es <= 7Eh (tilde ~)
    jg no_imprimible     ; Si es mayor, no es imprimible

    ; Mostrar el mensaje "Tecla presionada: "
    mov ah, 09h
    lea dx, mensaje
    int 21h

    ; Mostrar la tecla presionada
    mov dl, al           ; El valor de la tecla presionada está en AL
    mov ah, 02h          ; Función 02h de la interrupción 21h (mostrar un carácter)
    int 21h

no_imprimible:
    ; Si la tecla no es imprimible, no hacer nada
    ; Repetir el ciclo
    jmp ciclo

_exit:
    ; Finaliza el programa
    mov ah, 4Ch
    int 21h
