#include <cstdio>
#include <cstdlib>
#include <exception>

class NotFound : std::exception { } nf;

const int MAX_NODES_COUNT = 50000;

// solution

struct Node {
	long long key;
	int priority;
	Node* left;
	Node* right;

	Node(long long key);
};

class Treap {
public:
	Treap();
	~Treap();
	void insert(long long key);
	void remove(long long key);
	long long upper(long long key);
	long long lower(long long key);

private:
	Node* root;

	static Node* insert(long long key, Node* root);
	static Node* remove(long long key, Node* root);
	static Node* upper(long long key, Node* root, Node* upper_node);
	static Node* lower(long long key, Node* root, Node* lower_node);
	static Node* rotateLeft(Node*);
	static Node* rotateRight(Node*);
	static void deleteSubtree(Node* root);
};

int main()
{
	srand(69);

	int operations_count = 0;
	scanf("%d%*c", &operations_count);

	Treap bst = Treap();

	char operation;
	long long key, found_key;
	while (operations_count--) {
		scanf("%c %lld%*c", &operation, &key);
		switch (operation) {
			case 'I':
				bst.insert(key);
				break;
			case 'D':
				try {
					bst.remove(key);
					printf("OK\n");
				}
				catch (NotFound) {
					printf("BRAK\n");
				}
				break;
			case 'U':
				try {
					found_key = bst.upper(key);
					printf("%lld\n", found_key);
				}
				catch (NotFound) {
					printf("BRAK\n");
				}
				break;
			case 'L':
				try {
					found_key = bst.lower(key);
					printf("%lld\n", found_key);
				}
				catch (NotFound) {
					printf("BRAK\n");
				}
		}
	}

	return 0;
}

// Treap implementation

Node::Node(long long key)
{
	this->key = key;
	priority = rand() % MAX_NODES_COUNT;
	left = nullptr;
	right = nullptr;
}

Treap::Treap()
{
	root = nullptr;
}

Treap::~Treap()
{
	deleteSubtree(root);
}

void Treap::insert(long long key)
{
	root = insert(key, root);
}

void Treap::remove(long long key)
{
	root = remove(key, root);
}

long long Treap::upper(long long key)
{
	auto found_node = upper(key, root, nullptr);
	if (!found_node)
		throw nf;
	return found_node->key;
}

long long Treap::lower(long long key)
{
	auto found_node = lower(key, root, nullptr);
	if (!found_node)
		throw nf;
	return found_node->key;
}

Node* Treap::insert(long long key, Node* root)
{
	if (!root)
		return new Node(key);
	if (root->key == key)					// no duplicates
		return root;
	
	if (root->key > key) {
		root->left = insert(key, root->left);
		if (root->left->priority > root->priority)	// restore heap ordering
			root = rotateRight(root);
	}
	else {
		root->right = insert(key, root->right);
		if (root->right->priority > root->priority)
			root = rotateLeft(root);
	}

	return root;
}

Node* Treap::remove(long long key, Node* root)
{
	if (!root)								// key not found
		throw nf;
	
	if (root->key > key)
		root->left = remove(key, root->left);
	else if (root->key < key)
		root->right = remove(key, root->right);
	else {
		auto temp = root;
		if (!root->left) {						// no left child
			root = root->right;
			delete temp;
		}
		else if (!root->right) {					// no right child
			root = root->left;
			delete temp;
		}
		else if (root->left->priority > root->right->priority) {	// both children
			root = rotateRight(root);
			root->right = remove(key, root->right);
		}
		else {								// both children, case 2
			root = rotateLeft(root);
			root->left = remove(key, root->left);
		}
	}

	return root;
}

Node* Treap::upper(long long key, Node* root, Node* upper_node)
{
	if (!root)					// no upper key found
		return upper_node;
	if (root->key == key)
		return root;
	if (root->key < key)				// search right subtree
		return upper(key, root->right, upper_node);
	return upper(key, root->left, root);		// else search left subtree
}

Node* Treap::lower(long long key, Node* root, Node* lower_node)
{
	if (!root)					// implementation symmetrical to Treap::upper
		return lower_node;
	if (root->key == key)
		return root;
	if (root->key > key)
		return lower(key, root->left, lower_node);
	return lower(key, root->right, root);
}

Node* Treap::rotateLeft(Node* x)
{
	auto y = x->right;
	x->right = y->left;
	y->left = x;
	return y;
}

Node* Treap::rotateRight(Node* x)
{
	auto y = x->left;
	x->left = y->right;
	y->right = x;
	return y;
}

void Treap::deleteSubtree(Node* root)
{
	if (!root)
		return;
	deleteSubtree(root->left);
	deleteSubtree(root->right);
	delete root;
}
