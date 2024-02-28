title SBDET (SBDET.ASM)
; This program detects a SoundBlaster sound card 

.model tiny
.dosseg

SBPORT          EQU 220h

.data

msg_success     db  "OK", '$'
msg_error       db  "KO", '$'

.code
.startup

main    proc
	
	call    reset_dsp              ; Try to reset the SB 
	cmp     al, 0
	jne     detected
    
	mov     ah, 09h
	mov     dx, offset msg_error
	int     21h
	int     20h

detected:
	mov     ah, 09h
	mov     dx, offset msg_success
	int     21h

	mov     ah, 0E1h                ; Get DSP version command
	call    write_dsp

	call    read_dsp
	mov     dl, al
	add     dl, 48
	call    read_dsp
	mov     dh, al
	mov     ah, 02h
	int     21h
	xchg    dl, dh
	add     dl, 48
	mov     ah, 02h
	int     21h

	int     20h

main    endp

reset_dsp       proc
	
	push    cx
	push    dx
	
	; Try to reset the SB 
	mov     dx, SBPORT + 06h    ; Reset port
	mov     al, 1
	out     dx, al
	dec     al

delay:  
	dec     al
	jnz     delay
	out     dx, al

	xor     cx, cx
	mov     dx, SBPORT + 0Eh

empty:  ; Check Read-Buffer Status
	
	in      al, dx
	or      al, al
	jns     next

	sub     dl, 04h
	in      al, dx
	cmp     al, 0AAh
	je      success

next:
	loop    empty

fail:
	xor     al, al

success:
	pop     dx
	pop     cx
	ret

reset_dsp       endp

read_dsp        proc
	; AL = byte read from DSP
	push    dx
	mov     dx, SBPORT + 0Eh

read_status_clear:
	in      al, dx
	or      al, al
	jns     read_status_clear
	sub     dl, 04h
	in      al, dx
    
	pop     dx
	ret
read_dsp        endp

write_dsp       proc
	; AH = byte to write to DSP
	push    ax
	push    dx

	mov     dx, SBPORT + 0Ch

write_status_set:
	in      al, dx
	or      al, al
	js      write_status_set
	mov     al, ah
	out     dx, al
	
	pop     dx
	pop     ax
	ret
write_dsp       endp

end     main

