#include <stdio.h>
#include <string.h>

/* gcc radixsort.c -o radixsort && ./radixsort */

#define SEQUENCE_LENGTH 10

void print_sequence(int *seq) {
	int i;
	printf("%d", seq[0]);
	for (i = 1; i < SEQUENCE_LENGTH; i++)
	    printf("-%d", seq[i]);
	printf("\n");
}

void print_before_message() {
	printf("Before sorting the array:\n");
}

void print_after_message() {
	printf("After sorting the array:\n");
}

int largest_number_in_sequence(int *seq) {
    int i;
    int largest = -1;
    for (i = 0; i < SEQUENCE_LENGTH; i++) {
	if (seq[i] > largest) {
	    largest = seq[i];
	}
    }
    return largest;
}

int how_many_digits_in_number(int num) {
    /* 32 bit int has max 11 digits */
    char num_as_str[11];
    snprintf(num_as_str, 11, "%d", num);
    return strlen(num_as_str);
}

int get_nth_digit(int num, int n) {
    /* 32 bit int has max 11 digits */
    char num_as_str[11];
    snprintf(num_as_str, 11, "%d", num);
    return num_as_str[n] - '0';
}

void zero_out_bucket(int (*bucket)[SEQUENCE_LENGTH]) {
    int i, j;
    for (i = 0; i < 10; i++) {
        for (j = 0; j < SEQUENCE_LENGTH; j++) {
    	    bucket[i][j] = -1;
        }
    }
}

void populate_bucket(int digit, int *seq, int (*bucket)[SEQUENCE_LENGTH]) {
    int i, j, size;
    for (i = 0; i < 10; i++) {
	for (j = 0; j < SEQUENCE_LENGTH; j++) {
	    if (i == get_nth_digit(seq[j], digit)) {
		bucket[i][j] = seq[j];
	    }
	}
    }
}

void restore_bucket_to_seq(int *seq, int (*bucket)[SEQUENCE_LENGTH]) {
    int i, j, h;
    h = 0;
    for (i = 0; i < 10; i++) {
        for (j = 0; j < SEQUENCE_LENGTH; j++) {
	    if (bucket[i][j] != -1) {
	        seq[h] = bucket[i][j];
	        h++;
	    }
        }
    }
}

void radix_sort(int *seq) {
	int i, j, h;
	int bucket[10][SEQUENCE_LENGTH];
	int largest;
	int n_digits;

	largest = largest_number_in_sequence(seq);
	n_digits = how_many_digits_in_number(largest);

	for (i = (n_digits - 1); i >= 0; i--) {
  	    zero_out_bucket(bucket);
 	    populate_bucket(i, seq, bucket);
	    restore_bucket_to_seq(seq, bucket);
	    printf("Sequence after sorting %dth digit\n", i);
	    print_sequence(seq);
	}
}

int main() {
	/* integers all must have the same amount of digits */
	int seq[SEQUENCE_LENGTH] = {7325, 1334, 4432, 5991, 1324, 8421, 5838, 3492, 6539, 3591};

	print_before_message();
	print_sequence(seq);

	radix_sort(seq);

	print_after_message();
	print_sequence(seq);
}
