ARM汇编



iOS汇编

- 真机，arm64，GNU汇编格式
  - 寄存器
  - 指令
  - 堆栈
- 模拟器， x86，AT&T汇编格式



寄存器：

- 通用寄存器
  - x0-x28
  - x0-x7通常用来存放函数的参数，更多的参数使用堆栈来存放
  - x0通常用来存放函数返回值
- 程序计数器--PC
- 堆栈指针
  - sp(Stack Pointer)
  - fp(Frame Point),也就是x29
- 链接寄存器
  - lr(link register)也就是x30
- 程序状态寄存器
  - cpsr(Current Program status register)	
    - 前四位为条件码标志位，N，Z，C，V
      - N，负号位
      - Z，零位
      - C，进制位
      - V（Overflow），溢出位
  - spsr(saved program status register)，异常状态下使用





```assembly
.text
.global _test,_add

;test函数的实现
_test:
mov x0, #0x8
ret

_add:
add x0, x0, x1
ret

_cmp:
mov x0, #1
mov x1, #2
cmp x0, x1

_goto:
b label
mov x1 #1
label
mov x2 #2

_equalgoto:
mov x0 ,#1
mov x1 ,#1
cmp x0,x1
beq label
mov x0, #0
label:
mov x0, #000
ret
/*
register read x1
si  (step instruction)
*/
```



指令：

- ret
  -  函数返回
- mov
  - mov   目的寄存器   源操作数
- add
  - add  R0， R1，R2 ，  R0 = R1 + R2
- sub
  - sub  R0， R1，R2 ，  R0 = R1 - R2
- cmp
  - cmp x0, x1, 将结果放在cspr
- b
  - 跳转指令，证明标签，跳转到标签位置
- bl
  - 带返回的跳转指令，函数调用一样。

- 条件域

  - EQ：equal
  - NE：not equal
  - GT：greate than 大于
  - GE：greate equal，大于等于
  - LT：less than，小于
  - LE：lee equal，小于等于

  

- 内存操作

  - load，从内存中装载数据
    - ldr，ldur
    - ldp
  - store，往内存中存储数据
    - str，stur
    - stp
    - 零寄存器
      - xzr（64位）