; TECL.ASM — Lectura del estado del teclado via DOS INT 21h
; Compila: nasm -f bin TECL.ASM -o TECL.COM
[BITS 16]
[ORG 0x100]     ; programa .COM, CS=DS=ES=SS
start:
    ; Esperar y leer una tecla via DOS (INT 21h)
    MOV AH, 08h     ; función DOS 08h: leer tecla sin eco en pantalla
    INT 21h         ; AL = código ASCII de la tecla presionada
    MOV BL, AL      ; guardar código en BL
    ; Mostrar scancode en pantalla (conversión hex manual)
    MOV AH, 02h     ; función DOS: imprimir carácter
    MOV DL, BL
    SHR DL, 4       ; nibble alto (bits 7-4)
    ADD DL, 30h     ; convertir a ASCII
    CMP DL, 3Ah     ; ¿es mayor que '9'?
    JL .printH
    ADD DL, 07h     ; ajuste para letras A-F
.printH:
    INT 21h         ; imprimir nibble alto
    MOV DL, BL
    AND DL, 0Fh     ; nibble bajo (bits 3-0)
    ADD DL, 30h     ; convertir a ASCII
    CMP DL, 3Ah     ; ¿es mayor que '9'?
    JL .printL
    ADD DL, 07h     ; ajuste para letras A-F
.printL:
    INT 21h         ; imprimir nibble bajo
    MOV AH, 02h
    MOV DL, 0Dh     ; CR — retorno de carro
    INT 21h
    MOV DL, 0Ah     ; LF — salto de línea
    INT 21h
    MOV AH, 4Ch
    INT 21h         ; terminar programa