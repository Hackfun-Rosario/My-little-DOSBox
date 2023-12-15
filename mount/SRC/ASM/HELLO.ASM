title Hello World program (hello.asm)
; This program displays "Hello, world!"
.model tiny
.dosseg
.data
	message db "Hello, world!", '$'
.code
.startup
main proc
	
	mov ah, 9		; Funci¢n DOS para imprimir en pantalla	(09h)	
	mov dx, offset message  ; Direcci¢n del mensaje a imprimir
	int 21h			; Llamar a servicios DOS

	mov ax, 4c00h		; Funci¢n DOS para terminar programa (4Ch)
				; C¢digo de salida 00h (en AL)
	int 21h
main endp
end

