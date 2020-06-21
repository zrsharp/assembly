pro1gnam segment
main proc far
    assume cs:pro1gnam
start:
    push ds
    sub ax, ax
    push ax
    mov ch, 4
rotate:
    mov cl, 4
    rol bx, cl
    mov al, bl
    and al, ofh
    and al, 30h
    cmp al, 3ah
    jl printit
    add al, 7h
printit:
    mov dl, al
    mov ah, 2 
    int 21h
    dec ch
    jnz rotate
    ret
main endp
pro1gnam ends
    end start
