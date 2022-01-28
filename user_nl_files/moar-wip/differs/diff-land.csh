#!/bin/tcsh

setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/differs/xfr
setenv indir1 /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/cmip6-moar/lnd/xfr
setenv indir2 /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/cesm2-leSMBB.11-40/lnd/xfr

set hx = h0
set freq = mon
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep ">" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.lens
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep "<" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.cmip

set hx = h1
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep ">" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.lens
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep "<" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.cmip

set hx = h5
set freq = day
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep ">" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.lens
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep "<" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.cmip

set hx = h6
set freq = day
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep ">" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.lens
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep "<" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.cmip

set hx = h7
set freq = hr3
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep ">" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.lens
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep "<" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.cmip

set hx = h3
set freq = day_365
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep ">" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.lens
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep "<" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.cmip

set hx = h4
set freq = day_365
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep ">" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.lens
diff $indir1/lnd.$freq.$hx.txt $indir2/lnd.$freq.$hx.txt | grep "<" | cut -d" " -f2 > $outdir/do.lnd.$freq.$hx.cmip
