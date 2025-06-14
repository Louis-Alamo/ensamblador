.model small
.stack 100h

.data
    mensaje db 'Ingrese un numero: $'
    numero1 db 0       
    numero2 db 0
    numero3 db 0
    numero4 db 0

.code

mostrar_mensaje proc
    lea dx, mensaje
    mov ah, 09h
    int 21h
    ret
mostrar_mensaje endp

pedir_numero proc
    mov ah, 01h
    int 21h
    sub al, 30h
    mov [bx], al    ; Ahora [bx], no [dx]
    ret
pedir_numero endp

principal:
    mov ax, @data
    mov ds, ax

    ; numero1
    call mostrar_mensaje
    mov bx, offset numero1
    call pedir_numero
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; numero2
    call mostrar_mensaje
    mov bx, offset numero2
    call pedir_numero
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
; Resta lógica con acarreo usando AAD
restar_digitos proc
    ; Suponiendo numero1 y numero2 son decenas y unidades del primer número
    ; numero3 y numero4 son decenas y unidades del segundo número

    mov al, [numero1]    ; decena minuendo
    mov ah, [numero2]    ; unidad minuendo
    aam                  ; AL = unidades, AH = decenas
    mov bl, al           ; guardar unidades
    mov bh, ah           ; guardar decenas

    mov al, [numero3]    ; decena sustraendo
    mov ah, [numero4]    ; unidad sustraendo
    aam                  ; AL = unidades, AH = decenas

    ; Convertir ambos a binario (AAD)
    mov al, [numero1]
    mov ah, [numero2]
    aad
    mov cx, ax           ; CX = minuendo

    mov al, [numero3]
    mov ah, [numero4]
    aad
    mov dx, ax           ; DX = sustraendo

    ; Realizar la resta
    mov ax, cx
    sub ax, dx

    ; Convertir resultado a BCD para mostrar
    aam
    mov [numero1], ah    ; decenas resultado
    mov [numero2], al    ; unidades resultado

    ret
restar_digitos endp

    ; numero3
    call mostrar_mensaje
    mov bx, offset numero3
    call pedir_numero
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; numero4
    call mostrar_mensaje
    mov bx, offset numero4
    call pedir_numero
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

salir:
	mov ah,4ch
	int 21h

end principal
