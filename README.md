# Apellido-Post1-U9 — Acceso Directo a Puertos de E/S

**Curso:** Arquitectura de Computadores  
**Unidad:** 9 — Entrada y Salida Avanzados  
**Programa:** Ingeniería de Sistemas  
**Año:** 2026

---

## Objetivo

Implementar programas en lenguaje ensamblador x86 (NASM + DOSBox) que
acceden directamente a puertos de E/S mediante las instrucciones IN y OUT,
aplicar la técnica de polling para sincronización con dispositivos, y verificar
el comportamiento de los registros de estado del controlador de teclado 8042
y del puerto paralelo LPT1.

---

## Prerrequisitos

| Requisito | Detalle |
|---|---|
| Software | DOSBox 0.74 o superior con NASM 2.x accesible desde el prompt de DOS |
| Conocimientos previos | Instrucciones de E/S básicas (INT 21h), registros de segmento, modos de direccionamiento x86 (Unidades 3–6) |
| Archivos base | Ninguno — todos los archivos se crean desde cero |
| Directorio de trabajo | C:\DOSWork\LAB9POS1\ dentro de DOSBox |

---

## Configuración del Entorno

Abrir DOSBox y ejecutar:

```
keyb sp
mount c C:\DOSWork\LAB9POS1
C:
nasm -v
```

Salida esperada: `NASM version 2.16.03 compiled on Apr 17 2024`

---

## Programa 1 — TECL.ASM

### Descripción

Lee el teclado usando la función DOS INT 21h/08h. Cuando el usuario presiona
una tecla, captura su código ASCII y lo muestra en pantalla como valor
hexadecimal de dos dígitos.

### Puertos utilizados

| Puerto | Nombre | Descripción |
|---|---|---|
| INT 21h/08h | DOS | Leer tecla sin eco en pantalla |

### Compilación y ejecución

```
nasm -f bin TECL.ASM -o TECL.COM
TECL
```

### Comportamiento observado

Al presionar una tecla el programa muestra su código ASCII en hexadecimal
y termina. Ejemplos:

| Tecla | Salida |
|---|---|
| A | 41 |
| B | 42 |
| C | 43 |

### Checkpoint 1

El programa TECL.COM compila sin errores y muestra correctamente el valor
hexadecimal de la tecla presionada.

---

## Programa 2 — POLL_T.ASM

### Descripción

Implementa polling con timeout usando INT 16h del BIOS. Si el dispositivo
no responde en MAX_RETRY intentos, muestra un mensaje de error y termina
limpiamente, evitando el bloqueo indefinido del programa.

### Parámetro MAX_RETRY

| Valor | Comportamiento |
|---|---|
| 0005h | Timeout casi inmediato — para verificar el mensaje de error |
| 0FFFFh | 65535 intentos — comportamiento normal |

### Compilación y ejecución

```
nasm -f bin POLL_T.ASM -o POLL_T.COM
POLL_T
```

### Comportamiento observado

Con MAX_RETRY=0005h y sin presionar ninguna tecla, el programa muestra:

```
Timeout: sin respuesta del dispositivo
```

### Checkpoint 2

El programa POLL_T.COM muestra el mensaje de timeout cuando MAX_RETRY
es pequeño y no se presiona ninguna tecla en el tiempo definido.

---

## Programa 3 — LPT.ASM

### Descripción

Implementa el protocolo Centronics para enviar el carácter 'A' (0x41) al
puerto paralelo LPT mediante acceso directo a puertos de E/S. Espera que
la impresora esté lista (BUSY#=1) con timeout, coloca el dato en las líneas
de datos y genera el pulso STROBE necesario.

### Puertos utilizados

| Puerto | Nombre | Descripción |
|---|---|---|
| 0x378 | Data Register | 8 bits de datos hacia el conector |
| 0x379 | Status Register | Estado del periférico (BUSY, ACK...) |
| 0x37A | Control Register | Señales STROBE, AUTOFEED, INIT |

### Compilación y ejecución

```
nasm -f bin LPT.ASM -o LPT.COM
LPT
```

### Comportamiento observado

En DOSBox sin impresora física, el bit BUSY# del puerto 0x379 no cambia
a 1, por lo que el bucle .wait_ready agota el timeout (CX=0005h) y continúa
hacia el envío del dato. El programa compila y termina sin errores ni bloqueo.
El acceso a los puertos 0x378, 0x379 y 0x37A no genera error en DOSBox.
El pulso STROBE se genera correctamente aunque no haya periférico físico.

### Checkpoint 3

El programa LPT.COM compila y se ejecuta sin errores de acceso a puerto
en DOSBox. El bucle .wait_ready termina por timeout al no haber impresora
física conectada. El comportamiento es el esperado para el entorno de
emulación.

---

## Resumen de compilación

```
nasm -f bin TECL.ASM   -o TECL.COM
nasm -f bin POLL_T.ASM -o POLL_T.COM
nasm -f bin LPT.ASM    -o LPT.COM
```

---

## Contenido del repositorio

```
Apellido-Post1-U9/
├── README.md
├── TECL.ASM
├── POLL_T.ASM
├── LPT.ASM
└── capturas/
    ├── check1_TECL.png
    ├── check2_POLL_T.png
    └── check3_LPT.png
```
