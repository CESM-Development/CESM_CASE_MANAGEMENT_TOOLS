#! /bin/csh -fxv 

#foreach  year ( 1954 1964 1974 1984 1994 2004 )
set syr = 2015
set eyr = 2015

set yearBA3 = 2004

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )

@ yearm1 = $year - 1
set case1 = b.e11.BDP_IC_BA3.f09_g16.${yearm1}-11.01
set incase  = b.e11.BDP_IC.f09_g16.${yearm1}-11.01
set incaseBA3  = b.e11.BDP_IC.f09_g16.${yearBA3}-11.01
set outcaseBA3 = b.e11.BDP_IC_BA3.f09_g16.${yearm1}-11.01

# src 2014 ICs
set srcdir  = /glade/scratch/nanr/DP/ccsm4_init/b.e11.BDP_IC.f09_g16.${yearm1}-11.01/${yearm1}-11-01
set srcdirBA3  = /glade/scratch/nanr/DP/ccsm4_init/b.e11.BDP_IC.f09_g16.${yearBA3}-11.01/${yearBA3}-11-01

# create new restart IC directories
set PicdirBA3 = /glade/scratch/nanr/DP/ccsm4_init/{$case1}/
set icdirBA3  = /glade/scratch/nanr/DP/ccsm4_init/{$case1}/${yearm1}-11-01
if (! -d ${PicdirBA3}) then
 mkdir ${PicdirBA3}
endif
if (! -d ${icdirBA3}) then
 mkdir ${icdirBA3}
endif



# atm, lnd initial conditions

set atmfnameBA3 = ${incaseBA3}.cam.i.${yearBA3}-11-01-00000.nc
set lndfname = ${incase}.clm2.r.${yearm1}-11-01-00000.nc
set rtmfname = ${incase}.rtm.r.${yearm1}-11-01-00000.nc
set icefname = ${incase}.cice.r.${yearm1}-11-01-00000.nc
set ocnfname = ${incase}.pop.r.${yearm1}-11-01-00000.nc
set orofname = ${incase}.pop.ro.${yearm1}-11-01-00000
set oyrfname = ${incase}.pop.rh.ecosys.nyear1.${yearm1}-11-01-00000.nc

# rename atm, land IC files
set atmfout1 = ${outcaseBA3}.cam.i.${yearm1}-11-01-00000.nc
set lndfout1 = ${outcaseBA3}.clm2.r.${yearm1}-11-01-00000.nc
set rtmfout1 = ${outcaseBA3}.rtm.r.${yearm1}-11-01-00000.nc
set icefout1 = ${outcaseBA3}.cice.r.${yearm1}-11-01-00000.nc
set ocnfout1 = ${outcaseBA3}.pop.r.${yearm1}-11-01-00000.nc
set orofout1   = ${outcaseBA3}.pop.ro.${yearm1}-11-01-00000
set oyrfout1 = ${outcaseBA3}.pop.rh.ecosys.nyear1.${yearm1}-11-01-00000.nc



echo $srcdirBA3/${atmfnameBA3} $icdirBA3/$atmfout1
cp $srcdirBA3/${atmfnameBA3} $icdirBA3/$atmfout1
cp $srcdir/${lndfname} $icdirBA3/$lndfout1
cp $srcdir/${rtmfname} $icdirBA3/$rtmfout1
cp $srcdir/${icefname} $icdirBA3/$icefout1
cp $srcdir/${ocnfname} $icdirBA3/$ocnfout1
cp $srcdir/${orofname} $icdirBA3/$orofout1
cp $srcdir/${oyrfname} $icdirBA3/$oyrfout1

ncatted -a OriginalFile,global,a,c,$atmfnameBA3 $icdirBA3/$atmfout1
#ncatted -a OriginalFile,global,a,c,$lndfname $icdirBA3/$lndfout1
#ncatted -a OriginalFile,global,a,c,$icefname $icdirBA3/$icefout1
#ncatted -a OriginalFile,global,a,c,$ocnfname $icdirBA3/$ocnfout1
#ncatted -a OriginalFile,global,a,c,$rtmfname $icdirBA3/$rtmfout1
#ncatted -a OriginalFile,global,a,c,$nyearfname $icdirBA3/$nyearfout1


# set ocncase = g.e11_LENS.GECOIAF.T62_g16.009		#Years 1955-2009
#set ocncase = g.e11_LENS.GECOIAF.T62_g16.010
#set first_rest_year = 1954
#set ocean_base_year = 255
#set ocndir = /glade/p/cesm/omwg_dev/hpss-mirror/$ocncase/ocn/rest/
#set icedir = /glade/p/cesm/omwg_dev/hpss-mirror/$ocncase/ice/rest/


# Comment:  year translation:  if ($year == 2014 ) set ocnyr = 0247
# atmyr 1954 = ocnyr 255
#@ offset = $first_rest_year - $ocean_base_year + 1
# @ ocnyr   = $year - 1699
#@ ocnyr   = $year - $offset
#echo "ocnyr = " $ocnyr
#set icefout = ${case}.cice.r.${yearm1}-11-01-00000.nc
#set lndfout = ${case}.clm2.r.${yearm1}-11-01-00000.nc
#set rtmfout = ${case}.rtm.r.${yearm1}-11-01-00000.nc
#
#set icefname   = ${ocncase}.cice.r.0${ocnyr}-11-01-00000.nc 
#set poprfname  = ${ocncase}.pop.r.0${ocnyr}-11-01-00000.nc  
#set poprofname = ${ocncase}.pop.ro.0${ocnyr}-11-01-00000    
#set poprhfname = ${ocncase}.pop.rh.ecosys.nyear1.0${ocnyr}-11-01-00000.nc 
#
#set icefout   = ${case}.cice.r.${yearm1}-11-01-00000.nc
#set poprfout  = ${case}.pop.r.${yearm1}-11-01-00000.nc
#set poprofout = ${case}.pop.ro.${yearm1}-11-01-00000 
#set poprhfout = ${case}.pop.rh.ecosys.nyear1.${yearm1}-11-01-00000.nc
#
#cp $icedir/${icefname}    $icdir/${icefout}
#cp $ocndir/${poprfname}   $icdir/${poprfout}
#cp $ocndir/${poprofname}  $icdir/${poprofout}
#cp $ocndir/${poprhfname}  $icdir/${poprhfout}
#
#ncatted -a OriginalFile,global,a,c,$icefname    $icdir/$icefout
#ncatted -a OriginalFile,global,a,c,$poprfname   $icdir/$poprfout
##ncatted -a OriginalFile,global,a,c,$poprofname  $icdir/$poprofout
#ncatted -a OriginalFile,global,a,c,$poprhfname  $icdir/$poprhfout
#
# create rpointer files

echo "$case1.cice.r.$yearm1-11-01-00000.nc"  > ${icdirBA3}/rpointer.ice
echo "./$case1.pop.ro.$yearm1-11-01-00000"   > ${icdirBA3}/rpointer.ocn.ovf
echo "$case1.cam.r.$yearm1-11-01-00000.nc"   > ${icdirBA3}/rpointer.atm
echo "$case1.cpl.r.$yearm1-11-01-00000.nc"   > ${icdirBA3}/rpointer.drv
echo "$case1.clm2.r.$yearm1-11-01-00000.nc"  > ${icdirBA3}/rpointer.clm
echo "$case1.rtm.r.$yearm1-11-01-00000.nc"   > ${icdirBA3}/rpointer.rof
echo "$case1.pop.rh.ecosys.nyear1.$yearm1-11-01-00000.nc"   > ${icdirBA3}/rpointer.ocn.tavg.5

if (-e ${icdirBA3}/rpointer.ocn.restart) then
	rm ${icdirBA3}/rpointer.ocn.restart
endif
echo "./$case1.pop.r.$yearm1-11-01-00000.nc"    >> ${icdirBA3}/rpointer.ocn.restart
echo "RESTART_FMT=nc"                           >> ${icdirBA3}/rpointer.ocn.restart



#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end

exit
 
 



