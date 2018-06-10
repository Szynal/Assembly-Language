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
.data
# deklaracja stałych
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512
POCZATEK_LICZB = 0x30 # kod ASCII pierwszej liczby
NOWA_LINIA = 0xA # kod ASCII znaku nowej lini
PODSTAWA_WEJSCIA = 7
PODSTAWA_WYJSCIA = 10
komunikat: .ascii "W systemie 7-kowym nie ma takich znakow\n"
komunikat_len = .-komunikat
 
.bss
# alokacja miejsc w pamięci
.comm textin, 512 # bufor do którego zostanie
                  # wczytany ciąg od użytkownika
.comm textinv, 512 # bufor do którego zostanie
                   # zapisany wynik w odwrotnej kolejności
.comm textout, 512 # bufor wynikowy do którego przepisana
                   # zostanie zawartość bufora textinv
                   # w odwrotnej kolejności
 
.text
.globl _start
 
 
 
# WCZYTANIE LICZBY OD UŻYTKOWNIKA
_start:
mov $SYSREAD, %rax
mov $STDIN, %rdi
mov $textin, %rsi
mov $BUFLEN, %rdx
syscall
 
 
 
# ODCZYT Z KODU ASCII DO LICZBY W REJESTRZE
 
mov %rax, %rdi  # licznik do pętli (będzie liczył od końca)
sub $2, %rdi    # /n nas nie interesuje i liczymy od 0, a nie 1
mov $1, %rsi    # kolejne potęgi 7 (na razie 1)
mov $0, %r8     # miejsce na wynik globalny (na razie 0)
jmp petla
 
petla:
# wyskok z pętli jeśli RDI jest mniejsze od 0
cmp $0, %rdi
jl przed_petla2
mov $0, %rax               # wyzerowanie RAX
mov textin(, %rdi, 1), %al # odczyt litery do AL
sub $POCZATEK_LICZB, %al   # od teraz w AL jest liczba
 
# jeśli po odjęciu od kodu znaku kodu początku liczb,
# wartość będzie >= podstawie systemu wejściowego (7-kowego)
# lub <=0, nastąpi przeskok do etykiety blad
cmp $PODSTAWA_WEJSCIA, %al
jge blad
 
cmp $0, %al
jl blad
 
mul %rsi      # pomnożenie RAX przez obecną potęgę 7-ki (RSI)
add %rax, %r8 # dodanie obecnego wyniku (RAX/AL)
              # do globalnego (R8)
 
# pomnożenie obecnej potęgi 7 (RSI) przez 7 ($PODSTAWA_WE)
# mul wymaga umieszczenia mnożnej w rejestrze RAX
# i nie pozwala na mnożenie przez zmienną ($PODSTAWA_WE -> RBX)
mov %rsi, %rax
mov $PODSTAWA_WEJSCIA, %rbx
mul %rbx
mov %rax, %rsi
 
# zmniejszenie RDI i powrót na początek
dec %rdi
jmp petla
 
 
 
# ZAPIS LICZBY Z REJESTRU DO KODU ASCII W BUFORZE
przed_petla2:
mov %r8, %rax # skopiowanie zdekodowanej liczby do rejestru RAX
mov $PODSTAWA_WYJSCIA, %rbx
mov $0, %rcx
jmp petla2
 
petla2:
mov $0, %rdx
div %rbx
# dzielenie bez znaku liczby z rejestru RAX przez RBX
# i zapis wyniku do RAX oraz reszty z dzielenie do RDX.
# reszta z dzielenia to przy każdej iteracji pętli kolejna
# pozycja wyniku. po dodaniu kodu znaku pierwszej liczby,
# są to kody znaków ASCII liczb na kolejnych pozycjach.
add $POCZATEK_LICZB, %rdx
# zapis znaków do bufora w odwrotnej kolejności
mov %dl, textinv(, %rcx, 1)
 
# zwiększenie licznika i w kolejnych iteracjach powrót
# na początek pętli, aż do uzyskania zerowego wyniku dzielenia
inc %rcx
cmp $0, %rax
jne petla2
jmp przed_petla3
 
 
 
# ODWRÓCENIE KOLEJNOŚCI
# po wykonaniu ostatniego kroku, liczby zapisane są w buforze
# w odwrotnej kolejności, w tej pętli są przepisywane z końca
# na początek do nowego bufora textout.
przed_petla3:
mov $0, %rdi
mov %rcx, %rsi
dec %rsi
jmp petla3
 
petla3:
mov textinv(, %rsi, 1), %rax
mov %rax, textout(, %rdi, 1)
 
inc %rdi
dec %rsi
cmp %rcx, %rdi
jle petla3
jmp wyswietl
 
 
 
# WYŚWIETLENIE WYNIKU
wyswietl:
# dopisanie na końcu bufora wyjściowego znaku nowej linii
movb $NOWA_LINIA, textout(, %rcx, 1)
inc %rcx
 
# wyświetlenie tekstu z bufora textout
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $textout, %rsi
mov %rcx, %rdx
syscall
 
# zwrot zera na wyjściu programu
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
 
 
 
# WYŚWIETLENIE KOMUNIKATU BŁĘDU
blad:
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $komunikat, %rsi
mov $komunikat_len, %rdx
syscall
 
# zwrot zera na wyjściu programu
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
