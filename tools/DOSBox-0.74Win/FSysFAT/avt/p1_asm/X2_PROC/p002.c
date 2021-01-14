#include <malloc.h>

void addv(short int*, short int, short int*);
void interschimb1(short int*, short int*);

void main() {
	short int n = 4;
	short int vector[4];
	short int* w;

	short int suma = 0;

	short int x1 = 9;
	short int x2 = -2;

	vector[0]=23;
	vector[1]=16;
	vector[2]=35;
	vector[3]=12;

	w = (short int*)malloc(3*sizeof(short int));
	w[0] = 10;
	w[1] = 11;
	w[2] = 12;

	addv(&suma, n, vector);
	interschimb1(&x1, &x2);
}

void interschimb1(short int* a, short int* b) {
	short int aux;
	aux = *a;
	*a = *b;
	*b = aux;
}

void addv(short int* s, short int dim, short int* v){
	short int i = 0;
	short int sum = 0;
	for(i = 0; i<dim; i+=1) sum += v[i];
	*s = sum;
}
