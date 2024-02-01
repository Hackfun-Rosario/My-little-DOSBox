title SBDET (SBDET.ASM)
; This program detects a SoundBlaster sound card 

.model tiny
.dosseg

SBPORT  EQU 220h

.data

msg_success db  "OK", '$'
msg_error   db  "ER", '$'

.code
.startup

main proc
							; Try to reset the SB 
	mov dx, SBPORT + 06h    ; Reset port
	mov al, 1
	out dx, al
	dec al

delay:  
	dec al
	jnz delay
	out dx, al

	xor cx, cx
empty:                      ; Check Read-Buffer Status
	mov dx, SBPORT + 0Eh
	in  al, dx
	or  al, al
	jns next

	sub dl, 04h
	in  al, dx
	cmp al, 0AAh
	je  success

next:
	loop empty

	mov ah, 09h
	mov dx, offset msg_error
	int 21h
	jmp exit

success:
	mov ah, 09h
	mov dx, offset msg_success
	int 21h

exit:
	int 20h

main endp
end

