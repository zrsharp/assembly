assume cs:codesg
assume ss:stacksg

stacksg segment stack
    db 1 dup(0)
stacksg ends

codesg segment       
start:
    mov ax, 0123h
    mov bx, 0456h       
    add ax, bx    
    mov ax, 4c00h       
    int 21h
codesg ends
end

