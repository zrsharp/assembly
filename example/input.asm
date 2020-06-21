data segment
string db "Please input a string:$"
buf db 20
    db ?
    db 20 dup(?)
crlf db 0ah, 0dh, '$'
data ends

stacksg segment stack
    db 200 dup(?)
stacksg ends

code segment
    assume cs:code, ds:data, ss:stacksg
start:
    ; 保存返回栈
    push ds
    xor ax, ax
    push ax

    ; 初始化寄存器
    mov ax, data
    mov ds, ax

    ; 程序正式开始
    lea dx, string
    mov ah, 09h
    int 21h

    mov ah, 0ah
    lea dx, buf
    int 21h

    mov al, buf+1
    add al, 02h
    mov ah, 0
    mov si, ax
    mov buf[si], 24h
    lea dx, buf+2
    mov ah, 09h
    int 21h

    mov ah, 4ch
    int 21h
code ends
    end start
