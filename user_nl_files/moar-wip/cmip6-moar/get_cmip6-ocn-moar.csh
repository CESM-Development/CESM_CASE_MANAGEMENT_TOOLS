#!/bin/tcsh

setenv CASE b.e21.BSSP126cmip6.f09_g17.CMIP6-SSP1-2.6.102
setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/timeseries-cmip6/$CASE
setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/

#day_1/	month_1/  year_1/

ls $DOUT_S_ROOT/ocn/proc/tseries/month_1/$CASE.pop.h.* | cut -d"." -f16 | uniq | sort > $outdir/ocn.mon.new
ls $DOUT_S_ROOT/ocn/proc/tseries/day_1/$CASE.pop.h.nday1.* | cut -d"." -f17 | uniq | sort > $outdir/ocn.nday1
ls $DOUT_S_ROOT/ocn/proc/tseries/day_1/$CASE.pop.h.ecosys.nday1.* | cut -d"." -f18 | uniq | sort > $outdir/ocn.ecosys.nday1
ls $DOUT_S_ROOT/ocn/proc/tseries/year_1/$CASE.pop.h.ecosys.nyear1.* | cut -d"." -f18 | uniq | sort > $outdir/ocn.ecosys.nyear1

