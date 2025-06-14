.model
.stack


.data
	msj_bienvenida db "Bienvenido a la multiplicacion$"
	msj_pedir_numero db "Dame un numero: $"
	msj_mostrar_resultado db "El resultado de la multiplicacion es: $"

macro mostrar_mensaje msj 
	mov ah, 09h
	mov dx, offset msj
	int 21h
endm

macro pedir_numero
	
	mostrar_mensaje msj_pedir_numero
	mov ah, 01h
	int 21h
endm 



macro salto_linea 
	mov ah, 02h
	mov dl, 0Dh
	int 21h

	mov ah, 02h
	mov dl, 0Ah
	int 21h
endm



.code
main:
	
	mov ax, @data
	mov ds, ax

	;Mostramos el mensaje de bienvenida 
	mostrar_mensaje msj_bienvenida
	salto_linea


	;pedimos el numero 1
	pedir_numero
	sub al, 30h
	mov bl, al
	salto_linea

	;pedimos el numero 2
	pedir_numero
	sub al, 30h
	mov bh, al
	salto_linea


	XOR al,al 

	mov al, bl

	mul bh

	add al, 30h
	mov bh, al
	mostrar_mensaje msj_mostrar_resultado
	mov ah, 02h
	mov dl, bh
	int 21h

	jmp salir


salir: 
	mov ah, 4ch
	int 21h

end main





