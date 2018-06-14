Data:
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
movq $10, %R11 # argument
movq $0, %R12 # miejsce na wynik

pushq %R11
pushq %R12

wtf:

call funkcja

popq %R8


wyjscie:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall


# funkcja 
funkcja:
push %rbp
mov %rsp, %rbp
# ---- wnetrze funkcji ----
mov 24(%rbp), %R8 # pobranie liczby 

cmp $0, %R8
jne dalej1
movq $3 ,16(%rbp)
jmp koniec_funkcji
dalej1:

decq %R8 # przygotowanie miejsca pod rekurencje
push %R8
pushq $0

call funkcja # do przygotowanego miejsca zostanie wpisany wynik rekurencji

subq $16, %rsp # przesuwamy wskaźnik stosu

movq -8(%rbp), %R8
movq %R8, -24(%rbp)
movq $0, -32(%rbp)
decq -24(%rbp)

call funkcja

tmp:
movq -16(%rbp), %R8 # pierwszy argument
movq -32(%rbp), %R9 # drugi argument
imul $7, %R9
subq %R9, %R8




add $16, %rsp # usunięcie dwóch ostatnich elementów stosu

movq %R8, 16(%rbp)

# ---- wyjscie z funkcji ----
koniec_funkcji:

mov %rbp, %rsp
pop %rbp
ret

