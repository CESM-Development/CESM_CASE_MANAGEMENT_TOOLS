#!/bin/tcsh

setenv CASE b.e21.BHISTsmbb.f09_g17.LE2-1251.011
setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/CESM2-LE/archive/$CASE
setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/cesm2-leSMBB.11-40/ocn


#day_1/	month_1/  year_1/

ls $DOUT_S_ROOT/ocn/proc/tseries/month_1/$CASE.pop.h.* | cut -d"." -f14 | uniq | sort > $outdir/ocn.mon.list
ls $DOUT_S_ROOT/ocn/proc/tseries/day_1/$CASE.pop.h.nday1.* | cut -d"." -f15 | uniq | sort > $outdir/ocn.nday1.list
ls $DOUT_S_ROOT/ocn/proc/tseries/day_1/$CASE.pop.h.ecosys.nday1.* | cut -d"." -f16 | uniq | sort > $outdir/ocn.ecosys.nday1.list
ls $DOUT_S_ROOT/ocn/proc/tseries/year_1/$CASE.pop.h.ecosys.nyear1.* | cut -d"." -f16 | uniq | sort > $outdir/ocn.ecosys.nyear1.list

