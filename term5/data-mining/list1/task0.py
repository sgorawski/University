import numpy as np

a = np.arange(1, 101)
b = np.arange(1, 101, 2)
c = np.linspace(-1, 1, num=201) * np.pi
d = c[c != 0]
e_ = np.sin(np.arange(1, 101))
e = np.where(e_ > 0, e_, 0)
A = np.arange(1, 101).reshape(10, 10)
B = np.diag(np.arange(1, 101)) + np.diag(np.arange(99, 0, -1), k=1) + np.diag(np.arange(99, 0, -1), k=-1)
C = np.triu(np.ones(10))
D = np.vstack((np.cumsum(a), np.cumprod(a)))
E = np.where(np.atleast_2d(np.arange(1, 11)) % np.atleast_2d(np.arange(1, 11)).T > 0, 1, 0)