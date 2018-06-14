.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSOPEN = 2
SYSCLOSE = 3
FREAD = 0
FWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
file_in1: .ascii "liczba1.txt\0"
file_in2: .ascii "liczba2.txt\0"
file_out: .ascii "wynik.txt\0"

.bss
.comm liczba1b, 1024
.comm liczba2b, 1024
.comm wynikb, 1024

.text
.globl main

main:


# obsluga pierwszej liczby.

mov $SYSOPEN, %rax
mov $file_in1, %rdi
mov $FREAD, %rsi
mov $0666, %rdx
syscall
mov %rax, %r10 # Przepisanie identyfikatora otwartego pliku do R10


# Odczyt z pliku do bufora
mov $SYSREAD, %rax
#mov $STDIN, %rdi
mov %r10, %rdi
mov $liczba1b, %rsi
mov $1024, %rdx
syscall
mov %rax, %r8 # Zapisanie ilości odczytanych bajtów do rejestru R8


# Zamknięcie pliku
mov $SYSCLOSE, %rax
mov %r10, %rdi
mov $0, %rsi
mov $0, %rdx
syscall


# zamiana 16 na liczbę
movq $0, %r13
movq $0, %rdi
movq $0, %rbx
dec %r8

zamiana:
imul $16, %r13 
movb liczba1b (, %rdi, 1), %bl
sub $'0', %bl 
add %rbx, %r13
inc %rdi
cmp %r8, %rdi
jl zamiana




wyjscie:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
