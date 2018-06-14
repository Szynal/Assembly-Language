Data:
	.data	

    SYSREAD = 0			# nr funkcji wejscia - odczyt
    SYSWRITE = 1		# nr funkcji wyjscia - zapis 
    SYSEXIT = 60		# nr funkcji zakonczenia i zwrotu sterowania do SO
    STDOUT = 1			# nr wyjscia stadardowego (ekran tekstowy)
    STDIN = 0			# nr wejscia standardowego (klawiatura)
    EXIT_SUCCESS = 0
    BUFLEN = 512		# Dłogosc stringow
    BASIC_OF_EXIT = 10  # Podstawa wyjscia
    NUMBERS = 0x30      # poczatek liczb w ascii
    NEW_LINE = 0xA

    N = 3

    zad1_info: .ascii "Podaj ciag znakow:\n"	
    zad1_info_len = .-zad1_info					

	error_message: .ascii "ERROR\n"
	error_message_len = .-error_message 
# _______________________________________________________________________________________
Basic_Service_Set:
	.bss		
    .comm number, 512
	.comm textin, 512
    .comm textout, 512
    .comm textinv, 512 # bufor wykorzystywany do zamiany liczb
# _______________________________________________________________________________________

.text				# Sekcja tekstowa (kod programu)
.globl _start		# punkt wejscia programu

_start:				# start programu

    show_zad1_info:                 # Wypisz string'a:
        movq $SYSWRITE, %rax		# przeniesienie wartosci z SYSWRITE do rejestru rax
        movq $STDOUT, %rdi	    	# systemowe stdout
        movq $zad1_info, %rsi	   	# kopiowanie wartosci stringa do rejestru źródłowego
        movq $zad1_info_len, %rdx	# kopiowanie dlugosci stringa do rejstru danych
    syscall			            	# wywolanie funkcji systemowych
    break:
    # Wczytywanie wpisanego tekstu
        movq $SYSREAD, %rax		# kopiowanie z wartosci funkcji wejscia do rejstru akumulatora
        movq $STDIN, %rdi		# dostep do wpisanego tekstu
        movq $textin, %rsi		# poczatek wpisanego tekstu
        movq $BUFLEN, %rdx		# koniec wpisanego tekstu
    syscall

    save_textin_len:
        xor %r9, %r9
        mov %rax, %r9
        dec %r9         # usuwanie '\n'

    push %r9        # przekazanie argumentu funkcji
    call _zad1      # Wywolanie funkcji _zad1 (Wynik znajduje sie w RAX)
    add $16, %rsp   # Usuniecie parametrow ze stosu
    break2:
    display_result:
      
        mov $0, %r8 # Licznik pętli 
 
        display_result_loop:
                  
            decoding_number:      
                mov $10, %rbx
                mov $0, %rcx
        
            get_inverted_number:
                mov $0, %rdx
                div %rbx                    # Dzielenie bez znaku liczby z rejestru RAX przez RBX i zapis do RAX (reszta do RDX )
                add $NUMBERS, %rdx          # poczatek liczb w ascii
                mov %dl, textinv(, %rcx, 1) #  Zapis znaków do bufora w odwrotnej kolejności
                inc %rcx
                cmp $0, %rax                # czy uzyskalismy zero z dzielenia 
                jne get_inverted_number
            #   cyfry zapisane są w buforze # w odwrotnej kolejności !!!
                    
                #
                # ODWRÓCENIE KOLEJNOŚCI CYFR
                #
            xor %rdi, %rdi
            mov %rcx, %rsi
            dec %rsi
                
                get_correct_number:
                    mov textinv(, %rsi, 1), %rax
                    mov %rax, textout(, %rdi, 1)
                    
                    inc %rdi
                    dec %rsi
                    cmp %rcx, %rdi
                    jle get_correct_number
                       
                # Dopisanie na końcu bufora wyjściowego znaku nowej linii
                movb $NEW_LINE, textout(, %rcx, 1)
                inc %rcx
                
            # Wyświetlenie tekstu z bufora textout
            mov $SYSWRITE, %rax
            mov $STDOUT, %rdi
            mov $textout, %rsi
            mov %rcx, %rdx
    syscall
        


    jmp exit

    error:
        movq $SYSWRITE, %rax			# przeniesienie wartosci z SYSWRITE do rejestru rax
        movq $STDOUT, %rdi				# systemowe stdout
        movq $error_message, %rsi		# wyswietlanie tekstu
        movq $error_message_len, %rdx	# kopiowanie dlugosci stringa do rejstru danych
    syscall	

    exit:
        movq $SYSEXIT, %rax			# wykonanie funkcji EXIT
        movq $EXIT_SUCCESS, %rdi	# Wrzucenie do rejestru kodu wyjscia z programu
    syscall							# zwraca kod bledu w %rdi
#_______________________________________________________________________________________


_zad1:
    
    push %rbp       # Umieszczanie na stosie poprzedniej wartosci z rejestru bazowego
    mov %rsp, %rbp  # pobieranie zawartosci pamieci spod adresu w rsp (wskaznik na ostatni element znajdujacy sie na stosie)

    sub $8, %rsp        # powiekszanie wskaznik stotsu o jedna komorke
    mov 16(%rbp), %rsi  # Pobieranie pierwszego argumetnu (rsi -> koniec naszego wpisanego ciagu znakow)
    //czyszczenie rejestrow
    xor %rdi, %rdi
    xor %r9, %r9
    xor %r10, %r10    # przechowuje licznik

    mov $1, %rax
    neg %rax          #  -1 potrzebna na zwracania bledu funkcji 

    zad1_loop:

        mov textin(, %rdi, 1), %bl     # Pobieranie pierwszego znaku z naszego bufora 
        sub $'0', %rbx                 # Dekodowanie kodu ascii
        cmp $0, %rbx                   # Czy to jest 0
        jnz look_further               # Szukaj dalej jesli nie masz zera,
        cmp $0, %r9
        jnz counter
        mov %rdi, %rdx          # Od teraz rdx przechowuje indeks ciagu znakow

        counter:                # Udalo nam sie znalezc 0
            inc %r9             # Inkrementuj r9
                       
            cmp %r9, %r10       # Czy badany ciag zer jest wiekszy od poprzeniego
            jge loop_step       # Jesli r9 jest wieksze badz rowne do r10
            mov %r9, %r10       # Przeniesienie wartosci r9 do r10
            mov %rdx, %rax      # od teraz rax przechowuje indeks
            jmp loop_step

        look_further:           # Nie ma zera... Szukaj dalej
            xor %r9, %r9        # Czyszczenie rejestru r9

        loop_step:              # 
            inc %rdi            # Inkrementacja wskaznika/ iteracja petli
            cmp %rsi, %rdi      # Czy koniec wpisanego ciagu znakow
            jl zad1_loop
     #Zakonczenie wykonywania funkcji i zwrot wartosci
    mov %rbp, %rsp
    pop %rbp
ret

