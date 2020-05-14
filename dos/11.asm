data segment
    array db 1h,2h,3h,4h
data ends

code segment
    assume cs:code
    assume ds:data
start: 
    mov al,array

    mov cx,03h
    mov ax,0
    mov bx,0

    int 21h
code ends
    end start
