.model
.stack


.data 
	msj1 db "Usando procedimientos$"
	msj2 db "SImplemente una funcion para reutilizar funcionalidades$"
	msj3 db "Similar a los macros solo que a los PROC no se les puede pasar parametros$"


.code

;Los procedimeintos siempre deben ir dentro de .code pero fuera del main o etiqueta principal
salto_de_linea PROC ;<-Declaracion de un procedimeinto
 	mov ah, 02h
 	mov dl, 0Dh
 	int 21h

 	mov ah, 02h
 	mov dl, 0Ah
 	int 21h

 	ret				;<- Siempre debe tener un ret

salto_de_linea endm  ;<-Siempre debe tener un cierre

mostrar_mensaje PROC
	mov ah, 09h
	int 21h

	ret
mostrar_mensaje endm




main:	
	mov ax, @data
	mov ds, ax

	mov dx, offset msj1 ;<- A comparacion de los macros, los procedimeintos tenemos que preparar los registros 
						; o lo que querramos hacer antes de llamarlo
	
	call mostrar_mensaje ;<-Asi se llama un procedimeinto

	call salto_de_linea

	mov dx, offset msj2
	call mostrar_mensaje

	mov dx, offset msj3
	call mostrar_mensaje

	jmp salir

salir:
	mov ah, 4ch
	int 21h

end main