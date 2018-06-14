#Program 1
# - wczyta ze standardowego wejścia podany przez użytkownika łańcuch znaków
# - dla każdego znaku sprawdzi, czy jest on wielką/małą literą/innym znakiem
#   i w zależności od tego wykona odpowiednią akcję na tym znaku	
#	do kodów ASCII cyfr doda stałą wartość 5,
#	do kodów ASCII wielkich liter doda stałą wartość 3
#	pozostałe znaki pozostawi bez zmian
# - wypisze zmieniony łańcuch znaków na ekran
# _______________________________________________________________________________________
#
#	AUTOR: Paweł Szynal nr albumu 226026 
# _______________________________________________________________________________________
#
#		Segment danych
.data		
# inicjalizacja segmanetu danych (Segment danych jest przeznaczony do odczytu i zapisu)
# Funkcje stadtardowe (ssyscall -tryb 64 bitowy dla linux-asm)

SYSREAD = 0			# nr funkcji wejscia - odczyt
SYSWRITE = 1		# nr funkcji wyjscia - zapis 
SYSEXIT = 60		# nr funkcji zakonczenia i zwrotu sterowania do SO
STDOUT = 1			# nr wyjscia stadardowego (ekran tekstowy)
STDIN = 0			# nr wejscia standardowego (klawiatura)
EXIT_SUCCESS = 0
BUFLEN = 512		# Dłogosc stringow


author_info: .ascii "Autor Paweł Szynal 226026\n\n"
author_info_len = .-author_info
string: .ascii "Podaj ciag znakow:\n"	# kod ascii zapisany do segmendu 'string'
string_len = .-string					# dlugosc string'a do wyswietlania 

is_a_number = 5			# dodaj 5 jesli liczba
is_a_letter = 3			# dodaj 3 jesli litera
			
zero_ascii = 0x30		# '0' w ascii
nine_ascii = 0x39		# '9' w ascii
A_ascii = 0x41			# 'A' w ascii
Z_ascii = 0x5A			# 'Z' w ascii


# _______________________________________________________________________________________
#				 Basic Service Set
.bss		
.comm textin, 512
.comm textout, 512
# _______________________________________________________________________________________

.text				# Sekcj tekstowa (kod prorgamu)
.globl _start			# punkt wejscia programu

_start:				# start programu

#Wypisz  tekst:
movq $SYSWRITE, %rax		# przeniesienie wartosci z SYSWRITE do rejestru rax
movq $STDOUT, %rdi		# systemowe stdout
movq $author_info, %rsi		# wyswietlanie tekstu o autorze programu
movq $author_info_len, %rdx	# kopiowanie dlugosci stringa(author_info) do rejstru danych
syscall	

#Wypisz  string'a:
movq $SYSWRITE, %rax		# przeniesienie wartosci z SYSWRITE do rejestru rax
movq $STDOUT, %rdi		# systemowe stdout
movq $string, %rsi		# kopiowanie wartosci stringa do rejestru źródłowego
movq $string_len, %rdx		# kopiowanie dlugosci stringa do rejstru danych
syscall				# wywolanie funkcji systemowych

#Wczytywanie wpisanego tekstu
movq $SYSREAD, %rax		# kopiowanie z wartosci funkcji wejscia do rejstru akumulatora
movq $STDIN, %rdi		# dostep do wpisanego tekstu
movq $textin, %rsi		# poczatek wpisanego tekstu
movq $BUFLEN, %rdx		# koniec wpisanego tekstu
syscall

#opearacja programu
operacja_programu1:
movb textin(, %rdi, 1), %bh	# niech bh przechowa n-ty(pierwszy) znak wpisanego tekstu 
				# 1- 9 w  ascii od 0x30 do 0x39
#Czy to liczba
cmp $zero_ascii, %bh		# porównaj z 0x30
jl letter			# przeskocz jesli mniejzse do etykiety litera
greater_or_equal:		
cmp $nine_ascii, %bh		# porównaj z 0x39
jg letter			# przeskocz jesli wieksza od 9
add $is_a_number, %bh		# dodaj stałą to liczby

#Czy to litera
letter:
cmp $A_ascii, %bh		# porównaj z 'A'
jl l1				# przeskocz jesli mniejzse do etykiety l1
cmp $Z_ascii, %bh		# porównaj z 'Z'
jg l1				# przeskocz jesli wieksza do etykiety l1
add $is_a_letter, %bh		# dodaj stałą to liczby

#wykoanaj operacje
l1:
movb %bh, textout(, %rdi, 1)
inc %rdi			# inkrementuj (pętla)
cmp %rax, %rdi			# porównaj rejstry 
jl operacja_programu1		# zapętlaj aż rdi nie będzie równe temp regiter

#movl $'\n', textout(, %rdi, 1 ) # dodanie wczesniej usunietego '\n'

#Wypisanie
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq $BUFLEN, %rdx
syscall
#EXIT
movq $SYSEXIT, %rax		# wykonanie funkcji EXIT
movq $EXIT_SUCCESS, %rdi	# Wrzucenie do rejestru kodu wyjscia z programu
syscall				# zwraca kod bledu w %rdi
#_______________________________________________________________________________________

