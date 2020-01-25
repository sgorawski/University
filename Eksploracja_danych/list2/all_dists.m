function res = all_dists(X, Y)
  X = X';
  [N, d] = size(X);
  [dd, M] = size(Y);
  res = ones(N, d) * Y .^ 2;
  res += X .^ 2 * ones(d, M);
  res -= 2 * X * Y;
  res = sqrt(res);
endfunction
