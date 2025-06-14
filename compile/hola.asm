org 100h                  ; Dirección de inicio para archivos .COM

section .text
start:
    mov dx, mensaje       ; Cargar la dirección del mensaje
    mov ah, 09h           ; Función DOS para imprimir cadena
    int 21h               ; Interrupción para llamar a DOS

    mov ah, 4Ch           ; Terminar el programa
    int 21h

section .data
mensaje db "Hola desde NASM!", 0Dh, 0Ah, "$"
