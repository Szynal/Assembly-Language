#include "/home/robert/labyak/lab7/rdtsc.h"
#include <stdio.h>
#include <math.h>

    int v1[9] = {10, 20, 30, 40, 50, 60, 70, 80, 90};
    int v2[9] = {100, 120, 130, 140, 150, 160, 170, 180, 190};
    int v3;


void Func()
{   
    for(int i = 0; i < 9; i++){
        v3 += v1[i] + v2[i];
    }
}

int main(void)
{
    unsigned long long a,b;

    a = rdtsc();
    Func();
    b = rdtsc();

    printf("Czas wykonania funkcji: %llu\n", b-a);
    printf("%d ",v3);
    printf("\n");
    return 0;
}
