#include <cstdio>
#include <array>

using Matrix = std::array<std::array<long long, 2>, 2>;

Matrix mtxMultMod(Matrix a, Matrix b, int m)
{
	Matrix res;
	res[0][0] = (a[0][0]*b[0][0] + a[0][1]*b[1][0]) % m;
	res[0][1] = (a[0][0]*b[0][1] + a[0][1]*b[1][1]) % m;
	res[1][0] = (a[1][0]*b[0][0] + a[1][1]*b[1][0]) % m;
	res[1][1] = (a[1][0]*b[0][1] + a[1][1]*b[1][1]) % m;
	return res;
}

Matrix fastMtxPowMod(Matrix a, int exp, int m)
{
	if (exp == 0) {
		return {{{1, 0}, {0, 1}}};
	}
	Matrix x = fastMtxPowMod(a, exp/2, m);
	x = mtxMultMod(x, x, m);
	return exp % 2 == 0 ? x : mtxMultMod(a, x, m);
}

int fibMod(int n, int m)
{
	Matrix fib_mtx = {{{1, 1}, {1, 0}}};
	fib_mtx = fastMtxPowMod(fib_mtx, n - 1, m);
	return fib_mtx[0][0];
}

int main()
{
	int t;
	scanf("%d", &t);

	int n, m;
	while (t--) {
		scanf("%d %d", &n, &m);
		printf("%d\n", fibMod(n, m));
	}

	return 0;
}
