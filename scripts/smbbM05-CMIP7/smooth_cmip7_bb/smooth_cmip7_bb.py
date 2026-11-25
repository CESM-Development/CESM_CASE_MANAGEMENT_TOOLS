#!/usr/bin/env python
"""Smooth the biomass-burning (BB) sector of E3SM CMIP7 elevated emission files.

Same method as the CMIP6 smbb files of 2026-09-25 (smooth_forestfire.py, after
fromJack/smooth-BB-CESM-2D-SSP370.ncl):

  every record in year y, calendar month m is replaced by the mean of month m
  over all available years y-5..y+5 (11-yr same-month running mean).
  One value per year-month enters the mean (the mid-month, day-15 record);
  sub-monthly records within a month are set to that month's smoothed value.
  All other years and variables are unchanged.

CMIP7 specifics:
  - smoothed years: 1990-2023 (CMIP6 smbb: 1990-2015, its record end)
  - window inputs: real data years 1985-2023, so windows near the end are
    truncated (2023 window = 2018-2023)
  - the 2024 padding year (an exact copy of 2023 in the source files) is set
    to the smoothed 2023 values, so it stays a copy of 2023

Usage: smooth_cmip7_bb.py SRC DST VAR [VAR ...]
DST is written via DST.tmp and renamed only on success; an existing DST is
never overwritten.
"""
import os
import shutil
import sys
from datetime import date

import numpy as np
import netCDF4 as nc

Y_SMOOTH0, Y_SMOOTH1 = 1990, 2023   # years whose BB is replaced
Y_IN0, Y_IN1 = 1985, 2023           # real years allowed into the window
Y_PAD = 2024                        # padding year, copy of Y_IN1
HALF = 5                            # window = y-5 .. y+5
FILLMIN = 1.0e30                    # treat values >= this as fill


def month_reps(dates, datesec):
    """(year, month) -> index of the day-15 record (closest to noon)."""
    y, m, d = dates // 10000, (dates // 100) % 100, dates % 100
    reps = {}
    for Y in range(Y_IN0, Y_PAD + 1):
        for M in range(1, 13):
            idx = np.where((y == Y) & (m == M) & (d == 15))[0]
            if idx.size == 0:
                raise RuntimeError(f'no day-15 record for {Y}-{M:02d}')
            if idx.size > 1:
                idx = idx[np.argsort(np.abs(datesec[idx] - 43200))]
            reps[(Y, M)] = int(idx[0])
    return reps


def smooth_var(ds, vname, reps, years, months):
    var = ds[vname]
    assert var.dimensions[0] == 'time', var.dimensions
    sel = np.where((years >= Y_SMOOTH0) & (years <= Y_PAD))[0]  # records to rewrite
    i0 = min(min(reps.values()), sel.min())
    i1 = max(max(reps.values()), sel.max()) + 1
    nlev = var.shape[1]
    for k in range(nlev):
        blk = np.ma.filled(var[i0:i1, k, ...], np.nan).astype(np.float64)
        if np.isnan(blk).any() or (np.abs(blk) >= FILLMIN).any():
            raise RuntimeError(f'{vname} level {k}: fill/NaN values in window block')
        # one value per year-month
        V = {key: blk[i - i0] for key, i in reps.items() if key[0] <= Y_IN1}
        S = {}
        for Y in range(Y_SMOOTH0, Y_SMOOTH1 + 1):
            for M in range(1, 13):
                yrs = [yy for yy in range(Y - HALF, Y + HALF + 1) if Y_IN0 <= yy <= Y_IN1]
                S[(Y, M)] = np.mean([V[(yy, M)] for yy in yrs], axis=0)
        out = blk.copy()
        for i in sel:
            Y = int(years[i])
            Ysrc = Y_SMOOTH1 if Y == Y_PAD else Y
            out[i - i0] = S[(Ysrc, int(months[i]))]
        var[i0:i1, k, ...] = out.astype(var.dtype)
    return len(sel)


def main():
    src, dst, vnames = sys.argv[1], sys.argv[2], sys.argv[3:]
    if os.path.exists(dst):
        sys.exit(f'ERROR: {dst} exists; not overwriting')
    tmp = dst + '.tmp'
    print(f'copy {src} -> {tmp}', flush=True)
    shutil.copyfile(src, tmp)
    ds = nc.Dataset(tmp, 'r+')
    dates = ds['date'][:].astype(np.int64)
    datesec = ds['datesec'][:].astype(np.int64) if 'datesec' in ds.variables else np.full(dates.shape, 43200)
    years, months = dates // 10000, (dates // 100) % 100
    reps = month_reps(dates, datesec)
    for v in vnames:
        n = smooth_var(ds, v, reps, years, months)
        print(f'  smoothed {v}: {n} records ({Y_SMOOTH0}-{Y_PAD})', flush=True)
    note = (f"{date.today().isoformat()}: SMOOTHED variable(s) {', '.join(vnames)} for "
            f"{Y_SMOOTH0}-{Y_SMOOTH1}. Method (same as CMIP6 smbb files of 2026-09-25, after "
            "fromJack/smooth-BB-CESM-2D-SSP370.ncl): every record in year y, calendar month m "
            "was replaced by the mean of month m over all available years y-5..y+5 (11-yr "
            f"same-month running mean). Inputs: original data from {os.path.basename(src)} for "
            f"{Y_IN0}-{Y_IN1}; windows reaching past {Y_IN1} contain fewer years (2023 window: "
            "2018-2023). One value per year-month (the day-15 record) enters the mean; "
            "sub-monthly records within a month are set to that month's smoothed value. "
            f"Padding year {Y_PAD} (a copy of {Y_IN1}) set to the smoothed {Y_IN1} values. "
            "All other years and variables are unchanged. Script: smooth_cmip7_bb.py.")
    old = getattr(ds, 'history', '')
    ds.history = note + ('\n' + old if old else '')
    ds.close()
    os.rename(tmp, dst)
    os.chmod(dst, 0o644)
    print(f'wrote {dst}', flush=True)


if __name__ == '__main__':
    main()
