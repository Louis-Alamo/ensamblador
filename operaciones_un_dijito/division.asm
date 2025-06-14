.model
.stack


.data
	msj_bienvenida db "Bienvenido a la division $"
	msj_pedir_numero db "Dame un numero: $"
	msj_mostrar_resultado db "El resultado de la division es: $"

macro salto_linea
	mov ah, 02h
	mov dl, 0Dh
	int 21h 

	mov ah, 02h
	mov dl, 0Ah
	int 21h
endm

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



.code
main:
	
	mov ax, @data
	mov ds, ax

	;Mostramos mensaje de bienvenida 
	mostrar_mensaje msj_bienvenida
	salto_linea

	;Pedimos numero 1
	pedir_numero 
	sub al, 30h
	mov bl, al
	salto_linea
 

	;Pedimos numero 2
	pedir_numero
	sub al, 30h
	mov bh, al
	salto_linea


	;Preparamos todo para la division
	mov al, bl ;<- Movemos a al el dividendo
	XOR ah, ah ;<-Si al tendra el dividendo el la otra parte del registro se debe limpiar

	div bh ;Le pasamos el divisor y con la palabra div buscara en AX (todo el registro) hara la operacion de division
	;y el resultado lo mete en al (cociente) y en ah (residuo)
	mov bl, al

	mostrar_mensaje msj_mostrar_resultado
	add bl, 30h
	mov ah, 02h
	mov dl, bl
	int 21h
	jmp salir

salir: 
	mov ah, 4ch
	int 21h

end main