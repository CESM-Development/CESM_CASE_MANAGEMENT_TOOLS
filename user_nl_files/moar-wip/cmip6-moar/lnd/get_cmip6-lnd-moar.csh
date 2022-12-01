#!/bin/tcsh

setenv CASE b.e21.BSSP126cmip6.f09_g17.CMIP6-SSP1-2.6.102
setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/timeseries-cmip6/$CASE
setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/cmip6-moar/lnd/xfr

#day_1/   day_365/ hour_3/  month_1/
rm $outdir/lnd.mon.h0.txt
rm $outdir/lnd.day.h5.txt
rm $outdir/lnd.day.h6.txt
rm $outdir/lnd.day_365.h3.txt
rm $outdir/lnd.day_365.h4.txt
rm $outdir/lnd.hr3.h7.txt

#day_1/   day_365/ hour_3/  month_1/

set year=2015

setenv fpath $DOUT_S_ROOT/lnd/proc/tseries/month_1/
cd $fpath; ls -1  $CASE.clm2.h0.*${year}* |  cut -d"." -f10 | uniq | sort > $outdir/lnd.mon.h0.txt
cd $fpath; ls -1  $CASE.clm2.h1.*${year}* |  cut -d"." -f10 | uniq | sort > $outdir/lnd.mon.h1.txt
#cd $fpath; ls -1  *$year* | cut -d"." -f10 | uniq | sort > $outdir/lnd.mon.h0.txt

setenv fpath $DOUT_S_ROOT/lnd/proc/tseries/day_1/
cd $fpath; ls -1 $CASE.clm2.h5.*${year}* | cut -d"." -f10 | uniq | sort > $outdir/lnd.day.h5.txt
cd $fpath; ls -1 $CASE.clm2.h6.*${year}* | cut -d"." -f10 | uniq | sort > $outdir/lnd.day.h6.txt

setenv fpath $DOUT_S_ROOT/lnd/proc/tseries/hour_3/
cd $fpath; ls -1 *${year}* | cut -d"." -f10 | uniq | sort >> $outdir/lnd.hr3.h7.txt

setenv fpath $DOUT_S_ROOT/lnd/proc/tseries/day_365/
cd $fpath; ls -1 $CASE.clm2.h3.*${year}* | cut -d"." -f10 | uniq | sort >> $outdir/lnd.day_365.h3.txt
cd $fpath; ls -1 $CASE.clm2.h4.*${year}* | cut -d"." -f10 | uniq | sort >> $outdir/lnd.day_365.h4.txt
