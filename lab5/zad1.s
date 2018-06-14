.data
format_double: .asciz "%lf"
format: .asciz "%d %lf %f"
nowa_linia: .asciz "\n"
 
.bss
.comm liczbaX, 4
.comm liczbaY, 8
.comm liczbaZ, 4
 
.text
.global main
 
main:

# Wczytywanie liczby int
mov $0, %rax                    # zero parametrow
mov $format, %rdi
mov $liczbaX, %rsi 
mov $liczbaY, %rdx
mov $liczbaZ, %rcx
call scanf          

# Wywolanie funkcji dodaj z Zad1.c
mov $2, %rax                    # 2 parametry zmiennoprzecinkowe
mov $0, %rdi                    # zerujemy, do mlodszych bajtow zostanie wpisana liczbaX
mov $0, %rcx                    
mov liczbaX(, %rcx, 4), %edi    # int
movss liczbaZ, %xmm0            # float jest pojedynczej precyzji, wiec movss
movlps liczbaY, %xmm1           # double jest podwojnej precyzji, wiec movlps
call dodaj

# Wyswietlanie wyniku przy uzyciu printf
mov $1, %rax                    # 1 parametr zmiennoprzecinkowy
mov $format_double, %rdi
# 
sub $8, %rsp                    
call printf
# uzywane jest do czyszczenia parametrow umieszonych na stosie dla funkcji printf 
add $8, %rsp

# Wyswietlenie nowej linii
mov $0, %rax 
mov $nowa_linia, %rdi
call printf                     # Wywołanie funkcji printf
 
mov $0, %rax
call exit