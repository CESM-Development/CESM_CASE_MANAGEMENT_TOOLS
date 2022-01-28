#!/bin/tcsh

setenv CASE b.e21.BHISTsmbb.f09_g17.LE2-1251.011
setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/CESM2-LE/archive/$CASE
setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/cesm2-leSMBB.11-40

rm atm.6hr.3D.txt
rm atm.6hr.3D.list

set doThis = 1
if ($doThis == 1) then
foreach v (`cat atm.6hr.h2`)
	nh $DOUT_S_ROOT/atm/proc/tseries/hour_6/$CASE.cam.h2.$v.1850* | grep float | grep lev | grep -v ilev >> atm.6hr.h2.3D.list
	nh $DOUT_S_ROOT/atm/proc/tseries/hour_6/$CASE.cam.h2.$v.1850* | grep float | grep ilev >> atm.6hr.h2.15L.list
	nh $DOUT_S_ROOT/atm/proc/tseries/hour_6/$CASE.cam.h2.$v.1850* | grep float | grep -v lev >> atm.6hr.h2.2D.list
end

cat atm.6hr.h2.3D.list | cut -d" " -f2 | cut -d"(" -f1 > atm.6hr.h1.3D.txt
cat atm.6hr.h2.2D.list | cut -d" " -f2 | cut -d"(" -f1 > atm.6hr.h1.2D.txt
cat atm.6hr.h2.15L.list | cut -d" " -f2 | cut -d"(" -f1 > atm.6hr.h1.15L.txt

foreach v (`cat atm.3hr.h3`)
	nh $DOUT_S_ROOT/atm/proc/tseries/hour_3/$CASE.cam.h3.$v.1850* | grep float  >> atm.3hr.h3.2D.list
end

cat atm.3hr.h3.3D.list | cut -d" " -f2 | cut -d"(" -f1 > atm.3hr.h3.3D.txt
cat atm.3hr.h3.2D.list | cut -d" " -f2 | cut -d"(" -f1 > atm.3hr.h3.2D.txt
cat atm.3hr.h3.15L.list | cut -d" " -f2 | cut -d"(" -f1 > atm.3hr.h3.15L.txt
endif
