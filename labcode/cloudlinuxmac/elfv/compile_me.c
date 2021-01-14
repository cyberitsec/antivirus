#include <stdio.h>

// gcc -o compile_me.elf compile_me.c
// ./compile_me.elf
// hexdump -C compile_me.elf | head -n 10
// readelf -h compile_me.elf
// objdump -D compile_me.elf
// objdump -D compile_me.elf | grep never_call
// objdump -D compile_me.elf | grep main
// hexedit compile_me.elf
// hexedit --linelength 16 compile_me.elf

// xxd compile_me.elf
// sudo apd-get install nasm hexedit


void never_call(void) {
    printf("[*] wow how did you call this fcn? \n");
    return;
}

int main(int argc, char** argv) {
    printf("[*] you run this binary! \n");
    return 0;
}