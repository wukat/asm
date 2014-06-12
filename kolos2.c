/* Kasperek Wojciech */

#include <stdio.h>
extern char * order_of(long a, long b, long c, long d);
/* ma zwrocic wskaznik do napisu zawierajacego kolejnosc uporzadkowania np. 1234 */

int main() {
	printf("%s", order_of(50, 30, 70, 90));
}

