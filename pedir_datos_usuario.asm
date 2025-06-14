;<-Pedir datos al usario

.model
.stack


.data
	msj db "Dame un numero: $"
	msj2 db "Numero: $"


.code

main:

	mov ax, @data
	mov ds, ax

	;<- Haremos lo de siempre, mostraremos el msj en la consola
	mov ah, 09h
	mov dx, offset msj
	int 21h


	;<La instruccion 01h nos ayuda a pedir al usuario un caracter 
	mov ah, 01h
	int 21h

	mov bl, ah  ;<-Movemos el valor ingresado por el usuario a bl como aux (mas adelante usaremos instrucciones y borraremos el valor original)


	; <- Para un salto de linea ocupamos dos carcateres especiales 0Dh y 0Ah
	; para ejecutarlo simplemente se usa la llamada 02h (porque es un solo caracter)
	; y el registro dl (porque 02h solo revisa en dl)
	mov ah, 02h 
	mov dl, 0Dh ;<- 0Dh es como regresar en la linea donde esta pero al inicio
	int 21h

	mov ah, 02h 
	mov dl, 0Ah ;<- 0Ah Funciona bajando de linea, por eso se pide que regrese a el inicio de la linea (0Dh) para simular un salto de linea
	int 21h

	mov ah, 09h
	mov dx, offset msj2
	int 21h


	mov ah, 02h ;<--Se usa la funcion 02h para mostrar un solo caracter a consola
	mov dl, bl  ;<-se usa dl porque el caracter es 8 bits suficeinte para al, ademas 02h solo revisa en dl por lo mismo
	int 21h     ;<-Ejecutamos la instruccion como de costumbre








	jmp salir


salir: 
	mov ah, 4ch
	int 21h

end main