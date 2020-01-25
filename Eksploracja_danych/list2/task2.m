d = 100;
N = 1000;
M = 1000;

X = randi(20, d, N);
Y = randi(20, d, M);

tic();
all_dists(X, Y);
toc();

N = 10000;

X = randi(20, d, N);
Y = randi(20, d, M);

tic();
all_dists(X, Y);
toc();
