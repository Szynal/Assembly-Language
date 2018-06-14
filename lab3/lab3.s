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
BUFLEN = 512			# Dłogosc stringow
SYSOPEN = 2
SYSCLOSE = 3
FREAD = 0			# Odzczyt z pliku
FWRITE = 1
SYSEXIT = 60

BUF = 512
SUPERBUF = 512

file1_in: .ascii "number1.txt\0"
file2_in: .ascii "number2.txt\0"
file_out: .ascii "result.txt\0"

error_message: .ascii "ERROR\n"
error_message_len = .-error_message 


# _______________________________________________________________________________________
#				 Basic Service Set
.bss		

.comm number1, 512
.comm decoded_number1, 512

.comm number2, 512
.comm decoded_number2, 512

.comm result, 512
.comm result_little_endian, 512
.comm result_ascii, 512


# _______________________________________________________________________________________

.text				# Sekcj tekstowa (kod prorgamu)
.globl _start			# punkt wejscia programu

_start:				# start programu

#--------------------------Dekodowanie pierwszej liczby

read_data_from_file1:

	open_file1:			# Otwieranie pliku 1
	mov $SYSOPEN, %rax		# wskażnik na poczatek nazwy pliku
	mov $file1_in, %rdi		# koniec nazwy pliku
	mov $FREAD, %rsi		# wskaźnik do odczytu
	mov $0666, %rdx			# Prawo dostepu do pliku
	syscall

		mov %rax, %r10 		# r10 -> wskażnik na poczatek nazwy pliku

	read_file1:			# odczytywanie danych z pliku
	mov $SYSREAD, %rax
	mov %r10, %rdi			
	mov $number1, %rsi
	mov $BUF, %rdx
	syscall

		mov %rax, %r8 		

	close_file1:			# zamykanie pliku
	mov $SYSCLOSE, %rax
	mov %r10, %rdi
	xor %rsi, %rsi
	xor %rdx, %rdx
	syscall

	dec %r8      	
	mov $BUF, %r9 
#read_data_from_file1


# indeksacja od 0 
loop_0:
	
   dec %r8				# przechowuje dlugosc ciagu znakow number1
   dec %r9
	 
	decoding_first_4_bits:

	mov number1(, %r8, 1), %al	# pobieranie najmlodsza liczbe 
		 
	sub $'0', %al			# Od teraz al przechowuje liczbe

	#Zapisanie zdekodowanego  bajtu
	mov %al, decoded_number1(, %r9, 1)

 cmp $0, %r8
jg loop_0
#____________________________________________________________________________________

#-----------------------Dekodowanie drugiej liczby

read_data_from_file2:

	open_file2:			# Otwieranie pliku 2 
	mov $SYSOPEN, %rax		# wskażnik na poczatek nazwy pliku
	mov $file2_in, %rdi		# koniec nazwy pliku
	mov $FREAD, %rsi		# wskaźnik do odczytu
	mov $0666, %rdx			# Prawo dostepu do pliku
	syscall

		mov %rax, %r10  	# r10 -> wskażnik na poczatek nazwy pliku

	read_file2:			# odczytywanie danych z pliku
	mov $SYSREAD, %rax
	mov %r10, %rdi			
	mov $number2, %rsi
	mov $BUF, %rdx
	syscall

		mov %rax, %r8 		

	close_file2:			# zamykanie pliku
	mov $SYSCLOSE, %rax
	mov %r10, %rdi
	xor %rsi, %rsi
	xor %rdx, %rdx
	syscall

	dec %r8      	
	mov $BUF, %r9 
#read_data_from_file2:

petla_2:
   dec %r8				# przechowuje dlugosc ciagu znakow number1
   dec %r9

	mov number2(, %r8, 1), %al	# pobieranie najmlodsza liczbe 
		 
	sub $'0', %al			# Od teraz al przechowuje liczbe

	#Zapisanie zdekodowanego  bajtu
	mov %al, decoded_number2(, %r9, 1)

 cmp $0, %r8
jg petla_2
 
 
#------------------Dodawanie----------------------------------------------------------

clc         			# Ustawia flagę przenoszenia na zero
pushfq        			# Przesuwa rejestr flagi na wierzch stosu
mov $BUF, %r8 
 
petla_3:
	mov decoded_number1(, %r8, 1), %al 
	mov decoded_number2(, %r8, 1), %bl 
	popfq        	# wyciąga  64 bity z wierzchu stosu i zapisuje je w rejestrze flag:
	adc %bl, %al 	# [Add With Carry] 
	pushfq      	# [Push Flag Register Onto Stack]
	mov %al, result(, %r8, 1)
	 
	dec %r8   
	cmp $0, %r8 
jg petla_3
 
preparecheck:
	mov $BUF, %r8 			# przeniesienie długości ciągu do rejestru r8
	mov %r8, %rdi

    newfix:
    dec %rdi
	mov result(, %rdi, 1), %al
	cmp $4, %al
	jge overflowfix
	jmp skipthefix
	
	overflowfix:
	sub $4, %al
	mov %al, result(, %rdi, 1)
	dec %rdi
	mov result(, %rdi, 1), %al
	add $1, %al
	cmp $4, %al
	jge overflowfix
	mov %al, result(, %rdi, 1)

    skipthefix:
    cmp $0, %rdi
    jg newfix
 #---------------Little endian----------------------------------------------------------


mov $BUF, %r8
xor %r9, %r9

little:

mov result(, %r8, 1), %al
mov %al, result_little_endian(, %r9, 1)

dec %r8
inc %r9

cmp $0, %r8 
jg little



#------------------------- zamiana na 16
mov $0, %r8
mov $0, %r9
mov $4, %r14
br:
mov result(, %r8, 1), %al
inc %r8
mov result(, %r8, 1), %bl

mul %r14
add %rbx, %rax

cmp $10, %al
jge zamiana_litery

add $'0', %al
mov %al, result_ascii(, %r9, 1)
inc %r9
inc %r8
cmp $1023, %r8 
jle br
jmp after16change

zamiana_litery:
add $7, %al
add $'0', %al
mov %al, result_ascii(, %r9, 1)
inc %r9
inc %r8
cmp $511, %r8 
jle br

after16change:

save_data_to_file: #zapis do pliku 

	mov $SYSOPEN, %rax
	mov $file_out, %rdi
	mov $FWRITE, %rsi
	mov $0644, %rdx
	syscall

		mov %rax, %r8

	mov $SYSWRITE, %rax
	mov %r8, %rdi
	mov $result_little_endian, %rsi
	mov $SUPERBUF, %rdx
	syscall

	mov $SYSCLOSE, %rax
	mov %r8, %rdi
	xor %rsi, %rsi
	mov %rdx, %rdx
	syscall

# end save_data_to_file

jmp exit

error:
	movq $SYSWRITE, %rax		# przeniesienie wartosci z SYSWRITE do rejestru rax
	movq $STDOUT, %rdi		# systemowe stdout
	movq $error_message, %rsi	# wyswietlanie tekstu
	movq $error_message_len, %rdx	# kopiowanie dlugosci stringa do rejstru danych
syscall	


exit:
	movq $SYSEXIT, %rax		# wykonanie funkcji EXIT
	movq $EXIT_SUCCESS, %rdi	# Wrzucenie do rejestru kodu wyjscia z programu
syscall					# zwraca kod bledu w %rdi
#_______________________________________________________________________________________

