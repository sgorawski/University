#include <cstdio>
#include <climits>
#include <vector>
#include <queue>


class Graph {
private:
	class Edge {
	public:
		int to;
		int cost;

		Edge(int to, int cost) {
			this->to = to;
			this->cost = cost;
		}

		bool operator<(const Edge& rhs) const {
			return cost < rhs.cost;
		}
	};

	std::vector<std::vector<Edge>> adjacency_list;
	std::vector<int> distances;

public:
	Graph(int nodes_count) {
		adjacency_list.resize(nodes_count + 1);
		distances.resize(nodes_count + 1);
	}

	void addEdge(int node1, int node2, int cost) {
		adjacency_list[node1].emplace_back(node2, cost);
		adjacency_list[node2].emplace_back(node1, cost);
	}

	void dijkstra() {
		for (auto&& dist : distances)
			dist = INT_MAX;
		distances[1] = 0;

		std::priority_queue<Edge> nodes_to_process;
		nodes_to_process.emplace(1, 0);

		int current_node, to, cost;
		while (!nodes_to_process.empty()) {
			current_node = nodes_to_process.top().to;
			nodes_to_process.pop();

			for (auto adjacent_edge : adjacency_list[current_node]) {
				to = adjacent_edge.to;
				cost = adjacent_edge.cost;
				if (distances[to] > distances[current_node] + cost) {
					distances[to] = distances[current_node] + cost;
					nodes_to_process.emplace(to, distances[to]);
				}
			}
		}
	}

	void printDistances() {
		for (auto it = distances.begin() + 2; it != distances.end(); ++it)
			printf("%d ", *it);
		printf("\n");
	}
};


int main() {
	int nodes_count, edges_count;
	scanf("%d %d", &nodes_count, &edges_count);
	Graph g(nodes_count);

	int node1, node2, cost;
	while (edges_count--) {
		scanf("%d %d %d", &node1, &node2, &cost);
		g.addEdge(node1, node2, cost);
	}

	g.dijkstra();
	g.printDistances();

	return 0;
}
