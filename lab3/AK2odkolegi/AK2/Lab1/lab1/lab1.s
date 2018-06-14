#_______________________________________________________________________________________
#
#	AUTOR: Paweł Szynal nr albumu 226026 
# _______________________________________________________________________________________
#	
# 1.	Wczytanie ze standardowego wejscia liczby  w reprezentacji U10 (ASCII) i obliczenie wartosci bezwglednej [2p]
# 2.	Sprawdzenie poprawnosci wczytanego ciagu znakow (komunikat o bledzie) [0,5p]
# 3.	Sprawdzenie, czy wpisana liczba jest liczba pierwszą [1,5p]
# 4. 	Jesli tak, wypisanie jej na standardowe wyjscie w reprezentacji siodemkowej (ASCII) [1p]
# _______________________________________________________________________________________

#		Segment danych
.data		
# inicjalizacja segmanetu danych (Segment danych jest przeznaczony do odczytu i zapisu)
# Funkcje stadtardowe (ssyscall -tryb 64 bitowy dla linux-asm)

SYSREAD = 0			# nr funkcji wejscia - odczyt
SYSWRITE = 1			# nr funkcji wyjscia - zapis 
SYSEXIT = 60			# nr funkcji zakonczenia i zwrotu sterowania do SO
STDOUT = 1			# nr wyjscia stadardowego (ekran tekstowy)
STDIN = 0			# nr wejscia standardowego (klawiatura)
EXIT_SUCCESS = 0
BUFLEN = 512		# Dłogosc stringow


author_info: .ascii "Autor Paweł Szynal 226026\n\n"
author_info_len = .-author_info

string: .ascii "Podaj ciag znakow:\n"	# kod ascii zapisany do segmendu 'string'
string_len = .-string					# dlugosc string'a do wyswietlania 

error_info: .ascii "Nieprawidlowy ciag znakow\n\n" 
error_len = .-error_info

prime_number_info: .ascii "Jest to liczba pierwsza\n" 
prime_number_info_len = .-prime_number_info

number_info: .ascii "Nie jest to liczba pierwsza\n" 
number_info_len = .-number_info

zero_ascii = 0x30		# '0' w ascii
five_ascii = 0x35		# '0' w ascii
nine_ascii = 0x39		# '9' w ascii
overflow_ascii = 0x3A
ascii = 0x21			# '!' w ascii
base = 9			# specjaleni o jeden mniejsza
base_number = 10		# specjaleni o jeden mniejsza


# _______________________________________________________________________________________
#				 Basic Service Set
.bss		
.comm textin, 512
.comm textout, 512
# _______________________________________________________________________________________

.text				# Sekcj tekstowa (kod prorgamu)
.globl _start			# punkt wejscia programu

_start:				# start programu

#Wypisz author_info:
movq $SYSWRITE, %rax		# przeniesienie wartosci z SYSWRITE do rejestru rax
movq $STDOUT, %rdi		# systemowe stdout
movq $author_info, %rsi		# wyswietlanie tekstu o autorze programu
movq $author_info_len, %rdx	# kopiowanie dlugosci stringa(author_info) do rejstru danych
syscall	

# Wypisz string'a:
movq $SYSWRITE, %rax		# przeniesienie wartosci z SYSWRITE do rejestru rax
movq $STDOUT, %rdi		# systemowe stdout
movq $string, %rsi		# kopiowanie wartosci stringa do rejestru źródłowego
movq $string_len, %rdx		# kopiowanie dlugosci stringa do rejstru danych
syscall				# wywolanie funkcji systemowych

# Wczytywanie wpisanego tekstu
movq $SYSREAD, %rax		# kopiowanie z wartosci funkcji wejscia do rejstru akumulatora
movq $STDIN, %rdi		# dostep do wpisanego tekstu
movq $textin, %rsi		# poczatek wpisanego tekstu
movq $BUFLEN, %rdx		# koniec wpisanego tekstu
syscall

program_operation:
movb textin(, %rdi, 1), %bh	# niech bh przechowa n-ty(pierwszy) znak wpisanego tekstu 
				
	checking_String:	
	cmp $ascii, %bh			# porównaj z '!'
	jl loop
	cmp $zero_ascii, %bh		# porównaj z '0'
	jl incorrect_string		# przeskocz jesli mniejsze ok do etykiety incorrect_string
	cmp $nine_ascii, %bh		# porównaj z '9'
	jg incorrect_string 		# przeskocz jesli wieksza do etykiety incorrect_string,
	jmp absolute_value

	incorrect_string:		# Komunikat o bledzie 
	movq $SYSWRITE, %rax		
	movq $STDOUT, %rdi		
	movq $error_info, %rsi		
	movq $error_len, %rdx		
	syscall
	jmp exit

	absolute_value:
	cmp $0, %rdi			
	je check_the_sign

	cmp $1, %r8
	je negative_number
	jmp loop

	check_the_sign:
        cmp $five_ascii, %bh        # porównaj z '5'
        jge negative_number
        jmp loop

        negative_number:
        movq $1, %r8
        sub $zero_ascii, %bh    # traktujemy teraz bh jako liczbe
        neg %bh
        add $base, %bh
        mov %rax, %r15          # przeniesienie długości ciągu do rejestru r15
        sub $2, %r15            # odjecie 2 od długości ciągu
       
	cmp %r15, %rdi          # porównanie czy dodać jeszcze 1
      	jne adding_one
        add $1, %bh             # dodanie dodatkowej jedynki
       
	adding_one:
        add $zero_ascii, %bh
	jmp loop	

# pętla
loop:
movb %bh, textout(, %rdi, 1)
inc %rdi            # inkrementuj (pętla)
cmp %rax, %rdi              # porównaj rejstry 
jl program_operation        # zapętlaj aż rdi nie będzie równe temp regiter

prepare_check:
	mov %rax, %r15          # przeniesienie długości ciągu do rejestru r15
	sub $2, %r15            # odjecie 2 od długości ciągu
	mov %r15, %rdi
	movb textout(, %rdi, 1), %bh
	cmp $overflow_ascii, %bh
     je overflowfix
     jmp skipthefix

     overflowfix:
	mov $0, %bh
	add $zero_ascii, %bh
	movb %bh, textout(, %rdi, 1)
	dec %rdi
	movb textout(, %rdi, 1), %bh
	sub $zero_ascii, %bh
	add $1, %bh
	add $zero_ascii, %bh
	cmp $overflow_ascii, %bh
     je overflowfix
	movb %bh, textout(, %rdi, 1)
skipthefix:



# Wypisanie
print_absolute_value:
mov %rax, %r9 
mov %r9, %r8       
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq %r9, %rdx
syscall


calculate_number:
		
	sub $1, %r9	
	mov $0, %rbx
	sub $0, %r15
	mov $0, %rdi
	mov $0, %rax     		# initialize the accumulator
	mov $base_number, %r10

	addition_loop:
	
		mov $0, %rbx
		movb textout(, %rdi, 1), %bl	# niech bh przechowa n-ty(pierwszy) znak wpisanego tekstu 
		sub $zero_ascii, %bl	  	# traktujemy teraz bj jako liczbe
		add %rbx, %rax			# rejest bl jest dolnym rejestrem rejestru rbx
		inc %rdi			
		cmp %r9, %rdi
			je calculate_prime

		mul %r10
			jmp addition_loop


calculate_prime:
	mov %rax, %r15
	mov %rax, %rbx
	mov $2, %r12
	cmp $4, %rax
	jl is_a_prime_number

	prime_loop:
		mov $0, %rdx
		mov %rbx, %rax
		div %r12
		cmp $0, %rdx
			je not_a_prime_number
		inc %r12
		cmp %r15, %r12
			jl prime_loop

	jmp is_a_prime_number


	not_a_prime_number:
	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $number_info, %rsi
	movq $number_info_len, %rdx
	syscall
	jmp exit

	is_a_prime_number:
	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $prime_number_info, %rsi
	movq $prime_number_info_len, %rdx
	syscall


#	mov
#calculate_seven_base:
#	mov %r8, %rax
#	mov $0, %rdx
#	dov


# EXIT
exit:
movq $SYSEXIT, %rax		# wykonanie funkcji EXIT
movq $EXIT_SUCCESS, %rdi	# Wrzucenie do rejestru kodu wyjscia z programu
syscall				# zwraca kod bledu w %rdi
#_______________________________________________________________________________________

