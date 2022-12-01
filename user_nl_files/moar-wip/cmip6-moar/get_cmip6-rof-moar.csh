#!/bin/tcsh

setenv CASE b.e21.BSSP126cmip6.f09_g17.CMIP6-SSP1-2.6.102
setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/timeseries-cmip6/$CASE
setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/

#day_1/   month_1/

setenv fpath $DOUT_S_ROOT/lnd/proc/tseries/month_1/
cd $fpath; ls -1   | cut -d"." -f10 | uniq | sort > $outdir/lnd.mon.h0

setenv fpath $DOUT_S_ROOT/lnd/proc/tseries/day_1/
cd $fpath; ls -1 $CASE.clm2.h5* | cut -d"." -f10 | uniq | sort > $outdir/lnd.day.h5
cd $fpath; ls -1 $CASE.clm2.h6* | cut -d"." -f10 | uniq | sort > $outdir/lnd.day.h6

setenv fpath $DOUT_S_ROOT/lnd/proc/tseries/hour_3/
cd $fpath; ls -1  | cut -d"." -f10 | uniq | sort >> $outdir/lnd.hr3.h7

setenv fpath $DOUT_S_ROOT/lnd/proc/tseries/day_365/
cd $fpath; ls -1 $CASE.clm2.h3* | cut -d"." -f10 | uniq | sort >> $outdir/lnd.day_365.h3
cd $fpath; ls -1 $CASE.clm2.h4* | cut -d"." -f10 | uniq | sort >> $outdir/lnd.day_365.h4
