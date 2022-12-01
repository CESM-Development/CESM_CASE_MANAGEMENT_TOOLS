#!/bin/tcsh

setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/differs/


set nri = di.atm
set nro = do.atm


set doThis = 1
set cs = cmip
if ($cs == "lens") then
	setenv CASE b.e21.BHISTsmbb.f09_g17.LE2-1251.011
	setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/CESM2-LE/archive/$CASE
	set fyr = 1850
else 
	setenv CASE b.e21.BSSP370cmip6.f09_g17.CMIP6-SSP3-7.0.102
	setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/timeseries-cmip6/$CASE
	set fyr = 2015
endif
rm $nri.day.h1.3D.$cs
rm $nri.day.h1.2D.$cs
rm $nri.day.h6.1D.$cs
if ($doThis == 1) then
foreach v (`cat in.day_1.$cs`)
	echo $v
	nh $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h1.$v.$fyr* | grep float  | grep lev    >> $nri.day.h1.3D.$cs
	nh $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h1.$v.$fyr* | grep float  | grep -v lev >> $nri.day.h1.2D.$cs
	nh $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h6.$v.$fyr* | grep double | grep  ilev  >> $nri.day.h6.1D.$cs
end

cat $nri.day.h1.3D.$cs | cut -d" " -f2 | cut -d"(" -f1 > ./xfr/$nro.$cs.day.h1.3D.txt
cat $nri.day.h1.2D.$cs | cut -d" " -f2 | cut -d"(" -f1 > ./xfr/$nro.$cs.day.h1.2D.txt
cat $nri.day.h6.1D.$cs | cut -d" " -f2 | cut -d"(" -f1 > ./xfr/$nro.$cs.day.h6.1D.txt
endif

## CMIP6



#ls $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.* | cut -d"." -f16 | uniq | sort > $outdir/atm.mon.h0.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h1.* | cut -d"." -f16 | uniq | sort > $outdir/atm.day.h1.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h6.* | cut -d"." -f16 | uniq | sort > $outdir/atm.day.h6.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_6/$CASE.cam.h2.* | cut -d"." -f16 | uniq | sort > $outdir/atm.6hr.h2.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_1/$CASE.cam.h4.* | cut -d"." -f16 | uniq | sort > $outdir/atm.1hr.h4.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_3/$CASE.cam.h3.* | cut -d"." -f16 | uniq | sort > $outdir/atm.3hr.h3.txt
