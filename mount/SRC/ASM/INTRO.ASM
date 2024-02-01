title Intro (intro.asm)
; This program enables graphics video mode 13h
; and paints the screen with a uniform color after each
; keystroke, until ESC is pressed

.model tiny
.dosseg
.data
	vmode   db 0
.code
.startup
main proc
	
	mov ah, 0Fh     ; Obtener modo de video actual
	int 10h

	mov vmode, al   ; Guardar el modo de video actual para restaurar luego
	
	mov ax, 0013h   ; Establecer el modo gr fico 320x200x256 (VGA)
	int 10h

	xor bx, bx      ; BH/BL contienen el ¡ndice de color (inicia en cero)
 	mov ax, 0A000h  ; Segmento de la memoria de video (modo gr fico)
	mov es, ax

main_loop:
	
	xor di, di      ; Desplazamiento inicial dentro de la memoria gr fica
	mov cx, 32000   ; Cantidad de words a escribir (320x200/2)
	
	mov dx, 03DAh   ; Sincronizar la escritura de la memoria de video
wait_end:               ; con el retorno del haz del CRT a la posici¢n inicial
	in al, dx       ; para evitar "glitches"
	test al, 8      ; El bit 3 del puerto 03DAh indica si el haz est 
	jnz wait_end    ; retornando
wait_start:
	in al, dx
	test al, 8
	jz wait_start
	
	mov ax, bx      ; Color a escribir en memoria (dos p¡xeles)
	rep stosw       ; Escribir a partir de ES:[DI] el valor AX, CX veces
	
	mov ah, 0       ; Leer tecla
	int 16h

	inc bl		; Incrementar ¡ndice de color para ambos pixeles
	inc bh
	
	dec ah          ; El scan code de la tecla est  en ah
	
	jnz main_loop   ; El scan code no es 0 (ESC), continuar

	mov ah, 00h     ; Restaurar modo de video inicial
	mov al, vmode
	int 10h

	mov ax, 4c00h   ; Terminar el programa via DOS
	int 21h
main endp
end
