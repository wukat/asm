//---------------------------------------------------------------
// Program lab_6a - Asemblery Laboratorium IS II rok
//
// To compile&link: gcc -o lab_6a lab_6a.c lab_6a_asm.s
// To run:          ./lab_6a
//
//---------------------------------------------------------------

#include <stdio.h>

int fact( unsigned int k )
{
	if( k <= 1 )
		return 1;
	else
		return k * fact( k - 1 );
}

void main( void )
{
 int i;

 for( i = 1; i <= 6; i++ )
   printf( "Fact(%d) = %d FactA = %d\n", i, fact(i), facta(i) );
}
