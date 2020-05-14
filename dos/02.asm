datasg segment
    array db 1h,2h,3h,4h,5h
    count equ $-array
    sum dw 0h
datasg ends

codesg segment
    assume cs:codesg
    assume ds:datasg
start:
    mov ax,datasg
    mov ds,ax   ;将数据移入段寄存器
    xor ax,ax   ;ax归零
    mov cx,0    ;cs计数归零  
    mov bx,0    ;bx用来记偏移,先归零
next:
    add al,array[bx]  ;加一个元素
    inc bx            ;偏移地址加一
    inc cx            ;计数器加一
    cmp cx,count      ;比较计数器和数组长度
    jl next           ;条件转移
    mov byte ptr sum,al
    mov ah,4ch  ;调用中断度21h的4ch号退出功能
    int 21h
codesg ends
    end start

