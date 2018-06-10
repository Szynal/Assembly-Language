# _______________________________________________________________________________________
#
#	AUTOR: Paweł Szynal nr albumu 226026 
# _______________________________________________________________________________________
.data		# inicjalizacja segmanetu danych (Segment danych jest przeznaczony do odczytu i zapisu)

# Funkcje stadtardowe (syscall -tryb 64 bitowy dla linux-asm)
SYSREAD = 0			# nr funkcji wejscia - odczyt 
SYSWRITE = 1			# nr funkcji wyjscia - zapis 
SYSEXIT = 60			# nr funkcji zakonczenia i zwrotu sterowania do SO
STDOUT = 1			# nr wyjscia stadardowego (ekran tekstowy)
STDIN = 0			# nr wejscia standardowego (klawiatura)
EXIT_SUCCESS = 0

buf: .ascii "Hello, world!\n"	# kod ascii zapisany do segmendu buffora
buf_len = .-buf				# dlugosc bufora do wyswietlania 

.text					# Sekcja kodu programu 
.globl _start				# punkt wejscia programu

_start:				# start programu

movq $SYSWRITE, %rax		# przeniesienie wartosci z SYSWRITE do rejestru rax
movq $STDOUT, %rdi		# systemowe stdout
movq $buf, %rsi			# wrzucenie Wrzucenie napisu "Hello word" z buf do rejestru rsi
movq $buf_len, %rdx		# dlugosc wyswietlanego łancucha znaków
syscall						

movq $SYSEXIT, %rax		# wykonanie funkcji EXIT
movq $EXIT_SUCCESS, %rdi	# Wrzucenie do rejestru kodu wyjscia z programu
syscall				# zwraca kod bledu w %rdi

