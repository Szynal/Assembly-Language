#include <stdio.h>

// Deklaracja funkcji która zostanie dołączona
// dopiero na etapie linkowania kodu
extern double taylor(double a, int b);

int main(void)
{
    int i;
    double f;
    printf("Podaj X: ");
    scanf("%lf", &f);
    printf("Liczba kroków: ");
    scanf("%d", &i);
    printf("Twoj wynik to: %lf\n", taylor(f, i));
    return 0;
}
