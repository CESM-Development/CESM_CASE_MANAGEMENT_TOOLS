#!/bin/tcsh

setenv CASE b.e21.BSSP126cmip6.f09_g17.CMIP6-SSP1-2.6.102
setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/timeseries-cmip6/$CASE
setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/

#day_1/	month_1/  

ls $DOUT_S_ROOT/ice/proc/tseries/month_1/$CASE.cice.h.* | cut -d"." -f16 | uniq | sort > $outdir/ice.mon
ls $DOUT_S_ROOT/ice/proc/tseries/day_1/$CASE.cice.h1.* | cut -d"." -f16 | uniq | sort > $outdir/ice.nday1

