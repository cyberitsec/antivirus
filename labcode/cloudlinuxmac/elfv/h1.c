// gcc h1.c -o h1
// ./h1

#include <stdio.h>
#define TP 100 

void f1();
void f2();
void f3();
void f4();
void f5();

int main()
{
    printf("\n Hello 1 from C host program... \n");
    for (int i = 0; i < 5; i++)
        printf("\tTP = %d", TP);

    f1();
    return 0;
}


void f1() {
    for (int i = 0; i < 10; i++)
        printf("\tf ->TP = %d", TP);

    f2();
}

void f2() {
    for (int i = 0; i < 10; i++)
        printf("\tf ->TP = %d", TP);
    
    f3();
}

void f3() {
    for (int i = 0; i < 10; i++)
        printf("\tf ->TP = %d", TP);
    f4();
}

void f4() {
    for (int i = 0; i < 10; i++)
        printf("\tf ->TP = %d", TP);
    f5();
}

void f5() {
    for (int i = 0; i < 10; i++)
        printf("\tf ->TP = %d", TP);
}

