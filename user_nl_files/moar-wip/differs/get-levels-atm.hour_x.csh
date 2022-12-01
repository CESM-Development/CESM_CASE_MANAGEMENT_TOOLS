#!/bin/tcsh

setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/differs/


set nri = di.atm
set nro = do.atm


set doThis = 1
set cs = lens
set cs = cmip
set freq = hour_6
set freq = hour_3
set freq = hour_1
if ($freq == "hour_6") then
	set hx = h2
endif
if ($freq == "hour_3") then
	set hx = h3
endif
if ($freq == "hour_1") then
	set hx = h4
endif
if ($cs == "lens") then
	setenv CASE b.e21.BHISTsmbb.f09_g17.LE2-1251.011
	setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/CESM2-LE/archive/$CASE
	set fyr = 1850
else 
	setenv CASE b.e21.BSSP370cmip6.f09_g17.CMIP6-SSP3-7.0.102
	setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/timeseries-cmip6/$CASE
	set fyr = 2015
endif
rm $nri.$freq.$hx.3D.$cs
rm $nri.$freq.$hx.2D.$cs
rm $nri.$freq.$hx.1D.$cs
if ($doThis == 1) then
foreach v (`cat in.$freq.$cs`)
  echo $v
  nh $DOUT_S_ROOT/atm/proc/tseries/$freq/$CASE.cam.$hx.$v.$fyr* | grep float  | grep lev    >> $nri.$freq.$hx.3D.$cs
  nh $DOUT_S_ROOT/atm/proc/tseries/$freq/$CASE.cam.$hx.$v.$fyr* | grep float  | grep -v lev >> $nri.$freq.$hx.2D.$cs
  nh $DOUT_S_ROOT/atm/proc/tseries/$freq/$CASE.cam.$hx.$v.$fyr* | grep float  | grep ilev | grep -v "hyai\| hybi">> $nri.$freq.$hx.1D.$cs
end

cat $nri.$freq.$hx.3D.$cs | cut -d" " -f2 | cut -d"(" -f1 > ./xfr/$nro.$cs.$freq.$hx.3D.txt
cat $nri.$freq.$hx.2D.$cs | cut -d" " -f2 | cut -d"(" -f1 > ./xfr/$nro.$cs.$freq.$hx.2D.txt
cat $nri.$freq.$hx.1D.$cs | cut -d" " -f2 | cut -d"(" -f1 > ./xfr/$nro.$cs.$freq.$hx.1D.txt

find xfr/ -empty >> rmfiles
endif

## CMIP6



#ls $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.* | cut -d"." -f16 | uniq | sort > $outdir/atm.mon.h0.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h1.* | cut -d"." -f16 | uniq | sort > $outdir/atm.day.h1.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h6.* | cut -d"." -f16 | uniq | sort > $outdir/atm.day.h6.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_6/$CASE.cam.h2.* | cut -d"." -f16 | uniq | sort > $outdir/atm.6hr.h2.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_1/$CASE.cam.h4.* | cut -d"." -f16 | uniq | sort > $outdir/atm.1hr.h4.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_3/$CASE.cam.h3.* | cut -d"." -f16 | uniq | sort > $outdir/atm.3hr.h3.txt
