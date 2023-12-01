SYS_WRITE equ 1
STDOUT equ 1
SYS_EXIT equ 0x3c

section	.data
msg db 0, 0, '1', 10, 0

section	.text
   global _start

_start:
   mov rbx, 0   ; create counter to track the loop times
loop:
   call print
   inc rbx      ; increase counter
   call inc_msg ; increse the ascii representation of number
   cmp rbx, 100 ; loop 100 times then end
   jge end
   jmp loop

inc_msg:
   inc byte [msg + 2]
   cmp byte [msg + 2], '9' ; if unit reach beyond ascii 9 -> jump to instructions that increase the tens representation
   jg inc_tens
back_msg:
   ret

inc_tens:
   mov byte [msg + 2], '0'
   cmp byte [msg + 1], 0  ; if tens is null, init tens as 1 then return
   je init_tens

   inc byte [msg + 1]

   cmp byte [msg + 1], '9' ; if tens is bigger than ascii 9, init hundred as 1, set tens back to 0 then return
   jg init_hund

   jmp back_msg

init_tens:
   mov byte [msg + 1], '1'
   jmp back_msg

init_hund:
   mov byte [msg + 1], '0'
   mov byte [msg], '1' ; if hundred is null, init hundred as 1, no need to increase hundred because no need to reach beyond max is 199
   jmp back_msg

print:
   mov rax, SYS_WRITE
   mov rdi, STDOUT
   mov rsi, msg
   mov rdx, 5 ; msg length is always 5
   syscall
   ret

end:
   mov rax, SYS_EXIT
   mov rdi, 0
   syscall
