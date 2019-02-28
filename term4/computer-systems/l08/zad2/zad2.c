#include <stdio.h>
#include <stdlib.h>

typedef struct {
  unsigned long lcm, gcd;
} result_t;

result_t lcm_gcd(unsigned long, unsigned long);

int main(int argc, char **argv) {
  if (argc < 3)
    return EXIT_FAILURE;

  unsigned long x = strtoul(argv[1], NULL, 10);
  unsigned long y = strtoul(argv[2], NULL, 10);
  result_t result = lcm_gcd(x, y);

  printf("LCM = %ld\nGCD = %ld\n", result.lcm, result.gcd);
  return EXIT_SUCCESS;
}
