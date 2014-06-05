//---------------------------------------------------------------
// Program lab_6b - Asemblery Laboratorium IS II rok
//
// To compile&link: gcc -o lab_6b lab_6b.c lab_6b_asm.s
// To run:          ./lab_6b
//
//---------------------------------------------------------------

#include <stdio.h>

int fib( unsigned int k )
{
	if( k == 0 )
		return 0;
	else if( k == 1 )
		return 1;
	else
		return fib( k - 2 ) + fib( k - 1 );
}

int fibi( unsigned int k )
{
	if (k == 1)
		return 1;
	int i = 1, old = 0, new = 1, sum = 0;
	for (i; i < k; i++) {
		sum = new + old;
		old = new;
		new = sum;
	}
	return sum;
}


void main( void )
{
 int i;

 for( i = 0; i <= 50; i++ )
   printf( "Fib( %2d ) = %d FibA= %d\n", i, fibi( i ), fibai( i ) );
}
