#!/bin/tcsh

setenv CASE b.e21.BHISTsmbb.f09_g17.LE2-1251.011
setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/CESM2-LE/archive/$CASE
setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/matches/

set nr = mout.atm
set freq = mon

set doThis = 1
rm $nr.$freq.h0.3D.list
rm $nr.$freq.h0.2D.list
rm $nr.$freq.h0.1D.list
if ($doThis == 1) then
foreach v (`cat in.month_1`)
	echo $v
	#nh $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h1.$v.1850* | grep float | grep lev | grep -v ilev >> $nr.$freq.h1.3D.list
	nh $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.$v.1850* | grep float | grep lev    >> $nr.$freq.h0.3D.list
	nh $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.$v.1850* | grep float | grep -v lev >> $nr.$freq.h0.2D.list
	nh $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.$v.1850* | grep float | grep ilev | grep -v "hyai\| hybi" >> $nr.$freq.h0.1D.list
end

cat $nr.$freq.h0.3D.list | cut -d" " -f2 | cut -d"(" -f1 > ./xfr/$nr.$freq.h0.3D.txt
cat $nr.$freq.h0.2D.list | cut -d" " -f2 | cut -d"(" -f1 > ./xfr/$nr.$freq.h0.2D.txt
cat $nr.$freq.h0.1D.list | cut -d" " -f2 | cut -d"(" -f1 > ./xfr/$nr.$freq.h0.1D.txt
endif


set doThis2 = 0
if ($doThis2 == 1) then
rm $nr.day.h6.3D.list $nr.day.h6.1D.list $nr.day.h6.2D.list 
foreach v (`cat $nr.day.h6`)
	nh $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h6.$v.1850* | grep double | grep ilev | grep zlon >> atm.day.h6.3D.list
end

cat atm.day.h6.3D.list | cut -d" " -f2 | cut -d"(" -f1 > atm.day.h6.3D.txt

endif


#ls $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.* | cut -d"." -f16 | uniq | sort > $outdir/atm.mon.h0.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h1.* | cut -d"." -f16 | uniq | sort > $outdir/atm.day.h1.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h6.* | cut -d"." -f16 | uniq | sort > $outdir/atm.day.h6.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_6/$CASE.cam.h2.* | cut -d"." -f16 | uniq | sort > $outdir/atm.6hr.h2.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_1/$CASE.cam.h4.* | cut -d"." -f16 | uniq | sort > $outdir/atm.1hr.h4.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_3/$CASE.cam.h3.* | cut -d"." -f16 | uniq | sort > $outdir/atm.3hr.h3.txt
