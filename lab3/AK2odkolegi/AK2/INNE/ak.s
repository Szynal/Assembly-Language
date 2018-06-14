.data
STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512

.bss
.comm bufor, BUFLEN
.comm buforOut, BUFLEN

.text
.global main

main:

movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $bufor, %rsi
movq $BUFLEN, %rdx
syscall

dec %rax
movq $0, %rdi #licznik w pętli
movq $0, %r8 #liczba do pierwiastkowania
movq $0, %rbx

wczytywanie:
imul $10, %r8 
movb bufor (, %rdi, 1), %bl
cmp $'0', %bl
jl wyjscie
cmp $'9', %bl
jg wyjscie

sub $'0', %bl 

add %rbx, %r8
inc %rdi
cmp %rax, %rdi
jl wczytywanie


pierwiastkowanie:
movq $0, %rdi 	#licznik dla pierwiastka
movq $0, %r9 	# tymczasowa suma nieparzystych liczb
movq $1, %r10 	# dodawana liczba inkrementowana w każdym kroku

nastepny_krok:
add %r10, %r9 	# zwiększam sumę 
inc %rdi 	# inkrementuje licznik dodanych liczb
add $2, %r10 	# inkrementuje do następnej liczby nieparzystej
cmp %r8, %r9	# sprawdzamy, czy nie przekroczyliśmy warości liczby
jle nastepny_krok

koniec:
dec %rdi # zmniejszenie licznika wystąpień liczb który jest zarazem dolnym zaokrągleniem wyniku pierwiastkowania

sprawdzenie:

wyjscie:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

