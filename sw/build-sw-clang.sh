#!/bin/bash

# exit when any command fails
set -e

clang --target=riscv32 -march=rv32ic -std=c99 -O3 -mno-relax -Wall -Werror hyperram-test.c -c
llvm-mc --arch=riscv32 -mcpu=generic-rv32 -mattr=+c -assemble start.S --filetype=obj -o start.o
ld.lld -T system.ld start.o hyperram-test.o -o hyperram-test.elf
llvm-objcopy --only-section=.text --output-target=binary hyperram-test.elf hyperram-test.bin
hexdump -v -e '4/4 "%08x " "\n"' hyperram-test.bin > rom.vh
