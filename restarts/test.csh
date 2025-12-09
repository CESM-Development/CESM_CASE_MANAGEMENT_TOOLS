#! /bin/csh -fxv 

#foreach  year ( 1954 1964 1974 1984 1994 2004 )
set syr = 2017
set eyr = 2017

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )

@ yearm1 = $year - 1
#set case = b.e11.BDP_IC.f09_g16.${yearm1}-11.01
set case = g.DPLE.GECOIAF.T62_g16.010.chey.${yearm1}-11.01
#set icdir = /glade/p/cesm/cseg/inputdata/ccsm4_init/{$case} 
set Picdir = /glade/scratch/nanr/DP/ccsm4_init/{$case}/
set icdir  = /glade/scratch/nanr/DP/ccsm4_init/{$case}/${yearm1}-11-01
if (! -d ${Picdir}) then
 mkdir ${Picdir}
endif
if (! -d ${icdir}) then
 mkdir ${icdir}
endif

# atm, lnd initial conditions
set atmcase20th =  b.e11.B20TRC5CNBDRD.f09_g16.034
set atmcaseRCP  =  b.e11.BRCP85C5CNBDRD.f09_g16.034x
if ($yearm1 >= 2006) then
	set atmcase = ${atmcaseRCP}
else
	set atmcase = ${atmcase20th}
endif
set atmfname = ${atmcase}.cam.i.${yearm1}-11-01-00000.nc
set lndfname = ${atmcase}.clm2.r.${yearm1}-11-01-00000.nc
set rtmfname = ${atmcase}.rtm.r.${yearm1}-11-01-00000.nc
# set atmdir = /glade/p/cesm0005/csm/${atmcase}/atm/init/
# set lnddir = /glade/p/cesm0005/csm/${atmcase}/lnd/rest/
# set rtmdir = /glade/p/cesm0005/csm/${atmcase}/rof/rest/
set atmdir = /glade/scratch/nanr/archive/${atmcase}/atm/init/
set lnddir = /glade/scratch/nanr/archive/${atmcase}/lnd/rest/
set rtmdir = /glade/scratch/nanr/archive/${atmcase}/rof/rest/

# rename atm, land IC files
set atmfout = ${case}.cam.i.${yearm1}-11-01-00000.nc
set lndfout = ${case}.clm2.r.${yearm1}-11-01-00000.nc
set rtmfout = ${case}.rtm.r.${yearm1}-11-01-00000.nc
#cp $atmdir/${atmfname} $icdir/$atmfout
#cp $lnddir/${lndfname} $icdir/$lndfout
#cp $rtmdir/${rtmfname} $icdir/$rtmfout
#ncatted -a OriginalFile,global,a,c,$atmfname $icdir/$atmfout
#ncatted -a OriginalFile,global,a,c,$lndfname $icdir/$lndfout
#ncatted -a OriginalFile,global,a,c,$rtmfname $icdir/$rtmfout

# ocn/ice
# set ocncase = g.e11_LENS.GECOIAF.T62_g16.009		#Years 1955-2009
# set ocncase = g.e11_LENS.GECOIAF.T62_g16.011
set ocncase = g.DPLE.GECOIAF.T62_g16.010.chey
set first_rest_year = 1954
set ocean_base_year = 255
#set ocndir = /glade/p/cesm/omwg_dev/hpss-mirror/$ocncase/ocn/rest/
#set icedir = /glade/p/cesm/omwg_dev/hpss-mirror/$ocncase/ice/rest/
# (2016-11)
set ocndir = /glade/scratch/yeager/archive/g.DPLE.GECOIAF.T62_g16.010.chey/ocn/rest/
set icedir = /glade/scratch/yeager/archive/g.DPLE.GECOIAF.T62_g16.010.chey/ice/rest/

# Comment:  year translation:  if ($year == 2014 ) set ocnyr = 0247
# atmyr 1954 = ocnyr 255
@ offset = $first_rest_year - $ocean_base_year + 1
# @ ocnyr   = $year - 1699
@ ocnyr   = $year - $offset
echo "ocnyr = " $ocnyr

set icefout = ${case}.cice.r.${yearm1}-11-01-00000.nc
set lndfout = ${case}.clm2.r.${yearm1}-11-01-00000.nc
set rtmfout = ${case}.rtm.r.${yearm1}-11-01-00000.nc

set icefname   = ${ocncase}.cice.r.0${ocnyr}-11-01-00000.nc 
set poprfname  = ${ocncase}.pop.r.0${ocnyr}-11-01-00000.nc  
set poprofname = ${ocncase}.pop.ro.0${ocnyr}-11-01-00000    
set poprhfname = ${ocncase}.pop.rh.ecosys.nyear1.0${ocnyr}-11-01-00000.nc 

set icefout   = ${case}.cice.r.${yearm1}-11-01-00000.nc
set poprfout  = ${case}.pop.r.${yearm1}-11-01-00000.nc
set poprofout = ${case}.pop.ro.${yearm1}-11-01-00000 
set poprhfout = ${case}.pop.rh.ecosys.nyear1.${yearm1}-11-01-00000.nc

#cp $icedir/${icefname}    $icdir/${icefout}
#cp $ocndir/${poprfname}   $icdir/${poprfout}
#cp $ocndir/${poprofname}  $icdir/${poprofout}
#cp $ocndir/${poprhfname}  $icdir/${poprhfout}

#ncatted -a OriginalFile,global,a,c,$icefname    $icdir/$icefout
#ncatted -a OriginalFile,global,a,c,$poprfname   $icdir/$poprfout
##ncatted -a OriginalFile,global,a,c,$poprofname  $icdir/$poprofout
#ncatted -a OriginalFile,global,a,c,$poprhfname  $icdir/$poprhfout

# create rpointer files

echo "$case.cice.r.$yearm1-11-01-00000.nc"  > ${icdir}/rpointer.ice
echo "./$case.pop.ro.$yearm1-11-01-00000"   > ${icdir}/rpointer.ocn.ovf
echo "$case.cam.r.$yearm1-11-01-00000.nc"   > ${icdir}/rpointer.atm
echo "$case.cpl.r.$yearm1-11-01-00000.nc"   > ${icdir}/rpointer.drv
echo "$case.clm2.r.$yearm1-11-01-00000.nc"  > ${icdir}/rpointer.clm
echo "$case.rtm.r.$yearm1-11-01-00000.nc"   > ${icdir}/rpointer.rof
echo "$case.pop.rh.ecosys.nyear1.$yearm1-11-01-00000.nc"   > ${icdir}/rpointer.ocn.tavg.5

#if (-e ${icdir}/rpointer.ocn.restart) then
	#rm ${icdir}/rpointer.ocn.restart
#endif
#echo "./$case.pop.r.$yearm1-11-01-00000.nc"    >> ${icdir}/rpointer.ocn.restart
#echo "RESTART_FMT=nc"                          >> ${icdir}/rpointer.ocn.restart

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end

exit
 
 



