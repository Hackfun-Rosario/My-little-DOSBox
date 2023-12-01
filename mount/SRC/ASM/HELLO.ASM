title Hello World program (hello.asm)
; This program displays "Hello, world!"
.model tiny
.dosseg
.data
        message db "Hello, world!", 0dh, 0ah, '$'
.code
.startup
main proc
        ;mov ax, cs
        ;mov ds, ax

	mov ah, 9
        mov dx, offset message
        int 21h

        mov ax, 4c00h
        int 21h
main endp
END

