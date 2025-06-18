.model                                                                                
.stack

.data
    msj_pedir_numero db "Dame un numero: $"
    msj_resultado db "El resultado de la suma es: $"
    msj_error_division db "No se puede dividir entre 0$"
    msj_residuo db "Hay residuo señores: $"
    msj_titulo db "===== CALCULADORA DE DOS DIGITOS =====", 13, 10, "$"
    msj_opciones db 13, 10, "Operaciones disponibles:", 13, 10
           db " 1. Suma", 13, 10
           db " 2. Resta", 13, 10  
           db " 3. Multiplicacion", 13, 10
           db " 4. Division", 13, 10
           db "Elija una opcion (1-4): $"
    msj_opcion_invalida db 13, 10, "Opcion invalida! Por favor elija 1-4.$"
    msj_opcion db "Opcion: $"

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


mostrar_menu_opciones_pcm proc

  mostrar_mensaje_mac msj_titulo
  mostrar_mensaje_mac msj_opciones

endp mostrar_menu_opciones_pcm 


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

;<-----OPERACIONES DE SUMA, RESTA, MULTIPLICACION Y DIVISION----->

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

proc multiplicacion_pcm
    ;<-Multiplicacion de dos digitos por uno solo ->
    ; CH = decenas, CL = unidades, BL = Multiplicador

    XOR al, al
    XOR ah, ah
    
    ;Multiplicamos las unidades 
    mov al, cl
    mul bl
    AAM
    mov cl, al      ; Unidades del resultado final
    mov dl, ah      ; Carry para las decenas
    
    XOR al, al
    XOR ah, ah
    
    ;Multiplicamos las decenas
    mov al, ch
    mul bl
    add al, dl      ; Sumamos el carry
    AAM 
    mov ch, al      ; Decenas del resultado final
    mov bh, ah      ; Centenas del resultado final
    mostrar_mensaje_mac msj_resultado
    mostrar_numero_mac bh    ; Centenas (más significativo)
    mostrar_numero_mac ch    ; Decenas
    mostrar_numero_mac cl    ; Unidades (menos significativo)
    jmp terminar_programa_multiplicacion_pcm

    terminar_programa_multiplicacion_pcm:
        ret
endp multiplicacion_pcm

proc division_pcm
    ;<-Division de dos digitos por uno solo ->

    ; CH = decenas del dividendo, CL = unidades del dividendo, BL = divisor
    
    ; Verificar si el divisor es 0
    cmp bl, 0
    je division_por_cero_etiq ; SI es asi entonces error mi estimado
    
    ; Convertir el número de 2 dígitos a un solo valor
    XOR al, al
    XOR ah, ah
    mov al, ch      ; Cargar las decenas
    mov bh, 10      ; Multiplicador para convertir a decenas
    mul bh          ; Ahora tenemos las decenas en al
    add al, cl      ; Le sumamos a cl para tener el nmumero completo si que este separado y que quede en un solo registro
    
    ; Realizar la división
    XOR ah, ah      ; Limpiar AH para la división porque se utiliza tanto AH como AL y puede darnos errores curoso
    div bl          ; AL = cociente, AH = residuo (Segun diosito)
    
    ; Guardar resultados temporalmente
    mov ch, al      
    mov cl, ah      
    
    ; Convertir a numeros por separado si es mayor a 10 caso contrario no necesita ajuste 
    cmp ch, 9
    jbe mostrar_cociente_un_digito_etiq
    
    ; Si el cociente es mayor a 9, separar en decenas y unidades
    mov al, ch
    XOR ah, ah
    mov bl, 10
    div bl          ; Utilizamos una division por 10 para sacarle las decenas, el residio seran las unidades
    mov bh, al      
    mov ch, ah      
    jmp mostrar_resultado_dos_digitos_division_etiq
    ;Saquenme de la carrera
    
    mostrar_cociente_un_digito_etiq:
        mostrar_mensaje_mac msj_resultado
        mostrar_numero_mac ch   
        ; Verificar si hay residuo
        cmp cl, 0
        je terminar_division_etiq ;Si no hay residuo se termina el codigo marrano
        ; Mostrar residuo si existe
        call salto_linea_pcm
        mostrar_mensaje_mac msj_residuo  ; Necesitarías definir este mensaje
        mostrar_numero_mac cl   
        jmp terminar_division_etiq
    
    mostrar_resultado_dos_digitos_division_etiq:
        mostrar_mensaje_mac msj_resultado
        mostrar_numero_mac bh   
        mostrar_numero_mac ch   
        ; Verificar si hay residuo
        cmp cl, 0
        je terminar_division_etiq
        ; Mostrar residuo si existe
        call salto_linea_pcm
        mostrar_mensaje_mac msj_residuo 
        mostrar_numero_mac cl   
        jmp terminar_division_etiq
    
    division_por_cero_etiq:
        mostrar_mensaje_mac msj_error_division  
        jmp terminar_division_etiq
    
    terminar_division_etiq:
        ret
endp division_pcm





main:
    mov ax, @data
    mov ds, ax
    
    call mostrar_menu_opciones_pcm
    call salto_linea_pcm
    
    mov ah, 09h
    mov dx, offset msj_opcion
    int 21h
    mov ah, 01h
    int 21h
    sub al, 30h
    mov bl, al ; Guardamos la opción elegida en Bl porque si lo guardamos en AL se pierde al llamar el salto de linea

    call salto_linea_pcm ; Llamamos al procedimiento para un salto de linea
    mov al, bl ; Recuperamos la opción elegida en AL para procesarla (Da hueva cambiar las comparaciones a pero para comentarios)
    
    cmp al, 1
    je suma_opcion_etiq
    
    cmp al, 2
    je resta_opcion_etiq
    
    cmp al, 3
    je multiplicacion_opcion_etiq
    
    cmp al, 4
    je division_opcion_etiq

    ; Si no es ninguna opción válida
    mostrar_mensaje_mac msj_opcion_invalida
    jmp salir_etiq

suma_opcion_etiq:
    call pedir_numeros_pcm 
    call suma_pcm
    jmp salir_etiq          

resta_opcion_etiq:
    call pedir_numeros_pcm  
    call resta_pcm
    jmp salir_etiq        

multiplicacion_opcion_etiq:
    call pedir_numeros_pcm 
    call multiplicacion_pcm
    jmp salir_etiq        

division_opcion_etiq:
    call pedir_numeros_pcm 
    call division_pcm
    jmp salir_etiq          

salir_etiq:
  mov ah, 4ch
  int 21h

end main
