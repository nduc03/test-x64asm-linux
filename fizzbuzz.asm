SYS_WRITE equ 1
STDOUT equ 1
SYS_EXIT equ 0x3c

DIV_3 equ 1
DIV_5 equ 2
DIV_15 equ 3
NODIV equ 0

section	.data
num db 0, 0, '1', 10, 0
numLen equ $-num
fizz db "Fizz", 10, 0
fizzLen equ $-fizz
buzz db "Buzz", 10, 0
buzzLen equ $-buzz
fizzBuzz db "FizzBuzz", 10 ,0
fbLen equ $-fizzBuzz

section	.text
   global _start

_start:
   mov rbx, 1   ; create counter to track the loop times
loop:
   call find_divisible
   call print
   inc rbx      ; increase counter
   call inc_num ; increse the ascii representation of number
   cmp rbx, 100 ; loop 100 times then end
   jg end
   jmp loop

inc_num:
   inc byte [num + 2]
   cmp byte [num + 2], '9' ; if unit reach beyond ascii 9 -> jump to instructions that increase the tens representation
   jg inc_tens
back_num:
   ret

inc_tens:
   mov byte [num + 2], '0'
   cmp byte [num + 1], 0  ; if tens is null, init tens as 1 then return
   je init_tens

   inc byte [num + 1]

   cmp byte [num + 1], '9' ; if tens is bigger than ascii 9, init hundred as 1, set tens back to 0 then return
   jg init_hund

   jmp back_num

init_tens:
   mov byte [num + 1], '1'
   jmp back_num

init_hund:
   mov byte [num + 1], '0'
   mov byte [num], '1' ; if hundred is null, init hundred as 1, no need to increase hundred because no need to reach beyond max is 199
   jmp back_num

find_divisible: ; divisible flags saved at rcx
   mov rax, rbx
   cqo
   mov r11, 15
   idiv r11
   cmp rdx, 0
   je div15
   mov rax, rbx
   cqo
   mov r11, 5
   idiv r11
   cmp rdx, 0
   je div5
   mov rax, rbx
   cqo
   mov r11, 3
   idiv r11
   cmp rdx, 0
   je div3

   mov rcx, NODIV
   ret

div15:
   mov rcx, DIV_15
   ret
div5:
   mov rcx, DIV_5
   ret
div3:
   mov rcx, DIV_3
   ret

print:
   mov rax, SYS_WRITE
   mov rdi, STDOUT
   cmp rcx, DIV_15
   je print15
   cmp rcx, DIV_5
   je print5
   cmp rcx, DIV_3
   je print3

   mov rsi, num
   mov rdx, numLen ; num length is always 5
   jmp callprint

print15:
   mov rsi, fizzBuzz
   mov rdx, fbLen
   jmp callprint

print5:
   mov rsi, buzz
   mov rdx, buzzLen
   jmp callprint

print3:
   mov rsi, fizz
   mov rdx, fizzLen
   jmp callprint

callprint:
   syscall
   ret

end:
   mov rax, SYS_EXIT
   mov rdi, 0
   syscall
