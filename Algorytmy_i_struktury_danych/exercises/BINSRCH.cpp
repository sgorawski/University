#include <cstdio>
#include <vector>

int binsearch(std::vector<int> vec, int start, int end, int x)
{
	if (start == end) {
		return (vec[start] >= x ? start : start + 1);
	}
	int half = (start + end) / 2;
	if (vec[half] < x) {
		return binsearch(vec, half + 1, end, x);
	}
	return binsearch(vec, start, half, x);
}

int main()
{
	int n;
	scanf("%d", &n);

	std::vector<int> values(n);
	for (auto&& val : values) {
		scanf("%d", &val);
	}

	int m, x;
	scanf("%d", &m);
	while (m--) {
		scanf("%d", &x);
		printf("%d\n", n - binsearch(values, 0, n - 1, x));
	}

	return 0;
}
