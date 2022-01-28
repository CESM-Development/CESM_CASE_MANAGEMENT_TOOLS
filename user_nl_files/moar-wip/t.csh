#!/bin/tcsh -vf

setenv CASE b.e21.BSSP126cmip6.f09_g17.CMIP6-SSP1-2.6.102
setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/timeseries-cmip6/$CASE
setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/

set YYYY = 1958
set MM = 12

setenv fpath $DOUT_S_ROOT/atm/proc/tseries/month_1/
echo $fpath
cd $fpath 
ls -1   | cut -d"." -f10 | uniq | sort > $outdir/atm.mon


