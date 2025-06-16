.model                                                                                
.stack


.data
    msj_mensaje_bienvenda db "Bienvenido a la suma de dos dijitos$"
    msj_pedir_numero db "Dame un numero: $"
    msj_resultado db "El resultado de la suma es: $"


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

proc resultado_negativo_pcm
    ;Si el resultado es negativo
    mostrar_mensaje_mac msj_resultado
    mov ah, 02h
    mov dl, '-'
    int 21h
    ret
resultado_negativo_pcm endp


proc suma_pcm

    ;Sumamos primiero las unidades
    add cl, bl
    
    ;Verificamos que el resultado no pase de 10, de ser asi ocupamos un ajuste
    cmp cl, 10
    jb continuar_suma_etiq ;Si no necesitamos ajuste, continuamos la suma como es
    ;Realizamos el ajuste
    sub cl, 10
    inc ch
    jmp continuar_suma_etiq
    
    continuar_suma_etiq:
      ;Ahora sumamos las decenas
      add ch, bh
      ;Comprobamos que no supere los 10, de ser asi entonces tenemos centenas
      cmp ch, 10
      jb mostrar_resultado_suma_etiq

      ;Realizamos el ajuste de las centenas
      sub ch, 10
      mov bh, 1
      jmp mostrar_resultado_centena_suma_etiq
      
      mostrar_resultado_suma_etiq:
        mostrar_mensaje_mac msj_resultado
        mostrar_numero_mac ch
        mostrar_numero_mac cl
        jmp terminar_suma_etiq
      mostrar_resultado_centena_suma_etiq:
        mostrar_mensaje_mac msj_resultado
        mostrar_numero_mac bh
        mostrar_numero_mac ch
        mostrar_numero_mac cl
        jmp terminar_suma_etiq
    terminar_suma_etiq:
      ret
suma_pcm endp


main:
    mov ax, @data
    mov ds, ax
    
    mostrar_mensaje_mac msj_mensaje_bienvenda
    call salto_linea_pcm ; Llamamos al procedimiento para un salto de linea
    call pedir_numeros_pcm ; Llamamos al procedimiento para pedir los numeros
    call suma_pcm ; Llamamos al procedimiento para realizar la resta
    call terminar_programa_pcm ; Llamamos al procedimiento para terminar el programa


end main
