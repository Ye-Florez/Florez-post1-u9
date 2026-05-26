; LPT1.ASM — Envío de un carácter al puerto paralelo LPT1
; Compila: nasm -f bin LPT1.ASM -o LPT1.COM

[BITS 16]
[ORG 0x100]

DATA_PORT   EQU 0378h
STATUS_PORT EQU 0379h
CTRL_PORT   EQU 037Ah

start:
    ; Esperar BUSY=1 (impresora lista) con timeout
    MOV CX, 0005h           ; contador de reintentos
    MOV DX, STATUS_PORT
.wait_ready:
    IN AL, DX               ; leer registro de estado de LPT1
    TEST AL, 80h            ; bit 7: BUSY# (activo en bajo = ocupada)
    JNZ .enviar             ; si bit7=1 (lista) — continuar
    LOOP .wait_ready        ; decrementar CX; si CX≠0 — repetir

.enviar:
    ; Enviar carácter "A" (0x41)
    MOV DX, DATA_PORT
    MOV AL, 41h
    OUT DX, AL              ; colocar dato en el bus de datos

    ; Pulso STROBE
    MOV DX, CTRL_PORT
    IN AL, DX
    AND AL, 0FEh            ; STROBE=0 — activo
    OUT DX, AL

    ; Retardo
    MOV CX, 0Fh
.delay:
    LOOP .delay

    ; Desactivar STROBE
    IN AL, DX
    OR AL, 01h              ; STROBE=1 — inactivo
    OUT DX, AL

    MOV AH, 4Ch
    INT 21h                 ; terminar programa