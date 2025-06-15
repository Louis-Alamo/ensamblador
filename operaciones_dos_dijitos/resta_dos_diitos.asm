.model                                                                                
.stack


.data
    msj_mensaje_bienvenda db "Bienvenido a la resta de dos dijitos$"
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

proc resultado_negativo_pcm
    ;Si el resultado es negativo
    mostrar_mensaje_mac msj_resultado
    mov ah, 02h
    mov dl, '-'
    int 21h
    ret
resultado_negativo_pcm endp
;Procedimientos para realizar la resta de dos dijitos
proc resta_pcm
    ;FLujo del programa resta
    ;Verifcamos si la resta es posible verificando si BH es mayor a CH
    cmp ch, bh
    jb intercambiar_valores_registros_resta_etiq
    jmp continuar_resta_etiq

    
    intercambiar_valores_registros_resta_etiq: ;Si no es posible, intercambiamos los valores de los registros
      call intercambiar_valores_registros_pcm
      jmp continuar_resta_etiq
    
    continuar_resta_etiq:
      ;Realizamos la resta
      cmp cl, bl  ; Comparamos para ver si cl necestita un prestamo
      jb pedir_prestamo_resta_etiq ; Si CL es menor que BL, pedimos un prestamo caso contrario ya se ajusto o no necesita
      sub cl, bl ; Si no, realizamos la resta normal

      ;Como intercambiamos los valores en caso de ser necesario, ya no ocupamos ajustar los valores de CH y BH o pedir prestamo
      sub ch, bh ; Restamos las decenas
      jmp mostrar_resultados_resta_etiq ; Vamos a mostrar los resultados


    pedir_prestamo_resta_etiq:
      add cl, 10h ; Si es necesario, le damos un prestamo a CL
      dec ch ; Y le quitamos uno a CH
      jmp continuar_resta_etiq

    
    mostrar_resultados_resta_etiq:
      cmp dh, 1 ;Usamos dh como bandera para saber si hubo un intercambio de valores
      je resultado_negativo_resta_etiq ; Si DH es 1, significa que hubo un intercambio de valores, por lo tanto el resultado es negativo
      jmp resultado_positivo_resta_etiq


    resultado_negativo_resta_etiq:
      call resultado_negativo_pcm ; Llamamos al procedimiento para mostrar el mensaje de error
      mostrar_numero_mac ch
      mostrar_numero_mac cl ; Mostramos el resultado de la resta 
      jmp terminar_resta_etiq ; Terminamos el procedimiento   

    resultado_positivo_resta_etiq:
      ;Si el resultado es positivo, mostramos el resultado
      mostrar_mensaje_mac msj_resultado
      mostrar_numero_mac ch ; Mostramos las decenas
      mostrar_numero_mac cl ; Mostramos las unidades
      jmp terminar_resta_etiq ; Terminamos el procedimiento
      
      terminar_resta_etiq:
      ret
resta_pcm endp  

main:
    mov ax, @data
    mov ds, ax
    
    mostrar_mensaje_mac msj_mensaje_bienvenda
    call salto_linea_pcm ; Llamamos al procedimiento para un salto de linea
    call pedir_numeros_pcm ; Llamamos al procedimiento para pedir los numeros
    call resta_pcm ; Llamamos al procedimiento para realizar la resta
    call terminar_programa_pcm ; Llamamos al procedimiento para terminar el programa
end main
