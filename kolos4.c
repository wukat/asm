/* Kasperek Wojciech (wukat) */

#include <stdio.h>
extern long reverse_tab_arg(long * tab, long n, long * even_num_count);

int main() {
	long tab[11] = {1,2,3,4,5,6,7,8,9,10,11};
	long n = 11;
	long even_num_count = 0;
	int i = 0;

	printf("Average: %ld\n", reverse_tab_arg(tab, n, &even_num_count));
	printf("Number of even numbers: %ld\n", even_num_count);

	for (i = 0; i < n; i++) {
		printf("%ld ", tab[i]);
	}
}