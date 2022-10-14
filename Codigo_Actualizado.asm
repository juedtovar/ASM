; -------------------------------------------------------------------------------
; Grupo X – Nombre descriptivo de lo que resuelve el programa
; Integrantes:
; Pérez, Juan
; Cicerchia, Lucas Benjamin
; Programa:
; Breve descripción de lo que resuelve el programa.
; Si utiliza subrutinas indicar que resuelven cada una
; -------------------------------------------------------------------------------

.model small
.stack
.data

    Msj      db "Ingresar un texto:$"
    Msj_Orig db "El texto original es:$"
    Cadena   db  101, 0, 102 dup('$')
    Msj_Long db "La longitud de la cadena es:"
    Longitud db 0,0,'$'    
    Salto_Ln db 0Ah, 0Dh, "$"
    Msj_Modf db "El texto modificado es:$"
    

.code
 ;INICIO DEL PROGRAMA
    mov ax,@data
    mov ds,ax 
    call Programa   ;Llamamos a la subrutina Programa

Ajuste_Cx:     
    pop cx       ;Extraemos de la pila y lo enviamos a "cx"
    jmp Final_Conv  ;Saltamos a Final_Conv
    
    
Programa proc
  
    push 1h         ;Ingresamos a la pila 1
    
 ;IMPRIMIR MENSAJE "INGRESAR UN TEXTO"
    mov ah,09h      ;Movemos 9 hexadecimal al registro "ah"
    lea dx,Msj
    int 21h
    
 ;INGRESAR TEXTO DESDE TECLADO
    mov ah,0Ah      ;Movemos A hexadecimal al registro "ah"
    lea dx,Cadena
    int 21h
    
 ;CONTAR CARACTERES DE LA CADENA
    mov ax,0        ;Movemos 0 al registro "ax", para limpiarlo
    mov al,Cadena[1];Movemos la longitud de la cadena al registro "al"
    push ax         ;Ingresamos a la pila el valor del registro "ax" (Longitud)
        aam         ;Aplicamos un ajuste ascii
        add al,30h  ;Incrementa en 30 hexadecimal el valor del registro "al"
        mov Longitud[2],al ;UNIDADES
    mov al,ah       ;Movemos el valor del registro "ah" hacia el registro "al"
        aam
        add ax,3030h;Incrementamos 30 hexadecimal tanto en el registro "ah" como en el "al"
        mov Longitud[0],ah  ;CENTENAS
        mov Longitud[1],al  ;UNIDADES
    
 ;DOBLE SALTO LINEA
    mov ah,09h      ;Movemos 9 hexadecimal al registro "ah"
    mov dx, offset Salto_Ln
    int 21h 
    
    mov ah,09h      ;Movemos 9 hexadecimal al registro "ah"
    mov dx, offset Salto_Ln
    int 21h
    
 ;IMPRIMIR LA LONGITUD DE LA CADENA
    mov ah,09h      ;Movemos 9 hexadecimal al registro "ah"
    lea dx,Msj_Long
    int 21h
    
 ;IMPRIMIR CADENA ORIGINAL
    mov ah,09h      ;Movemos 9 hexadecimal al registro "ah"
    lea dx,Msj_Orig
    int 21h
    mov ah,09h      ;Movemos 9 hexadecimal al registro "ah"
    lea dx,Cadena[2]
    int 21h
    
 ;MODIFICAR TEXTO ORGINAL
    mov si,2h       ;Movemos 2 hexadecimal al registro "si"
    pop cx          ;Extraemos de la pila la longitud de la cadena al registro "cx"
    jmp Convertir
    
    Upper:
        sub al,20h          ;Decrementamos 20 hexadecimal al registro "al" (Pasar de minuscula a mayuscula ascii)
        mov Cadena[si],al   ;Movemos el valor del registro "al" hacia la Cadena en la posicion de "si"
        inc si              ;Incrementamos el registro "si"
        dec cx              ;Decrementamos el registro "cx"
        jmp Convertir       ;Saltamos a Convertir
        
    Lower:
        add al,20h          ;Aumentamos 20 hexadecimal al registro "al" (Pasar de mayuscula a minuscula ascii)
        mov Cadena[si],al   ;Movemos el valor del registro "al" hacia la Cadena en la posicion de "si"
        inc si              ;Incrementamos el registro "si"
        dec cx              ;Decrementamos el registro "cx"
        jmp Convertir       ;Saltamos a Convertir
        
    Convertir:
        mov al,Cadena[si]   ;Movemos el valor de la Cadena en la posicion "si" al registro "al"
        
        cmp al,61h          ;Comparamos si el valor de "al" es mayor o igual a 61 hexadecimal (Suponemos que es una letra minuscula)
        jge Upper           ;Saltamos a Upper
        
        cmp al,41h          ;Comparamos si el valor de "al" es mayor o igual a 41 hexadecimal (Suponemos que es una letra mayuscula)
        jge Lower           ;Saltamos a Lower
                            
        inc si              ;Incrementamos el registro "si"
        
        cmp cx,0            ;Comparamos si el registro "cx" es igual a cero
        je Ajuste_Cx        ;Si es igual, saltamos a Ajuste_Cx
        
    Final_Conv:    
        loop Convertir      ;Ciclo Convertir
        
  ;MOSTRAR LA CADENA MODIFICADA
      
      mov ah,09h            ;Movemos 9 hexadecimal al registro "ah"
      mov dx, offset Salto_Ln
      int 21h
     
      mov ah,09h            ;Movemos 9 hexadecimal al registro "ah"
      lea dx, Msj_Modf
      int 21h
      
      mov ah,09h            ;Movemos 9 hexadecimal al registro "ah"
      lea dx, Cadena[2]
      int 21h 
      
Programa endp               ;Finaliza la subrutina Programa

end                         ;Fin