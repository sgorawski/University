#include <cstdio>
#include <vector>
#include <climits>

int main()
{
	int K, L;
	scanf("%d %d", &K, &L);
	std::vector<int> f(L);
	for (auto i = 0; i < L; i++) {
		scanf("%d", &f[i]);
	}

	std::vector<int> A(L + 1), B(L + 1);
	A[L] = B[L] = 0;
	for (auto i = L - 1; i >= 0; i--) {
		A[i] = f[i] + A[i + 1];
		B[i] = A[i] + B[i + 1];
	}

	auto S = [&](int a, int b) { return B[a] - B[b + 1] - (b - a + 1)*A[b + 1]; };

	std::vector<std::vector<int>> T(L + 1, std::vector<int>(K));
	std::vector<std::vector<int>> opts(L + 1, std::vector<int>(K, L));

	T[L][0] = 0;
	for (auto i = L - 1; i >= 0; i--) {
		T[i][0] = S(i, L - 1);
	}

	std::vector<int> ids(K);
	for (auto j = 1; j < K; j++) {
		for (auto i = L - j; i >= 0; i--) {
			int si;
			int cc;
			int cost = INT_MAX;

			for (auto s = i + 1; s <= L - j; s++) {
				cc = T[s][j - 1] + S(i, s - 1);
				if (cc < cost) {
					cost = cc;
					si = s;
				}
			}
			T[i][j] = cost;
			opts[i][j] = si;
		}

	}

	printf("%d\n", T[0][K - 1]);
	int i = 0;
	int prev_i;
	for (auto j = K - 1; j >= 0; j--) {
		prev_i = i;
		i = opts[i][j];
		printf("%d ", i - prev_i);
	}
	printf("\n");

	return 0;
}
