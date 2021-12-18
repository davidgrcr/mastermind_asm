# Mastermind
Consisteix en implementar el joc del Mastermind, on s’ha d’introduir una combinació secreta de 5 dígits entre 0 i 9 i llavors anar introduint combinacions de 5 dígits (jugades) fins a descobrir la combinació secreta o exhaurir el nombre màxim de jugades.   En la primera part només es compara la jugada amb la combinació secreta indicant quants dígits s’han encertat en lloc correcte.  

Per executar el programa cal fer:

yasm -f elf64 -g dwarf2 MMp1.asm
gcc -no-pie -o MMp1 -g MMp1.o MMp1c.c
kdbg MMp1
