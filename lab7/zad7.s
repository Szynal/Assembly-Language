.data
SYSEXIT = 60
EXIT_SUCCESS = 0
silnia: .double 0.0
nowa_linia: .asciz "\n"
format: .asciz "%d"

value1:
    .int 10, 20, 30, 40, 50, 60, 70, 80, 90 
value2: 
    .int 100, 120, 130, 140, 150, 160, 170, 180, 190
value3:
    .int 0,0,0,0,0,0,0,0,0
.bss
    .lcomm result, 512 
    .comm time, 512

.text
.global main

main:

mov $0, %rax
mov $9, %r13
movss silnia, %xmm3

call rdtscccc                     
mov %rax, %r8

call fun    #Wykonaie działań

call rdtscccc              
mov %rax, %r9
sub %r8, %r9

wynik:

movss result, %xmm0

# Wyswietlanie wyniku przy uzyciu printf
mov $0, %rax                    
mov $format, %rdi

sub $8, %rsp                    
call printf
add $8, %rsp

mov $0, %rax 
mov $nowa_linia, %rdi
call printf

mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall

fun:
cmp $0, %r13
je koniec
dec %r13

movss value1, %xmm1 
movss value2, %xmm2

addss %xmm1, %xmm2 

addss %xmm2, %xmm3

koniec:
movss %xmm3, result
ret

rdtscccc:
rdtsc   #Rozpoczecie Timera
shl $32, %rdx   #Przesunięcie rejestru rdx o 32 miejsca w lewo
add %rdx, %rax 

ret
