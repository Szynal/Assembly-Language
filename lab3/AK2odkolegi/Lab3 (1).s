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
error_message: .ascii "Wczytano błędną wartość\0"

.bss
.comm liczba1b, 1024
.comm liczba2b, 1024
.comm wynikb, 1024

.comm liczba1zdekodowana, 1024
.comm liczba2zdekodowana, 1024
.comm wynikzdekodowany, 1024
.comm wynikAscii, 4096

.comm wynik_little_endian, 1024

.text
.globl main



main:

#--------------------------Dekodowanie pierwszej liczby

mov $SYSOPEN, %rax
mov $file_in1, %rdi
mov $FREAD, %rsi
mov $0666, %rdx
syscall
mov %rax, %r10 

mov $SYSREAD, %rax
mov %r10, %rdi
mov $liczba1b, %rsi
mov $1024, %rdx
syscall
mov %rax, %r8 

mov $SYSCLOSE, %rax
mov %r10, %rdi
mov $0, %rsi
mov $0, %rdx
syscall

dec %r8      
mov $1024, %r9 

# indeksacja od 0 
petla:
dec %r8
dec %r9
 
# dekodowanie pierwszych 4 bitów
mov liczba1b(, %r8, 1), %al
 
cmp $'A', %al
jge litera
 
cmp $'0', %al
jl blad
sub $'0', %al
jmp dalej1
 
litera:
cmp $'F', %al
jg blad
sub $55, %al
 
dalej1:
 
# wyjście z pętli jeśli koniec bufora
cmp $0, %r8
jle dalej2
 
# dekodowanie ostatnich 4 bitów
mov %al, %bl
dec %r8
mov liczba1b(, %r8, 1), %al
 
cmp $'A', %al
jge litera2
 
cmp $'0', %al
jl blad
sub $'0', %al
jmp dalej3
 
litera2:
cmp $'F', %al
jg blad
sub $55, %al
 
dalej3:

# sklejanie
mov $16, %cl
mul %cl
add %bl, %al
 
dalej2:
mov %al, liczba1zdekodowana(, %r9, 1)
 

cmp $0, %r8
jg petla
 
#-----------------------Dekodowanie drugiej liczby


mov $SYSOPEN, %rax
mov $file_in2, %rdi
mov $FREAD, %rsi
mov $0666, %rdx
syscall
mov %rax, %r10 

mov $SYSREAD, %rax
mov %r10, %rdi
mov $liczba2b, %rsi
mov $1024, %rdx
syscall
mov %rax, %r8 

mov $SYSCLOSE, %rax
mov %r10, %rdi
mov $0, %rsi
mov $0, %rdx
syscall

dec %r8       
mov $1024, %r9 

petla_2:
dec %r8
dec %r9
 
mov liczba2b(, %r8, 1), %al
 
cmp $'A', %al
jge litera_2
 
cmp $'0', %al
jl blad
sub $'0', %al
jmp dalej1_2
 
litera_2:
cmp $'F', %al
jg blad
sub $55, %al
 
dalej1_2:
 
cmp $0, %r8
jle dalej2_2
 
mov %al, %bl
dec %r8
mov liczba2b(, %r8, 1), %al
 
cmp $'A', %al
jge litera2_2
 
cmp $'0', %al
jl blad
sub $'0', %al
jmp dalej3_2
 
litera2_2:
cmp $'F', %al
jg blad
sub $55, %al
 
dalej3_2:

mov $16, %cl
mul %cl
add %bl, %al
 
# Zapisanie zdekodowanego bajtu
dalej2_2:
mov %al, liczba2zdekodowana(, %r9, 1)
 
cmp $0, %r8
jg petla_2
 
#------------------Dodawanie----------------------------------------------------------

clc         
pushfq        
mov $1024, %r8 
 
petla_3:
mov liczba1zdekodowana(, %r8, 1), %al 
mov liczba2zdekodowana(, %r8, 1), %bl 
popfq        
adc %bl, %al 
pushfq      
mov %al, wynikb(, %r8, 1) 
 
dec %r8     
cmp $0, %r8 
jg petla_3
 
 #---------------Little endian----------------------------------------------------------

mov $1024, %R8
mov $0, %R9

little:

mov wynikb(, %R8, 1), %al
mov %al, wynik_little_endian(, %R9, 1)

dec %R8
inc %R9

cmp $0, %r8 
jg little


#------------------------- zamiana na 4
mov $0, %R8
mov $0, %R9
br:
mov wynikb(, %R8, 1), %al

mov %al, %bh
mov $192, %bl
and %bh, %bl
shr $6, %bl
add $'0', %bl
mov %bl, wynikAscii(, %R9, 1)
inc %R9

mov %al, %bh
mov $48, %bl
and %bh, %bl
shr $4, %bl
add $'0', %bl
mov %bl, wynikAscii(, %R9, 1)
inc %R9

mov %al, %bh
mov $12, %bl
and %bh, %bl
shr $2, %bl
add $'0', %bl
mov %bl, wynikAscii(, %R9, 1)
inc %R9

mov %al, %bh
mov $3, %bl
and %bh, %bl
shr $0, %bl
add $'0', %bl
mov %bl, wynikAscii(, %R9, 1)
inc %R9


inc %R8
cmp $1024, %r8 
jle br

#-------------------------------- zapis do pliku 

mov $SYSOPEN, %rax
mov $file_out, %rdi
mov $FWRITE, %rsi
mov $0644, %rdx
syscall
mov %rax, %r8

mov $SYSWRITE, %rax
mov %r8, %rdi
mov $wynikAscii, %rsi
mov $4096, %rdx
syscall


mov $SYSCLOSE, %rax
mov %r8, %rdi
mov $0, %rsi
mov $0, %rdx
syscall

blad:

wyjscie:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall