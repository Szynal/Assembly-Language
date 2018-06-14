.data
silnia: .double 0.0

.text
# Zadeklarowana tutaj funkcja będzie możliwa do wykorzystania
# w języku C po zlinkowaniu plików wynikowych kompilacji obu kodów
.global taylor
.type taylor, @function

# Funkcja obliczająca przybliżenie wartości sinusa
# z szeregu Taylora
taylor:
    push    %rbp
    mov     %rsp, %rbp

    # Przyjmowane przez funkcje argumenty:
    # RDI - ilość kroków
    # XMM0 - liczba X

    # Załadowanie wartości z rejestru XMM0
    # do rejestrów ST(0), ST(1) i ST(2) przez stos
    sub     $8, %rsp
    movsd   %xmm0, (%rsp)
    fldl    (%rsp)  
    fld1
    fld1

    # Zawartość rejestrów FPU obecnie, na początku i końcu pętli
    # ST(0) - 1 (wyraz ciągu)
    # ST(1) - 1 (suma ciągu)
    # ST(2) - przesłany liczba (x)

    movq    $0, %rsi # Licznik do pętli
    fwait   # Oczekiwanie na zakończenie wykonywanych przez
            # FPU obliczeń

    

    petla:
        # Wyskok z pętli po obliczeniu wszystkich wyrazów
        cmp     %rdi, %rsi
        je      koniec
        inc     %rsi # Zwiększenie licznika wykonań pętli

        # Obliczenie wyrazu ciągu [x]
        fmul    %st(2), %st

        # *********************SILNIA*******************
        fld1
        fld1
        fldl    silnia # ST(0) -> ST(1)...;

    
        fadd    %st(2), %st
        fmul    %st, %st(1)
        fstpl   silnia    # Zapisanie numery ostatniego wyrazu
                        # silni do zmiennej i ściągnięcie go
                        # ze "stosu" FPU


        fxch    %st(1)
        fstp    %st


        fdivr   %st, %st(1)   # Dzielenie obecnego wyrazu przez silnie
        
        fstp    %st            # Usunięcie dzielnika ze stosu

        fadd    %st, %st(1)

        jmp petla # Powrót na początek pętli

    # Przeniesienie wyniku z rejestru ST(0) (sumy ciągu)
    # do rejestru XMM0 przez stos i zakończenie funkcji
    koniec:
    fstp    %st
    fstpl   (%rsp)
    movsd   (%rsp), %xmm0

mov     %rbp, %rsp
pop     %rbp
ret
