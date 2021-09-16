#! /bin/csh -fxv 

#  We are only doing Nov. 1 starts for HR DP. The dates to run are:
#  1982, 1984, 1986, 1988, 1990, 1992, 1994
#  That's 7 start dates. After we finish these, we'll decide whether to do 1980 or 1996 as the 8th start date.

set mach = frontera
set mach = cheyenne
if ($mach == "cheyenne") then
	set SCRATCH = /glade/scratch/nanr/
        set atmdir  = /glade/p/cesm/espwg/JRA55_regridded_to_CAM/ne120_L30/
	#set ocnpath = /glade/campaign/cesm/development/omwg/projects/ihesp/
	set ocnpath = /glade/scratch/nanr/archive/
	#set ocnpath = /glade/scratch/fredc/archive/g.e21.GIAF.TL319_t13.5thCyc.ice.001/rest/0269-11-01-00000
        #set restdir = /glade/scratch/fredc/archive/f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-1950-2050.001/rest/1982-01-01-00000/
        #set lndpath = /glade/scratch/jedwards/
        set lndpath = /glade/scratch/nanr/archive/
	#set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.chey-gen-restarts.001
	#set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.chey-gen-restarts.1990-05-01.001
	set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.rerun-gen-restarts.001
else
	set atmdir = /scratch1/06091/nanr/JRA55/
	set ocnpath = /scratch1/06090/fredc/
        set lndpath = /scratch1/06091/nanr/archive/
	set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.gen-restarts.001
endif

set syr = 1982
set eyr = 1982
set syr = 1990
set eyr = 1990
set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.chey-gen-restarts.1990-05-01.001
set syr = 1992
set eyr = 1992
#set syr = 1994
#set eyr = 1994
set syr = 1996
set eyr = 1996
#=======
set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.chey-gen-restarts.${syr}-01-01.001
set syr = 1998
set eyr = 1998
set lndcase =  f.e13.FAMIPC5.ne120_ne120_mt12.rerun-gen-restarts.001
set syr = 2014
set eyr = 2014

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib 2 $ie` )
#foreach year ( `seq $ib $ie` )
foreach mon ( 11 )

set case = b.e13.DP-HR_IC.ne120_t12.${year}-${mon}.01
set Picdir = ${SCRATCH}/DP-HR/inputdata/cesm2_init/{$case}/
set icdir  = ${SCRATCH}/DP-HR/inputdata/cesm2_init/{$case}/${year}-${mon}-01
if (! -d ${Picdir}) then
 mkdir ${Picdir}
endif
if (! -d ${icdir}) then
 mkdir ${icdir}
endif

# atm, lnd initial conditions
set atmcase =  JRA55_ne120_L30

# names
set atmfname = ${atmcase}.cam2.i.${year}-${mon}-01-00000.nc
set lndfname = ${lndcase}.clm2.r.${year}-${mon}-01-00000.nc
set roffname = ${lndcase}.rtm.r.${year}-${mon}-01-00000.nc
#set lndfname = ${lndcase}.clm2.r.1960-${mon}-01-00000.nc
#set roffname = ${lndcase}.rtm.r.1960-${mon}-01-00000.nc

# directories
#set lnddir = /scratch1/02503/edwardsj/archive/f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-hires1.0.32_gen-restarts.0097/rest/${year}-${mon}-01-00000/
#set lnddir = ${lndpath}/f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-hires1.0.32_gen-restarts.0097/1960-11-01-00000/
#set lnddir = ${lndpath}/f.e13.FAMIPC5.ne120_ne120_mt12.gen-restarts.001/${year}-${mon}-11-01-00000/
set lnddir = ${lndpath}/${lndcase}/rest/${year}-${mon}-01-00000/

# rename atm, land IC files
set atmfout = ${case}.cam.i.${year}-${mon}-01-00000.nc
set lndfout = ${case}.clm2.r.${year}-${mon}-01-00000.nc
set roffout = ${case}.rtm.r.${year}-${mon}-01-00000.nc

echo $atmfout

set doThis = 1

if ($doThis == 1) then
cp $atmdir/${atmfname} $icdir/$atmfout
cp $lnddir/${lndfname} $icdir/$lndfout
cp $lnddir/${roffname} $icdir/$roffout
ncatted -a OriginalFile,global,a,c,$atmfname $icdir/$atmfout
ncatted -a OriginalFile,global,a,c,$lndfname $icdir/$lndfout
ncatted -a OriginalFile,global,a,c,$roffname $icdir/$roffout

endif

# ocn/ice
set ocncase = g.e21.GIAF.TL319_t13.5thCyc.ice.001
set first_rest_year = 1958
set ocean_base_year = 245

# Comment:  year translation:  if ($year == 2018 ) set ocnyr = 0305
# Cycle 5 of the HR FOSI should be a 61-year simulation with
# sim-year 0245-0305  == his-year 1958-2018
# years used for ICs:   0245 (1958) - 0305 (2018)
# atmyr 1958 = ocnyr 245

@ offset = $first_rest_year - $ocean_base_year 
@ ocnyr   = $year - $offset
set ocndir = ${ocnpath}/g.e21.GIAF.TL319_t13.5thCyc.ice.001/rest/0${ocnyr}-${mon}-01-00000/

set icefout = ${case}.cice.r.${year}-${mon}-01-00000.nc
set lndfout = ${case}.clm2.r.${year}-${mon}-01-00000.nc
set roffout = ${case}.rtm.r.${year}-${mon}-01-00000.nc

#set icefname   = ${ocncase}.cice.r.0${ocnyr}-${mon}-01-00000.nc 
#set poprfname  = ${ocncase}.pop.r.0${ocnyr}-${mon}-01-00000.nc  
set icefname   = ${ocncase}.cice4.r.tx01v2.0${ocnyr}-${mon}-01-00000.nc 
set poprfname  = ${ocncase}.pop.r.tx01v2.0${ocnyr}-${mon}-01-00000.nc  
#set icefname   = g.e21.GIAF.TL319_t13.5thCyc.ice.001.cice4.r.tx01v2.0269-11-01-00000.nc
#set poprfname  = g.e21.GIAF.TL319_t13.5thCyc.ice.001.pop.r.tx01v2.0269-11-01-00000.nc
set poprofname = ${ocncase}.pop.ro.0${ocnyr}-${mon}-01-00000    
set poprhfname = ${ocncase}.pop.rh.ecosys.nyear1.0${ocnyr}-${mon}-01-00000.nc 
#set popwwfname = ${ocncase}.ww3.r.0${ocnyr}-${mon}-01-00000    

set poprfout  = ${case}.pop.r.${year}-${mon}-01-00000.nc
set poprofout = ${case}.pop.ro.${year}-${mon}-01-00000 
set poprhfout = ${case}.pop.rh.ecosys.nyear1.${year}-${mon}-01-00000.nc
#set popwwfout = ${case}.ww3.r.${year}-${mon}-01-00000

echo $icefname
echo $poprfname

set doThis2 = 1
if ($doThis2 == 1) then

cp $ocndir/${icefname}    $icdir/${icefout}
cp $ocndir/${poprfname}   $icdir/${poprfout}
#cp $ocndir/${poprofname}  $icdir/${poprofout}
#cp $ocndir/${poprhfname}  $icdir/${poprhfout}
#cp $ocndir/${popwwfname}  $icdir/${popwwfout}

ncatted -a OriginalFile,global,a,c,$icefname    $icdir/$icefout
ncatted -a OriginalFile,global,a,c,$poprfname   $icdir/$poprfout
#ncatted -a OriginalFile,global,a,c,$poprofname  $icdir/$poprofout
#ncatted -a OriginalFile,global,a,c,$poprhfname  $icdir/$poprhfout

# create rpointer files

echo "$case.cice.r.$year-${mon}-01-00000.nc"  > ${icdir}/rpointer.ice
echo "./$case.pop.ro.$year-${mon}-01-00000"   > ${icdir}/rpointer.ocn.ovf
echo "$case.cam.i.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.atm
echo "$case.cpl.r.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.drv
echo "$case.clm2.r.$year-${mon}-01-00000.nc"  > ${icdir}/rpointer.clm
echo "$case.rtm.r.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.rof
#echo "$case.pop.rh.ecosys.nyear1.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.ocn.tavg.5
#echo "$case.pop.rh.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.ocn.tavg

echo "./$case.pop.r.$year-${mon}-01-00000.nc"    >> ${icdir}/rpointer.ocn.restart
echo "RESTART_FMT=nc"                          >> ${icdir}/rpointer.ocn.restart

endif	# doThis2

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end
end

exit
 
 



