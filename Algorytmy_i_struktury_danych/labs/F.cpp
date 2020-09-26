#include <cstdio>
#include <vector>
#include <utility>
#include <algorithm>
#include <set>

using Field = std::pair<int, int>;  // not a struct because sorting is easier on pairs

struct Element {
	int parent;
	int rank;

	Element() : parent(-1) { }
};

void unite(std::vector<Element> &elements, int x_root, int y_root);  // union really, but its C keyword
int find(std::vector<Element> &elements, int x);
void makeSet(std::vector<Element> &elements, int x);

int main()
{
	int n, m, T, h;

	scanf("%d %d", &n, &m);
	std::vector<int> heights(n * m);
	std::vector<Element> elements(n * m);
	std::vector<Field> height_to_index;
	height_to_index.reserve(n * m);

	// load fields

	for (auto i = 0; i < n * m; i++) {
		scanf("%d", &h);
		heights[i] = h;
		height_to_index.emplace_back(h, i);
	}
	// sort in desc order
	std::sort(height_to_index.begin(), height_to_index.end(), [](Field a, Field b) { return a > b; });

	// load days

	scanf("%d", &T);
	std::vector<int> days(T);
	std::vector<int> lands(T);
	for (auto i = 0; i < T; i++) {
		scanf("%d", &days[i]);
	}
	// process

	int day_index = T - 1, lands_count = 0;
	std::set<int> areas_around;
	for (auto field : height_to_index) {
		areas_around.clear();
		int height = field.first;
		int index = field.second;

		while (days[day_index] >= height) {
			lands[day_index] = lands_count;
			day_index--;
		}

		makeSet(elements, index);
		lands_count++;

		// check fields around
		if (index > 0 && (index - 1) % m != (m - 1)) {
			areas_around.insert(find(elements, index - 1));
		}
		if (index < n*m - 1 && (index + 1) % m != 0) {
			areas_around.insert(find(elements, index + 1));
		}
		if (index - m >= 0) {
			areas_around.insert(find(elements, index - m));
		}
		if (index + m < n * m) {
			areas_around.insert(find(elements, index + m));
		}

		// remove -1 from set if exists
		if (areas_around.find(-1) != areas_around.end()) {
			areas_around.erase(areas_around.begin());
		}

		// update lands count
		lands_count -= areas_around.size();

		// unite elements
		for (auto area : areas_around) {
			unite(elements, area, find(elements, index));
		}
	}

	// fill in remaining days

	while (day_index >= 0) {
		lands[day_index] = lands_count;
		day_index--;
	}

	for (auto l : lands) {
		printf("%d ", l);
	}
	printf("\n");

	return 0;
}

// Union-Find implementation

void unite(std::vector<Element> &elements, int x_root, int y_root)
{
	if (elements[x_root].rank > elements[y_root].rank) {
		elements[y_root].parent = x_root;
	} else if (elements[x_root].rank < elements[y_root].rank) {
		elements[x_root].parent = y_root;
	} else if (x_root != y_root) {
		elements[y_root].parent = x_root;
		elements[x_root].rank++;
	}
}

int find(std::vector<Element> &elements, int x)
{
	if (elements[x].parent == -1) {
		return -1;
	}
	if (elements[x].parent == x) {
		return x;
	}
	elements[x].parent = find(elements, elements[x].parent);
	return elements[x].parent;
}

void makeSet(std::vector<Element> &elements, int x)
{
	elements[x].parent = x;
	elements[x].rank = 0;
}
