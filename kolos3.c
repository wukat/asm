/* Kasperek Wojciech (wukat) */

#include <stdio.h>
extern long histo_sum(long* h, long n, long* hs, long normalize);

int main() {
	long h[10] = {1,2,3,4,5,6,7,8,9,10}, hs[10];
	long n = 10;
	int i = 0, j;

	for (i = 0; i < n; i++) {
		hs[i] = 0;
	}
	printf("Sum: %ld\n", histo_sum(h, n, hs, 0)); /* without normalization */

	for (i = 0; i < n; i++) {
		for (j = 0; j < i; j++) {
			printf("%ld + ", h[j]);
		}
		printf("%ld = %ld \n", h[i], hs[i]);
	}

	for (i = 0; i < n; i++) {
		hs[i] = 0;
	}
	printf("Sum: %ld\n", histo_sum(h, n, hs, 1));

	for (i = 0; i < n; i++) {
		for (j = 0; j < i; j++) {
			printf("%ld + ", h[j]);
		}
		printf("%ld = %ld \n", h[i], hs[i]);
	}
}