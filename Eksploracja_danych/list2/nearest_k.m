function res = nearest_k(X, Y, k)
  dists = all_dists(X, Y);
  [_, sorted_inds] = sort(dists');
  res = sorted_inds(1:k, :);
endfunction
