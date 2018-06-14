#include <stdio.h>

extern int sprawdz();
extern int ustaw(int wybrany_tryb);

int main(void)
{
    int opcja = -1;
    int wybrany_tryb = -1;
    
    
    while(opcja != 0){
        printf("Wybierz: \n");
        printf("-- 1 -- Aby wybrac sprawdzic aktualnego trybu zaokraglania\n");
        printf("-- 2 -- Aby wybrac zmiane aktualnego trybu zaokraglania\n");
        printf("-- 0 -- Aby wyjsc z programu\n");
        scanf("%d", &opcja);

        switch(opcja){
            case 1:
                printf("\nUstawiony tryb zaokraglania: ");
            
                switch(sprawdz()){                    
                    case 0:
                        printf("round to nearest\n \n");
                        break;
                    case 1:
                        printf("round down \n \n");
                        break;
                    case 2:
                        printf("round up \n \n");
                        break;
                    case 3:
                        printf("round toward zero\n \n");
                        break;
                    default:
                        break;
                }
                break;
            case 2:
                printf("\n Wybierz tryb zaokraglania: \n");
                printf("-- 0 -- round to nearest\n");
                printf("-- 1 -- round down \n");
                printf("-- 2 -- round up \n");
                printf("-- 3 -- round toward zero\n");
                
                scanf("%d", &wybrany_tryb);
                if(wybrany_tryb < 0 || wybrany_tryb > 3)
                {
                    printf("Wybrano niepoprawny tryb");
                }
                else
                {
                    ustaw(wybrany_tryb);
                    printf("\nUstawiono tryb: %d\n\n", wybrany_tryb);
                }
                break;
            case 0:
                return 0;
        }
    }
    return 0;
}
