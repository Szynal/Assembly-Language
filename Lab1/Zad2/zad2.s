#Program 2
# - wczyta ze standardowego wejścia podany przez użytkownika łańcuch znaków
# - wprowadzony ciąg potraktuje jako reprezentację w systemie siódemkowym.
# - wypisze na standardowe wyjście reprezentację liczby w systemie dziesiętnym
# _______________________________________________________________________________________
#
#	AUTOR: Paweł Szynal nr albumu 226026 
# _______________________________________________________________________________________
#
#		Segment danych
.data			# inicjalizacja segmanetu danych (Segment danych jest przeznaczony do odczytu i zapisu)

# Funkcje stadtardowe (ssyscall -tryb 64 bitowy dla linux-asm)

SYSREAD = 0		# nr funkcji wejscia - odczyt
SYSWRITE = 1	# nr funkcji wyjscia - zapis 
SYSEXIT = 60	# nr funkcji zakonczenia i zwrotu sterowania do SO
STDOUT = 1		# nr wyjscia stadardowego (ekran tekstowy)
STDIN = 0		# nr wejscia standardowego (klawiatura)
EXIT_SUCCESS = 0
BUFLEN = 512	# Dłogosc stringow


author_info: .ascii "Autor Paweł Szynal 226026\n\n"
author_info_len = .-author_info
string: .ascii "Podaj ciag znakow:\n"	# kod ascii zapisany do segmendu 'string'
string_len = .-string					# dlugosc string'a do wyswietlania 



# _______________________________________________________________________________________
#				 Basic Service Set
.bss		
.comm textin, 512
.comm textout, 512
# _______________________________________________________________________________________

.text				# tekst programu (musi byc)
.globl _start		# punkt wejscia programu

_start:				# start programu

# Wypisz  tekst:
movq $SYSWRITE, %rax		# przeniesienie wartosci z SYSWRITE do rejestru rax
movq $STDOUT, %rdi			# systemowe stdout
movq $author_info, %rsi		# wyswietlanie tekstu o autorze programu
movq $author_info_len, %rdx	# kopiowanie dlugosci stringa(author_info) do rejstru danych
syscall	

# Wypisz  string'a:
movq $SYSWRITE, %rax		# przeniesienie wartosci z SYSWRITE do rejestru rax
movq $STDOUT, %rdi			# systemowe stdout
movq $string, %rsi			# kopiowanie wartosci stringa do rejestru źródłowego
movq $string_len, %rdx		# kopiowanie dlugosci stringa do rejstru danych
syscall						# wywolanie funkcji systemowych

# Wczytywanie wpisanego tekstu
movq $SYSREAD, %rax		# kopiowanie z wartosci funkcji wejscia do rejstru akumulatora
movq $STDIN, %rdi		# dostep do wpisanego tekstu
movq $textin, %rsi		# poczatek wpisanego tekstu
movq $BUFLEN, %rdx		# koniec wpisanego tekstu
syscall

#opearacja programu
operacja_programu:
movb textin(, %rdi, 1), %bh	#niech bh przechowa n-ty(pierwszy) znak wpisanego tekstu 
#zamiana strina na liczbę (system 10)			
string_to_decimal:



	
l1:
movb %bh, textout(, %rdi, 1)
inc %rdi			# inkrementuj (pętla)
cmp %rax, %rdi			# porównaj rejstry 
jl operacja_programu		# zapętlaj aż rdi nie będzie równe temp regiter

#movl $'\n', textout(, %rdi, 1 ) # dodanie wczesniej usunietego '\n'
#Wypisanie
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq $BUFLEN, %rdx
syscall
#EXIT
movq $SYSEXIT, %rax		#wykonanie funkcji EXIT
movq $EXIT_SUCCESS, %rdi	#Wrzucenie do rejestru kodu wyjscia z programu
syscall				#zwraca kod bledu w %rdi
#_______________________________________________________________________________________

