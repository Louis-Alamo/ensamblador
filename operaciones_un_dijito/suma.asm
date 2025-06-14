.model
.stack

.data
	msj_bienvenida db "Bienvenido a la suma$"
	msj_pedir_numero db "Dame un numero: $"
	msj_resultado db "El resultado de la suma es: $"
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

	mov ah, 01h
	int 21h

endm


macro mostrar_numero
	mov ah, 02h
	int 21h
endm


.code 
main: 

	mov ax, @data
	mov ds, ax


	mostrar_mensaje msj_bienvenida
	salto_linea

	;<-Empezamos pidiendo los numeros

	mostrar_mensaje msj_pedir_numero
	pedir_numero

	mov bl, al ;<-GUardamos el numeor de la llamada del macro anterios para reservarlo
	sub bl, 30h ;Ajustamos con el valor de ASCII
	salto_linea


	;Pedir numero 2
	mostrar_mensaje msj_pedir_numero
	pedir_numero
	sub al, 30h
	mov bh, al ; <-Se mueve a bh para no perder el valor de al (posiblemente al se remplaze mas adelante por eso mismo)
	salto_linea

	add bl, bh

	mostrar_mensaje msj_resultado
	add bl, 30h
	mov dl, bl
	mostrar_numero 

	jmp salir

salir: 
	mov ah, 4ch
	int 21h

end main


