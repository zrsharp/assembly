# 汇编结构化程序设计

## 分支程序设计

**例题：**试根据AL寄存器中哪一位为1（从低到高）把程序转移到8个不同的程序分支中去。

```assembly
data segment
    branch_table dw routine1
    			 dw routine2
    			 dw routine3
    			 dw routine4
    			 dw routine5
    			 dw routine6
    			 dw routine7
    			 dw routine8
data ends

code segment
main proc far
	assume cs:code, ds:data
start:
	push ds
	sub ax, ax
	push ax
	mov bx, data
	mov ds, bx
	cmp al, 0
	je continue_main_line
    mov si, 0
loop1:
	shr al, 1
	jnc not_yet
	jmp branch_table[si]
not_yet:
	add si, type branch_table
	jmp loop1
continue_main_line:
routine1:
routine2:
routine3:
routine4:
routine5:
routine6:
routine7:
routine8:
	ret
main endp
code ends
	end start
     
```



## 循环语句

**例题：**在 ADDR 单元中存放着 Y (16位数) 的地址，试编制一个程序把 Y 中 1 的个数存储 COUNT 单元中。

![](/home/zerosharp/Documents/assembly/instructions/img/flowchart1.png)



```assembly
data segment
	number dw Y
	addr dw number
	count dw ?
data ends

code segment
main proc far
	assume cs:code, ds:data
start:
; 设定返回堆栈
	push ds
	sub ax, ax
	push ax
; 设置寄存器
	mov ax, data
	mov ds, ax
; 主要的程序开始
	mov cx, 0
	mov bx, addr
	mov ax, [bx]  ; 把Y放到ax
repeat:
	test ax, 0ffffh ; 和offfh相与，如果ax内存的是0，则结果为0
	jz exit
	jns shift  ; jns: 如果符号位S不为1，就跳转
	inc cx
shift:
	shl ax, 1  ; 将Y向左移动一位
	jmp repeat ; 继续循环
exit:
	mov count, cx
	ret
main endp
data ends       ; 代码段结束
	end start	; 源程序结束
```



**例题：**试编制一个程序把BX寄存器内的二进制数用十六进制数的形式在屏幕上现实出来



