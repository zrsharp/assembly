data segment
    number dw Y
    addr dw number
    count dw ?
data ends

prog segment
main proc far
    assume cs:prog, ds:data
_start:
    push ds
    xor ax, ax
    push ax

    mov ax, data
    mov ds, ax

    xor cx, cx
    mov bx, addr
    mov ax, [bx]
_repeat:
    test ax, 0ffffh
    jz _exit
    jns _shift
    inc cx
_shift: 
    shl ax, 1
    jmp _repeat
_exit:
    mov count, ax
    ret
main endp
prog ends
    end _start


