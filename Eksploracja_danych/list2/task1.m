% a

d = 100;

x = randi(20, d, 1);
y = randi(20, d, 1);
w = randi(20, d, 1);

x_len = sqrt(x' * x);
x_w_mean = w' * x / d;
x_y_dist = sqrt((x - y)' * (x - y));
x_y_dot = x' * y;

% b

N = 1000;

X = randi(20, d, N);

X_lens = ones(1, d) * (X .^ 2);
X_w_means = w' * X / d;
X_y_dists = sqrt(ones(1, d) * ((X - y) .^ 2));
X_y_dots = y' * X;
