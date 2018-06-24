#include <stdio.h>
#include <stdlib.h>

void insert_sort(long *first, long *last);

int main(int argc, char **argv) {
  if (argc < 2)
    return EXIT_FAILURE;

  long *arr = malloc((argc - 1) * sizeof(long));
  for (int i = 1; i < argc; i++)
    arr[i - 1] = strtol(argv[i], NULL, 10);
  
  insert_sort(arr, arr + argc - 2);

  for (int i = 0; i <= argc - 2; i++)
    printf("%ld ", arr[i]);
  printf("\n");

  free(arr);
  return EXIT_SUCCESS;
}
