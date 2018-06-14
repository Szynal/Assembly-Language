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
movq $5, %R11 # argument licznika
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
sub $8, %rsp
# ---- wnetrze funkcji ----
mov 24(%rbp), %R13 # pobranie licznika
mov 16(%rbp), %R14 # pobranie wyniku

cmp $0, %R13
jne dalej
movq $3, 16(%rbp)   # zapisanie liczby 3 dla wyrazu 0(ten sam adres, który bedzie
                    # zpopowany do %R14
jmp koniec_funkcji
dalej: 

decq %R13   # dekrementacja licznika   
push %R13   # wrzucenie licznika na stos
push %R14   # wrzucenie wyniku na stos
call funkcja # ponowne wywołanie funkcji na nowo podanych argumentach
pop %R14    # pobranie wyniku
pop %R13    # pobranie licznika
imul $-5, %R14
addq $7, %R14
movq %R14, 16(%rbp)

# ---- wyjscie z funkcji ----
koniec_funkcji:

mov %rbp, %rsp
pop %rbp
ret