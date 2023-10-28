org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A


start:
    jmp main


puts:
    push si
    push ax
    push bx


.loop:
    lodsb
    or al, al
    jz .done

    mov ah, 0x0E
    mov bh, 0
    int 0x10

    jmp .loop


.done:
    pop bx
    pop ax
    pop si
    ret


keyboard_handler:
    pusha
    in al, 0x60
    mov ah, 0x0E
    int 0x10

    movzx eax, al
    push eax
    push ebx
    mov ebx, input_buffer
    movzx edx, byte [ebx]
    mov [ebx + edx], al
    inc edx
    mov byte [ebx], dl

    pop ebx
    pop eax

    popa
    iret


main:
    mov ax, 0
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00

    mov si, hello_msg
    call puts
    
    mov si, input_msg
    call puts

    cli
    mov ah, 0
    mov al, 0x09
    mov di, keyboard_handler
    int 0x21
    sti

    mov ebx, input_buffer
    mov byte [ebx], 0


.text_input_loop:
    hlt
    jmp .text_input_loop

.halt:
    jmp .halt

hello_msg: db 'Welcome to CalcOS!', ENDL, 0
input_msg: db 'system@cos:~$: ', 0
input_buffer: times 64 db 0

times 510-($-$$) db 0
dw 0AA55h
