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

message: .ascii "1234aa5q78a90a\0"
message_l = .-message
.bss

.comm tekst, 1024

.text
.globl main

main:



push $message
push $message_l
call funkcja

pop %r11

wyjscie:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

# funkcja 
funkcja:
push %rbp
mov %rsp, %rbp
# ---- wnetrze funkcji ----
mov 16(%rbp), %R8 # lancucha
mov 24(%rbp), %R9
# dlugosc 

# ---- pętla do szukania
mov $0, %R10

petla:
cmp %R10, %R8
jl nie_znaleziono
# ---- szukanie "a"
mov (%R9, %R10, 1), %al
inc %R10
cmp $'a', %al
jne petla
# ---- szukanie "c"
mov %R10, %R11
inc %R11
mov (%R9, %R11, 1), %al
cmp $'c', %al
je znaleziono


#mov -1 ,16(%rbp)

# ---- jeżeli nie znalazło to zwraca -1

# ---- ............... ----
jmp petla
nie_znaleziono:
mov $0, %R15
not %R15
mov %R15, %r10
mov %R10 ,16(%rbp)
mov %rbp, %rsp
pop %rbp
ret



znaleziono:
dec %R10
mov %R10, %R15
mov %R10 ,16(%rbp)
koniec_funkcji:

mov %rbp, %rsp
pop %rbp
ret

