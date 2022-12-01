#!/bin/tcsh

setenv CASE b.e21.BHISTsmbb.f09_g17.LE2-1251.011
setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/CESM2-LE/archive/$CASE
setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/cesm2-leSMBB.11-40

rm atm.mon.3D.txt
rm atm.mon.3D.list

foreach v (`cat atm.mon.h0`)
	#echo $v
	#echo $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.$v.1850* | grep float | grep lev > atm.mon.3D.txt
	nh $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.$v.1850* | grep float | grep lev | grep -v ilev >> atm.mon.3D.list
	nh $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.$v.1850* | grep float | grep ilev >> atm.mon.15L.list
	nh $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.$v.1850* | grep float | grep -v lev >> atm.mon.2D.list
end

cat atm.mon.3D.list | cut -d" " -f2 | cut -d"(" -f1 > atm.mon.3D.txt
cat atm.mon.2D.list | cut -d" " -f2 | cut -d"(" -f1 > atm.mon.2D.txt
cat atm.mon.15L.list | cut -d" " -f2 | cut -d"(" -f1 > atm.mon.15L.txt


#ls $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.* | cut -d"." -f16 | uniq | sort > $outdir/atm.mon.h0.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h1.* | cut -d"." -f16 | uniq | sort > $outdir/atm.day.h1.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h6.* | cut -d"." -f16 | uniq | sort > $outdir/atm.day.h6.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_6/$CASE.cam.h2.* | cut -d"." -f16 | uniq | sort > $outdir/atm.6hr.h2.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_1/$CASE.cam.h4.* | cut -d"." -f16 | uniq | sort > $outdir/atm.1hr.h4.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_3/$CASE.cam.h3.* | cut -d"." -f16 | uniq | sort > $outdir/atm.3hr.h3.txt
