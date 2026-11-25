#!/usr/bin/env python
"""Independent check of a smoothed CMIP7 BB file against its source.

Usage: verify_smooth.py SRC DST VAR [VAR ...]
Checks: (1) records before 1990 and non-smoothed variables are unchanged,
(2) spot values equal an independent 11-yr same-month mean, (3) 2024 == 2023,
(4) median grid-cell interannual variability 1980-96 vs 1997-2014.
"""
import sys
import numpy as np
import netCDF4 as nc

src, dst, vnames = sys.argv[1], sys.argv[2], sys.argv[3:]
a, b = nc.Dataset(src), nc.Dataset(dst)
date = a['date'][:].astype(int)
dsec = a['datesec'][:].astype(int) if 'datesec' in a.variables else np.full(date.shape, 43200)
y, m, d = date // 10000, (date // 100) % 100, date % 100
assert np.array_equal(date, b['date'][:].astype(int))
rng = np.random.default_rng(0)
ok = True

pre = np.where(y < 1990)[0]
for v in a.variables:
    if a[v].ndim < 3 or a[v].dimensions[0] != 'time':
        continue
    if v in vnames:
        # unchanged before 1990 (check a sample of records)
        ii = rng.choice(pre, 20, replace=False)
        same = all(np.array_equal(a[v][i], b[v][i]) for i in ii)
    else:
        ii = rng.choice(len(date), 10, replace=False)
        same = all(np.array_equal(a[v][i], b[v][i]) for i in ii)
    print(f'  {v:24s} unchanged where expected: {same}')
    ok &= same


def rep(Y, M):
    idx = np.where((y == Y) & (m == M) & (d == 15))[0]
    return idx[np.argmin(np.abs(dsec[idx] - 43200))]


for v in vnames:
    va, vb = a[v], b[v]
    nlev = va.shape[1]
    maxrel = 0.0
    for _ in range(25):
        Y, M = int(rng.integers(1990, 2024)), int(rng.integers(1, 13))
        k, j, i = int(rng.integers(nlev)), int(rng.integers(96)), int(rng.integers(144))
        yrs = [yy for yy in range(Y - 5, Y + 6) if 1985 <= yy <= 2023]
        expect = np.mean([float(va[rep(yy, M), k, j, i]) for yy in yrs])
        recs = np.where((y == Y) & (m == M))[0]          # all records in that month
        got = np.array([float(vb[r, k, j, i]) for r in recs])
        rel = np.abs(got - expect).max() / max(abs(expect), 1e-30)
        maxrel = max(maxrel, rel if expect != 0 else np.abs(got).max())
    print(f'  {v}: max rel error vs independent mean (25 spots, all sub-monthly recs): {maxrel:.2e}')
    ok &= maxrel < 1e-5
    i23 = [rep(2023, M) for M in range(1, 13)]
    i24 = [rep(2024, M) for M in range(1, 13)]
    pad = all(np.array_equal(vb[p], vb[q]) for p, q in zip(i23, i24))
    print(f'  {v}: 2024 equals 2023: {pad}')
    ok &= pad

    def annual(var):
        col = []
        for Y in range(1980, 2015):
            recs = [rep(Y, M) for M in range(1, 13)]
            col.append(np.mean([var[r].sum(0) for r in recs], axis=0))
        return np.array(col)

    def jump(arr):
        yrs = np.arange(1980, 2015)
        res = []
        for y0, y1 in ((1980, 1996), (1997, 2014)):
            s = (yrs >= y0) & (yrs <= y1)
            x = yrs[s] - yrs[s].mean()
            vv = arr[s]
            mu = vv.mean(0)
            sl = (x[:, None, None] * (vv - mu)).sum(0) / (x ** 2).sum()
            res.append(((vv - mu - sl * x[:, None, None]).std(0), mu))
        (s1, m1), (s2, m2) = res
        mask = (m1 > 0) & (m2 > 0)
        thr = np.percentile(np.r_[m1[mask], m2[mask]], 10)
        mask &= (m1 > thr) & (m2 > thr)
        return np.median(s1[mask] / m1[mask]) * 100, np.median(s2[mask] / m2[mask]) * 100

    s1, s2 = jump(annual(va))
    d1, d2 = jump(annual(vb))
    print(f'  {v}: local IAV 1980-96 -> 1997-2014: source {s1:.1f}% -> {s2:.1f}%   smoothed {d1:.1f}% -> {d2:.1f}%')

print('ALL CHECKS PASSED' if ok else 'CHECK FAILED')
