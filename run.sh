filename="file.asm"
read -p "Enter file name with extension: " filename

if [ -e "$filename" ]; then
    nasm -f elf64 $filename -o a64.o
    gcc -m64 -nostdlib -static -o a64.out a64.o
    ./a64.out
    rm ./a64.o
    rm ./a64.out
else
    echo "File does not exist."
fi
