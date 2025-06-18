.model                                                                                
.stack


.data
    msj_mensaje_bienvenda db "Bienvenido a la multiplicacion$"
    msj_pedir_numero db "Dame un numero: $"
    msj_resultado db "El resultado de la resta es: $"


;Definicion de los macros

macro mostrar_mensaje_mac msj
    mov ah, 09h
    mov dx, offset msj
    int 21h
endm

macro pedir_numero_mac
   mostrar_mensaje_mac msj_pedir_numero
   mov ah, 01h
   int 21h
   mov bh, al

   mov ah, 01h
   int 21h

   mov bl, al

   sub bl, 30h
   sub bh, 30h
endm
macro mostrar_numero_mac reg
    add reg, 30h
    mov ah, 02h
    mov dl, reg
    int 21h
endm


; Definicion de los procedimientos
.code

intercambiar_valores_registros_pcm proc
    ; Intercambio de decenas: CH <--> BH
    mov al, ch    ; Guardamos CH
    mov ch, bh    ; CH toma el valor de BH
    mov bh, al    ; BH toma el valor original de CH

    ; Intercambio de unidades: CL <--> BL
    mov al, cl    ; Guardamos CL
    mov cl, bl    ; CL toma el valor de BL
    mov bl, al    ; BL toma el valor original de CL

    XOR dh, dh ; Limpiamos DH para evitar problemas 
    mov dh, 1 ; Indicamos que se ha realizado un intercambio lo usaremos como bandera para saber que mensaje mostrar
    ret
intercambiar_valores_registros_pcm endp

proc salto_linea_pcm
    mov ah, 02h
    mov dl, 0Dh
    int 21h

    mov ah, 02h
    mov dl, 0Ah
    int 21h
    ret
salto_linea_pcm endp

proc pedir_numeros_pcm
  ;Pedimos el numero 1
    pedir_numero_mac ; EL macro en automatico se queda con B
    mov ch, bh ; Guardamos el primer numero en CH
    mov cl, bl  ; Guardamos el segundo numero en CL
    
    call salto_linea_pcm ;llamamos al proc para un salto de linea para que los mensajes no se superpongan

  ;Pedimos el numero 2
  pedir_numero_mac
  call salto_linea_pcm ; Llamamos al procedimiento para un salto de linea
  ;Dejamos el numero 2 en el registro de B
  ret
pedir_numeros_pcm endp

proc terminar_programa_pcm
    mov ah, 4ch
    int 21h
terminar_programa_pcm endp


main:
  mostrar_mensaje_mac msj_mensaje_bienvenda
  


end main
