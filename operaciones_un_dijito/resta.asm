.model
.stack


.data
	msj_bienvenida db "Bienvenido a la resta de un dijito$"
	msj_pedir_numero db "Dame un numero: $"
	msj_mostrar_resultado db "El resultado de la resta es: $"


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
	mov ah, 09h
	mov dx, offset msj_pedir_numero
	int 21h

	mov ah, 01h
	int 21h
endm

macro mostrar_numero 
	mov ah, 02h
	int 21h




.code
main: 

	mov ax, @data
	mov ds, ax

	;Mostramos mensjae de bienvenida 
	mostrar_mensaje msj_bienvenida
	salto_linea

	;Pedimos numero 1
	pedir_numero 
	sub al, 30h ;Realizamos ajuste (es ah porque ai se guarda el nuermo con instruccion 01h)
	mov bl, al  ;Respaldamos el numero a un registro auxiliar
	salto_linea

	;pedimos numero 2
	pedir_numero
	sub al, 30h
	mov bh, al 


	;realizamos la resta 

	sub bl, bh

	salto_linea

	;mostramos resultado
	mostrar_mensaje msj_mostrar_resultado
	add bl, 30h    ;ajuste para mostrar 
	mov dl, bl
	mostrar_numero

	jmp salir  ;No es necesario si mas abajo no hay mas codigo



salir:
	mov ah, 4ch
	int 21h

end main