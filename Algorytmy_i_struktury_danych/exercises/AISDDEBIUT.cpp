// Slawomir Gorawski
// 288653
// KPI

#include <cstdio>

int main()
{
	unsigned long long a, b;
	scanf("%lld %lld", &a, &b);

	for (
		unsigned long long mult = ((a + 2017) / 2018) * 2018;
		mult <= b;
		mult += 2018
	) {
		printf("%lld ", mult);
	}

	return 0;
}
