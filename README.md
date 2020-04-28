[TOC]

# 微处理器指令系统

## 微处理器的基本结构

CPU由以下部分组成：

- 算术逻辑单元（arithmetic logic unit， ALU）
- 控制器
- 寄存器组
- 中断系统

CPU的任务是执行存储器里的指令序列，
完成算术逻辑操作，
CPU和存储器以及I/0设备之间的数据传送。

## 8086/8088的结构

### 8086/8088微处理器

**8086**: Intel系列的16位微处理器，16条数据线，20条地址线。
可寻址范围是 2^20 = 1MB，8086工作时，始终频率为5MHz。

**8088**: 内部与8086兼容，也是一个16位微处理器，只是外部数据总线为8位，
所以成为准16位微处理器。它具有包括乘法和出发的16位运算指令，所以能处理16位数据，
还能处理8位数据。8088有20条地址线，所以可以寻址的地址空间也是 1MB。

### 执行单元EU和总线接口单元BIU

+ **EU的功能**
  1. EU负责执行指令。
  2. 进行算术运算和逻辑运算，并将运算结果的特征状态保存到状态寄存器FR中。
  3. 当需要与主存储器或I/O设备交换数据时，EU向BIU发出命令，
     并提供BIU 16位有效地址及需要传送的数据。
+ **BIU的功能**
  1. BIU从主存取指令送到指令队列缓冲器。
  2. CPU执行指令时，总线接口单元要配合EU从制定的主存储单元或外设端口中取数据。
     将数据传送给EU或者把EU的操作结果传送到指定的主存单元或外设端口中。
  3. 段寄存器提供的段地址与IP提供的偏移地址在地址加法器中相加
     形成访问存储器的20位物理地址。

## 8086/8088的寄存器

+ **8个通用寄存器**
  - **AX**：累加器，高低位分为 AH，AL
  - **BX**：基址寄存器，高低位分为 BH，BL
  - **CX**：计数器，高低位分为CH，CL
  - **DX**：数据寄存器，高低位分为DH，DL
  - **SP**：堆栈指针寄存器
  - **BP**：基址指针寄存器
  - **SI**：源地址寄存器
  - **DI**：目的地址寄存器
+ **2个控制寄存器**
  - **IP**：指令指针寄存器
  - **F**(也写作FR)：标志寄存器
+ **4个段寄存器**
  - **CS**：代码段寄存器
  - **DS**：数据段寄存器
  - **SS**：堆栈段寄存器
  - **ES**：附加段寄存器

### 通用寄存器

参与算术和逻辑运算，均为16位，且AX、BX、CX、DX高8位和低8位可作为两个独立的寄存器使用。CS不能做目的操作数。

### 指令指针寄存器IP

**IP** —— 硬件电路，能自动跟踪指令地址。<br>
在开始执行程序时，赋给IP第一条指令的地址，然后每取一条指令，
IP的值就自动指向下一条将要执行的指令地址。

> 注意：用户程序不能直接访问IP，既不能读，也不能写

### 状态标志寄存器

- <++>
- <++>
- <++>
- <++>
- <++>

### 段寄存器

如果未指定段前缀，则默认在 DS 里。
CS不能当目的操作数。

## 基本指令

### 数据传送类指令

通用数据传送指令(MOV, XCHG, PUSH, POP, LEA)

#### MOV：传送指令

- 语法格式：```MOV reg/mem/seg, reg/mem/seg/imm```
  (reg为通用寄存器，seg为段寄存器，eme为内存，imm为立即数)
- 功能：将源操作数src复制到目的操作数dst中，结果目的操作数的内容等于源操作数的内容，源操作数的内容不变。
- 对标识位的影响：无。

用法举例：

```assembly
; 立即数到寄存器
mov cl, 4 
mov ax, 03fffh

; 寄存器之间传送(除CS和IP)
mov al, bl ; 8位数据传送
mov ax, es ; 16位数据传送
mov ds, ax ; 16位数据传送

; 寄存器(除CS和IP)与存储器之间传送
mov as, [si]          ; 存储器到段寄存器
mov [di], cx          ; 通用寄存器到存储器
mov [1000h], al       ; 通用寄存器到存储器
mov dest[bp + di], es ; 段寄存器到存储器
```
值得注意的是，指令 ```mov dest[bp + di], es``` 中，
段前缀是隐含在堆栈段中的，另外几个都是隐含在DS中

>注意：不能用立即数给段寄存器赋值

#### XCHG (Exchange)：交换指令

- 指令格式：```XCHG oprd1, oprd2```
- 语法格式：```XCHG reg/mem, reg/mem```

### 堆栈和栈操作指令

- 8086/8088的堆栈伸展发那个想是从高地址向低地址
- 堆栈操作都是字操作，进栈时SP自动减2,出栈时自动加2
- 堆栈指令：PUSH和POP。
- SS：SP在任何时候都指向当前的栈顶。

### 标志处理指令
 
- **CLC**(clear carry)：进位位置0指令
- **CMC**(complement carry)：进位位求反指令
- **STC**(set carry)：进位位置一指令
- **DLD**(clear direction)：方向标志位置0指令
- **STD**(set direction)：方向标志位置一指令
- **CLI**(clear interrupt)：中断标志置0指令
- **STI**(set interrupt)：中断标志置1指令


### 地址传送指令

#### LEA

- 指令格式：```LEA reg16, mem``` (reg16表示16位的通用寄存器)
- 功能：主存按源地址的寻址方式计算偏移地址，将偏移地址送入指定寄存器。
- 该指令的目的操作数不能使用段寄存器
- 源操作数可使用除立即数和寄存器外的任一种存储寻址方式

**LEA指令与MOV指令的区别**

- ```lea si, buff```： 是将标号为buff的偏移地址送入寄存器中
- ```mov si, buff```：是将标号buff所指存储单元的内容送入si

例如：buff为2H，而段地址为2的内内存中存储的是48H，则上面两条指令中，
lea的执行完后 (si) = 0002H，mov执行的结果为 (si) = 0048H。

