#!/bin/tcsh

rm atm.mon.h0
rm atm.day.h1
rm atm.day.h6
rm atm.6hr.h2
rm atm.3hr.h3

setenv CASE b.e21.BHISTsmbb.f09_g17.LE2-1251.011
setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/CESM2-LE/archive/$CASE
setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/cesm2-leSMBB.11-40

ls $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.* | cut -d"." -f14 | uniq | sort > $outdir/atm.mon.h0
ls $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h1.* | cut -d"." -f14 | uniq | sort > $outdir/atm.day.h1
ls $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h6.* | cut -d"." -f14 | uniq | sort > $outdir/atm.day.h6
ls $DOUT_S_ROOT/atm/proc/tseries/hour_6/$CASE.cam.h2.* | cut -d"." -f14 | uniq | sort > $outdir/atm.6hr.h2
ls $DOUT_S_ROOT/atm/proc/tseries/hour_3/$CASE.cam.h3.* | cut -d"." -f14 | uniq | sort > $outdir/atm.3hr.h3
