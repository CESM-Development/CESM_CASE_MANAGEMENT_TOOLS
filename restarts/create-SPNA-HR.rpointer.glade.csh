#! /bin/csh -fxv 

#  We are only doing Nov. 1 starts for HR DP. The dates to run are:
#  1982, 1984, 1986, 1988, 1990, 1992, 1994
#  That's 7 start dates. After we finish these, we'll decide whether to do 1980 or 1996 as the 8th start date.

set SCRATCH = /glade/scratch/nanr/

set syr = 400
set eyr = 400
set syr = 360
set eyr = 360
set refcase =  B.E.13.B1850C5.ne120_t12.sehires38.003.sunway_02

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib 20 $ie` )

set case = $refcase
set icdir = ${SCRATCH}/archive/$refcase/rest/$year/
if (! -d ${icdir}) then
 mkdir ${icdir}
endif

# names
set lndfname = ${refcase}.clm2.r.0${year}-01-01-00000.nc
set roffname = ${refcase}.rtm.r.0${year}-01-01-00000.nc
set icefname   = ${refcase}.cice.r.0${year}-01-01-00000.nc 
set poprfname  = ${refcase}.pop.r.0${year}-01-01-00000.nc  
set poprofname = ${refcase}.pop.ro.0${year}-01-01-00000    
set poprhfname = ${refcase}.pop.rh.ecosys.nyear1.0${year}-01-01-00000.nc 

# create rpointer files

echo "$case.cice.r.0$year-01-01-00000.nc"  > ${icdir}/rpointer.ice
echo "./$case.pop.ro.0$year-01-01-00000"   > ${icdir}/rpointer.ocn.ovf
echo "$case.cam.i.0$year-01-01-00000.nc"   > ${icdir}/rpointer.atm
echo "$case.cpl.r.0$year-01-01-00000.nc"   > ${icdir}/rpointer.drv
echo "$case.clm2.r.0$year-01-01-00000.nc"  > ${icdir}/rpointer.clm
echo "$case.rtm.r.0$year-01-01-00000.nc"   > ${icdir}/rpointer.rof
echo "$case.pop.rh.ecosys.nyear1.0$year-01-01-00000.nc"   > ${icdir}/rpointer.ocn.tavg.5
echo "$case.pop.rh.0$year-01-01-00000.nc"   > ${icdir}/rpointer.ocn.tavg

echo "./$case.pop.r.0$year-01-01-00000.nc"    >> ${icdir}/rpointer.ocn.restart
echo "RESTART_FMT=nc"                          >> ${icdir}/rpointer.ocn.restart


#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end

exit
 
 



