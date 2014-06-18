/* Kasperek Wojciech (wukat) */

#include <stdio.h>
extern long find_character(char *s, long c, char ** first_occ, char ** last_occ);

int main() {
	char * string = "alabak";
	long c = 'a';
	char *first_occ = NULL, *last_occ = NULL;

	printf("Sign %c occ: %ld times\n", (char) c,   find_character(string, c, &first_occ, &last_occ));
	if (first_occ != NULL)
		printf("%s\n", first_occ);
	if (last_occ != NULL)
		printf("%s\n", last_occ);
	return 0;
}