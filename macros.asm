.model
.stack


;Con macros podemos reutilizar codigo sin tener que repetirlo en las etiquetas
;ahora bien podemos pasarle una o varioos parametros separados por coma (param1, param2)
macro mostrar_mensaje msj
	mov ah, 09h  			;<- La instruccion 09h sirve para mostrar en pantalla
	mov dx, offset msj  	;<- la variable se la pasamos a DX el segmento para datos extendidos
	int 21h					;<-Ejecutamos la instruccion que se encuentra en ah
endm


.data
	msj1 db "Este es un mensaje usando un macro$"
	msj2 db "Con los macros se puede reutilizar codigo sin problemas$"


.code

main:
	mov ax, @data
	mov ds, ax

	mostrar_mensaje msj1 ;Llamamos al macro
	mostrar_mensaje msj2


	jmp salir ;<- jmp salto incondicional (salta si o si)


salir:
	mov ah, 4ch
	int 21h


end main 




