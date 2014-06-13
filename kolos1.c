/* Kasperek Wojciech */

#include <stdio.h>
extern long digits_count(char *buf, long *digits, long *max_digit);

int main() {
	long a[10];
	long mostOften;
	int i;
	char * tekst = "09342344";
	for (i = 0; i < 10; i++) {
		a[i] = 0;
	}

	printf( "Number of digits occurances: %ld \n", digits_count(tekst, a, &mostOften));
	printf("Most common digit: %ld \n", mostOften);
	for (i = 0; i < 10; i++) {
		printf("%d %ld\n", i, a[i]);
	}
}