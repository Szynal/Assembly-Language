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
movq $3, %R11 # argument licznika
movq $0, %R12 # miejsce na wynik

wtf:

call funkcja

wyjscie:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall


# funkcja 
funkcja:
# ---- wnetrze funkcji ----

cmp $0, %R11
jne dalej
movq $3, %R12   # zapisanie liczby 3 do rejestru wyniku
jmp koniec_funkcji
dalej: 

decq %R11   # dekrementacja licznika 
call funkcja # ponowne wywołanie funkcji na nowo podanych argumentach
imul $-5, %R12
addq $7, %R12

# ---- wyjscie z funkcji ----
koniec_funkcji:
ret