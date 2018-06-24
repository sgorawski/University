#include <cstdio>
#include <stack>

#define NONE 0


class Tree {
private:
	struct Node {
		int left_child;
		int right_sibling;
	};
	Node *nodes;
	int *pre_order;
	int *post_order;

public:
	Tree(int nodes_count) {
		nodes = new Node[nodes_count + 1];
		for (auto i = 0; i <= nodes_count; i++)
			nodes[i] = {NONE, NONE};
		pre_order = new int[nodes_count + 1]();
		post_order = new int[nodes_count + 1]();
	}

	~Tree() {
		delete[] nodes;
		delete[] pre_order;
		delete[] post_order;
	}

	void insertNode(int node, int parent) {
		int prev_child = nodes[parent].left_child;
		nodes[parent].left_child = node;
		nodes[node].right_sibling = prev_child;
	}

	void dfs() {
		int current, next;
		int pre_counter = 1;
		int post_counter = 1;
		std::stack<int> to_visit;
		to_visit.push(1);
		while (!to_visit.empty()) {
			current = to_visit.top();
			to_visit.pop();
			if (post_order[current])
				continue;
			if (pre_order[current])
				post_order[current] = post_counter++;
			else {
				to_visit.push(current);
				pre_order[current] = pre_counter++;
				next = nodes[current].left_child;
				while (next != NONE) {
					to_visit.push(next);
					next = nodes[next].right_sibling;
				}
			}
		}
	}

	bool isAncestor(int node1, int node2) {
		return (pre_order[node1] < pre_order[node2] &&
				post_order[node1] > post_order[node2]);
	}
};


int main() {
	int nodes_count, queries_count, parent;
	scanf("%d %d", &nodes_count, &queries_count);
	Tree tree = Tree(nodes_count);

	for (auto i = 2; i <= nodes_count; i++) {
		scanf("%d", &parent);
		tree.insertNode(i, parent);
	}
	tree.dfs();

	int node1, node2;
	while (queries_count--) {
		scanf("%d %d", &node1, &node2);
		printf("%s\n", tree.isAncestor(node1, node2) ? "TAK" : "NIE");
	}

	return 0;
}
