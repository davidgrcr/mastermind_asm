!/bin/bash

yasm -f elf64 -g dwarf2 MMp1.asm
gcc -no-pie -o MMp1c -g MMp1.o MMp1c.c
kdbg MMp1c
