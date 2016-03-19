#!/bin/bash
nasm -f elf64 echo.asm
ld -o echo echo.o -melf_x86_64
rm echo.o
strip echo
echo "Done building, the file 'echo' is your executable"
