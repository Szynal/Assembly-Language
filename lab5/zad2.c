#include <stdio.h>

int liczba = 18;
char str[] = "          ";
char tmp[] = "          ";

int main(void)
{
    asm(
        "mov $0, %rax \n"
        "mov liczba, %rax \n"
        "mov $0, %rdi \n"
        "mov $8, %r12 \n"
        "osiemloop: \n"
        "mov $0, %rdx \n"
        "div %r12 \n"
        "add $'0', %rdx \n"
        "movb %dl, str(, %rdi, 1) \n"
        "inc %rdi \n"
        "cmp $0, %rax \n"
        "jne osiemloop \n"

        "mov $0, %rcx \n"
        "mov %r9, %rdi \n"
        "add $1, %rdi \n"
        "swaploop: \n"
        "mov $0, %rbx \n"
        "movb str(, %rdi, 1), %bl \n"
        "movb %bl, tmp(, %rcx, 1) \n"
        "inc %rcx \n"
        "dec %rdi \n"
        "cmp $0, %rdi \n"
        "jne swaploop \n"
        "movb str(, %rdi, 1), %bl \n"
        "movb %bl, tmp(, %rcx, 1) \n"
    );

    printf("Wynik: %s\n", tmp);

    return 0;
}