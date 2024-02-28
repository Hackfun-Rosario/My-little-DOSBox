title SBPLAY (SBPLAY.ASM)
; This program plays a sound with a SoundBlaster sound card in direct mode 

.model tiny

SBPORT          EQU 220h
BASE_FREQ       EQU 1193182     ; PIT 8253 input clock
COUNT           EQU 148         ; (BASE_FREQ / 8000) and 0FFFEh 
BUFSIZE         EQU 160

.code
.startup

main    proc
    
	call    reset_dsp       ; Try to reset the SB 
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

	mov     ah, 0E1h        ; Get DSP version command
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

test_loop:
	mov     ah, 0           ; get keyboard input
	int     16h
	dec     ah
	jnz     test_loop

	call    speaker_on


	; get the old timer interrupt handler
	mov     ax, 3508h
	int     21h
	mov     word ptr [old_ISR], bx
	mov     bx, es
	mov     word ptr [old_ISR+2], bx

	; Load the data pointer for use by our sound code
	mov     ax, offset datastart
	mov     word ptr [data_ptr], ax
	mov     ax, ds
	mov     word ptr [data_ptr+2], ax

	cli 

	; Replace IRQ0 with our sound code
	mov     dx, offset timer_ISR
	mov     ax, 2508h
	int     21h

	; configure the PIT
	mov     al, 36h     ; channel 0, access lo/hi, mode 3 (square), binary
	out     43h, al     ; write to PIT mode/command register
	mov     ax, COUNT   
	out     40h, al
	mov     al, ah
	out     40h, al
    
	sti


main_loop:
    
	mov     ah, 0       ; get keyboard input
	int     16h
	dec     ah
    
	jnz     main_loop

	call speaker_off

	; restore the old timer interrupt handler
    
	cli

	lds     dx, [old_ISR]
	mov     ax, 2508h
	int     21h

	; restore the PIT

	mov     al, 36h     ; channel 0, access mode lo/hi, mode 2 (rate), binary
	out     43h, al     ; write to PIT mode/command register
	sub     al, al   
	out     40h, al
	out     40h, al
    
	sti
exit:
	int 20h    

main endp

timer_ISR proc
	push    ds
	push    si
	push    ax
    
	lds     si, [data_ptr]
	mov     ax, ticks
	cmp     ax, datasize
	jb      continue_snd

	mov     si, datastart
	mov     word ptr [data_ptr], si
	xor     ax, ax
	mov     ticks, ax
    
    
continue_snd:    
	lodsb
	call    write_sample
	mov     word ptr [data_ptr], si
	inc     ticks    

exit_ISR:
	mov     al, 20h
	out     20h, al

	pop     ax
	pop     si
	pop     ds
	iret
timer_ISR       endp

speaker_on      proc
	push    ax
	mov     ah, 0D1h
	call    write_dsp
	pop     ax
	ret
speaker_on      endp

speaker_off     proc
	push    ax
	mov     ah, 0D3h
	call    write_dsp
	pop     ax
	ret
speaker_off     endp


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


write_sample    proc
	; AL = sample to send
	push    ax
	mov     ah, 10h
	call    write_dsp
	mov     ah, al
	call    write_dsp
	pop     ax
	ret
write_sample    endp

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

.data

msg_success     db      "OK", '$'
msg_error       db      "KO", '$'

ticks           dw      0
playing         db      1

datastart       EQU     $   
include         wow.inc        ; Up to 64KB of 8 kHz 8-bit unsigned LPCM
dataend         EQU     $
datasize        EQU     dataend - datastart

.data?
old_ISR         dd      ?
data_ptr        dd      ?

end     main

