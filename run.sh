nasm -f elf64 hello.asm -o a64.o
gcc -m64 -nostdlib -static -o a64.out a64.o
./a64.out
