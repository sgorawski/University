function res = nearest(X, Y)
  dists = all_dists(X, Y);
  [_, res] = min(dists');
endfunction
