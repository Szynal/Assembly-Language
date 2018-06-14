# _______________________________________________________________________________________
#
#	AUTOR: Paweł Szynal nr albumu 226026 
# _______________________________________________________________________________________
#		Program wczytaj-wypisz i zamienisz wielkie litery na małe, a małe na wielkie  
#				Segment danych
.data

STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512

#	Dyrektywa as .comm 
# 	może zostać połączony ze zdefiniowanym lub wspólnym symbolem 
#	o tej samej nazwie w innym pliku obiektowym.
# _______________________________________________________________________________________
#				 Basic Service Set
.bss		
.comm textin, 512
.comm textout, 512
# _______________________________________________________________________________________
# 				Sekcj tekstowa (kod prorgamu)
.text
.globl _start
	
	# .global (.glob) sprawia, że symbol jest widoczny dla ld. Jeśli zdefiniujemy symbol 
	# w programie częściowym, jego wartość jest udostępniana innym programom częściowym, 		# które są z nim powiązane. 
	
_start:

movq $SYSREAD, %rax	# kopiujemy wastrość SYSREAD do akumulatora.
movq $STDIN, %rdi	# kopiujemy wartośc STDIN do indeksu źródłowego.	
movq $textin, %rsi	# kopiujemy wartość textin do indeksu docelowego.
movq $BUFLEN, %rdx	# kopiujemy wartość BUFLEN do rejestru ranych.  
syscall				# Invoke the operating system.


dec %rax		# zmniejszamy wartosc o 1 (pozbywamy sie '\n')
movq $0, %rdi	# licznik

zamien_wielkosc_liter:		# rejestr EBX dzieli sie na E, bx, z kolei bx dzieli sie na bh i bl
movb textin(, %rdi, 1), %bh  	# bh = rdi * 1 + textin 
movb $0x20, %bl					# bl =	32
xor %bh, %bl					# bx xor bl
movb %bl, textout(,%rdi, 1)		# rdi * 1 + textout = bl
inc %rdi						# zwiększa wartośc rdi o 1 
cmp %rax, %rdi					# porównuje rejestry ustawiając odpowiednio flagi; bez zapamiętywania 
jl zamien_wielkosc_liter

movb $'\n', textout(, %rdi, 1)

movq $SYSWRITE, %rax    # kopiujemy wastrość SYSWRITE do akumulatora.
movq $STDOUT, %rdi 		# kopiujemy wartośc STDOUT do indeksu źródłowego.
movq $textout, %rsi		# kopiujemy wartość textin do indeksu docelowego.
movq $BUFLEN, %rdx		# kopiujemy wartość BUFLEN do rejestru ranych.  
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
