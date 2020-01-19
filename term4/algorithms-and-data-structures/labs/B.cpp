#include <cstdio>
#include <utility>
#include <vector>
#include <map>
#include <algorithm>

class Digraph {
private:
	using Node = std::pair<int, int>;
	using Edge = std::pair<Node, Node>;
	
	std::vector<Edge> edges;
	std::map<Node, int> paths;

public:
	Digraph(int edges_count)
	{
		edges.resize(edges_count);
	}

	void loadEdges()
	{
		Node from, to;
		for (auto&& edge : edges) {
			scanf("%d %d", &from.first, &from.second);
			scanf("%d %d", &to.first, &to.second);
			edge = Edge(from, to);
		}
	}

	void topoSort()
	{
		std::sort(edges.begin(), edges.end());
	}

	void countPathsMod(int mod)
	{
		paths[edges[0].first] = 1;

		Node from, to;
		for (auto edge : edges) {
			from = edge.first;
			to = edge.second;

			if (paths.find(from) == paths.end()) paths[from] = 0;
			if (paths.find(to) == paths.end()) paths[to] = 0;

			paths[to] = (paths[to] + paths[from]) % mod;
		}
	}

	int getPathsCountAtNode(int y, int x)
	{
		return paths[Node(y, x)];
	}
};


int main()
{
	int height, width, edges_count;
	const int MOD = 999979;
	scanf("%d %d %d", &height, &width, &edges_count);

	Digraph dg = Digraph(edges_count);

	dg.loadEdges();
	dg.topoSort();
	dg.countPathsMod(MOD);
	
	printf("%d\n", dg.getPathsCountAtNode(height, width));

	return 0;
}
