; POLL_T.ASM — Polling con timeout para el puerto de teclado
; Compila: nasm -f bin POLL_T.ASM -o POLL_T.COM

[BITS 16]
[ORG 0x100]

MAX_RETRY EQU 0005h     ; número máximo de reintentos

start:
    MOV CX, MAX_RETRY   ; inicializar contador de reintentos

.poll:
    MOV AH, 01h         ; función BIOS 01h: verificar si hay tecla en buffer
    INT 16h             ; ZF=1 si no hay tecla, ZF=0 si hay tecla
    JNZ .dato_listo     ; si hay tecla — ir a leerla
    LOOP .poll          ; decrementa CX; si CX≠0 — repetir

    ; Timeout: CX llegó a 0 sin dato
    MOV AH, 09h         ; función DOS: imprimir cadena terminada en '$'
    MOV DX, msg_timeout
    INT 21h
    JMP .fin

.dato_listo:
    MOV AH, 00h         ; función BIOS 00h: leer tecla del buffer
    INT 16h             ; AL = código ASCII, AH = scancode
    MOV AH, 02h         ; función DOS: imprimir carácter
    MOV DL, AL          ; mostrar byte leído
    INT 21h

.fin:
    MOV AH, 4Ch
    INT 21h             ; terminar programa

msg_timeout DB 'Timeout: sin respuesta del dispositivo$'