#include <cstdio>

int fastPowMod(int a, int b, int m)
{
	if (b == 0)
		return 1;
	long long x = fastPowMod(a, b/2, m);
	x = x*x % m;
	return (b % 2 == 0 ? x : a*x % m);
}

int main()
{
	int t;
	scanf("%d", &t);

	int a, b, m;
	while (t--) {
		scanf("%d %d %d", &a, &b, &m);
		printf("%d\n", fastPowMod(a, b, m));
	}

	return 0;
}
