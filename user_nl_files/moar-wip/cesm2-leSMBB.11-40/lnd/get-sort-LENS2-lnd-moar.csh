#!/bin/tcsh

setenv CASE b.e21.BHISTsmbb.f09_g17.LE2-1251.011
setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/CESM2-LE/archive/$CASE
setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/cesm2-leSMBB.11-40/lnd/xfr

rm $outdir/lnd.mon.h0.txt
rm $outdir/lnd.day.h5.txt
rm $outdir/lnd.day.h6.txt
rm $outdir/lnd.day_365.h3.txt
rm $outdir/lnd.day_365.h4.txt
rm $outdir/lnd.hr3.h7.txt

#day_1/   day_365/ hour_3/  month_1/

setenv fpath $DOUT_S_ROOT/lnd/proc/tseries/month_1/
cd $fpath; ls -1  $CASE.clm2.h0.*1850* |  cut -d"." -f9 | uniq | sort > $outdir/ilnd.mon.h0
cd $fpath; ls -1  $CASE.clm2.h1.*1850* |  cut -d"." -f9 | uniq | sort > $outdir/ilnd.mon.h1


#cd $fpath; ls -1  *1850* | cut -d"." -f9 | uniq | sort > $outdir/lnd.mon.h0.txt

setenv fpath $DOUT_S_ROOT/lnd/proc/tseries/day_1/
cd $fpath; ls -1 $CASE.clm2.h5.*1850* | cut -d"." -f9 | uniq | sort > $outdir/lnd.day.h5.txt
cd $fpath; ls -1 $CASE.clm2.h6.*1850* | cut -d"." -f9 | uniq | sort > $outdir/lnd.day.h6.txt

setenv fpath $DOUT_S_ROOT/lnd/proc/tseries/hour_3/
cd $fpath; ls -1 *1850* | cut -d"." -f9 | uniq | sort >> $outdir/lnd.hr3.h7.txt

setenv fpath $DOUT_S_ROOT/lnd/proc/tseries/day_365/
cd $fpath; ls -1 $CASE.clm2.h3.*1850* | cut -d"." -f9 | uniq | sort >> $outdir/lnd.day_365.h3.txt
cd $fpath; ls -1 $CASE.clm2.h4.*1850* | cut -d"." -f9 | uniq | sort >> $outdir/lnd.day_365.h4.txt
