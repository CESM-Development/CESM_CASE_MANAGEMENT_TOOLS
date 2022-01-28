#!/bin/tcsh

set YYYY = 1850

setenv CASE b.e21.BHISTsmbb.f09_g17.LE2-1251.011
setenv DOUT_S_ROOT /glade/campaign/collections/cmip/CMIP6/CESM2-LE/archive/$CASE
setenv outdir /glade/work/nanr/cesm_tags/CASE_tools/cesm2-le/user_nl_files/moar-wip/cesm2-leSMBB.11-40

foreach v (`cat ocn.mon.list`)
	#nh $DOUT_S_ROOT/ocn/proc/tseries/month_1/$CASE.pop.h.$v.1850* | grep float | grep z_t  | grep -v z_t_150 >> ocn.mon.3D.list
	set fname = "$DOUT_S_ROOT/ocn/proc/tseries/month_1/$CASE.pop.h.$v.1850*"
	echo $fname
        nh $fname | grep "float .*time, z.*, nlat, nlon" | grep -v z_t_150m | cut -f1 -d'(' | awk '{print $NF}' | sort >> monthly.3d_full.actual.txt
        nh $fname | grep "float .*time, nlat, nlon" | cut -f1 -d'(' | awk '{print $NF}' | sort >> monthly.2d.actual.txt
        nh $fname | grep "float .*time, z_t_150m, nlat, nlon" | cut -f1 -d'(' | awk '{print $NF}' | sort >> monthly.z_t_150m.actual.txt

end

foreach v (`cat ocn.nday1.list`)
        set fname = "$DOUT_S_ROOT/ocn/proc/tseries/day_1/$CASE.pop.h.nday1.$YYYY*"
        ncdump -h $fname | grep "float .*time.*nlat, nlon" | cut -f1 -d'(' | awk '{print $NF}' | sort >> nday1.actual

end

foreach v (`cat ocn.ecosys.nday1.list`)
	set fname = "$DOUT_S_ROOT/ocn/proc/tseries/day_1/$CASE.pop.h.ecosys.nday1.$YYYY*"
	ncdump -h $fname | grep "float .*time.*nlat, nlon" | cut -f1 -d'(' | awk '{print $NF}' | sort >> ecosys.nday1.actual

foreach v (`cat ocn.ecosys.nyear1.list`)
	set fname = "$DOUT_S_ROOT/ocn/proc/tseries/year_1/$CASE.pop.h.ecosys.nyear1.$YYYY*"
	ncdump -h $fname | grep "float .*time.*nlat, nlon" | cut -f1 -d'(' | awk '{print $NF}' | sort >> ecosys.nyear1.actual
end


        #nh $fname | grep "float .*time.*nlat, nlon" | cut -f1 -d'(' | awk '{print $NF}' | sort > nday1.actual.txt
        #nh $fname | grep "float .*time.*nlat, nlon" | cut -f1 -d'(' | awk '{print $NF}' | sort > nday1.actual.txt
        #nh $fname | grep "float .*time.*nlat, nlon" | cut -f1 -d'(' | awk '{print $NF}' | sort > ecosys.nday1.actual.txt
        #nh $fname | grep "float .*time.*nlat, nlon" | cut -f1 -d'(' | awk '{print $NF}' | sort > ecosys.nyear1.actual.txt
	#nh $DOUT_S_ROOT/ocn/proc/tseries/month_1/$CASE.pop.h.$v.1850* | grep float | grep z_t_150 >> ocn.mon.150.list
	#nh $DOUT_S_ROOT/ocn/proc/tseries/month_1/$CASE.pop.h.$v.1850* | grep float | grep -v z_t >> ocn.mon.2D.list
	#nh $DOUT_S_ROOT/ocn/proc/tseries/month_1/$CASE.pop.h0.$v.1850* | grep float | grep -v lev >> atm.mon.2D.list

#cat ocn.mon.3D.list | cut -d" " -f2 | cut -d"(" -f1 > ocn.mon.3D.txt
#cat ocn.mon.2D.list | cut -d" " -f2 | cut -d"(" -f1 > ocn.mon.2D.txt
#cat ocn.mon.150.list | cut -d" " -f2 | cut -d"(" -f1 > ocn.mon.2D.txt
# cat atm.mon.2D.list | cut -d" " -f2 | cut -d"(" -f1 > atm.mon.2D.txt
#cat atm.mon.15L.list | cut -d" " -f2 | cut -d"(" -f1 > atm.mon.15L.txt


#ls $DOUT_S_ROOT/atm/proc/tseries/month_1/$CASE.cam.h0.* | cut -d"." -f16 | uniq | sort > $outdir/atm.mon.h0.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h1.* | cut -d"." -f16 | uniq | sort > $outdir/atm.day.h1.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/day_1/$CASE.cam.h6.* | cut -d"." -f16 | uniq | sort > $outdir/atm.day.h6.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_6/$CASE.cam.h2.* | cut -d"." -f16 | uniq | sort > $outdir/atm.6hr.h2.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_1/$CASE.cam.h4.* | cut -d"." -f16 | uniq | sort > $outdir/atm.1hr.h4.txt
#ls $DOUT_S_ROOT/atm/proc/tseries/hour_3/$CASE.cam.h3.* | cut -d"." -f16 | uniq | sort > $outdir/atm.3hr.h3.txt
