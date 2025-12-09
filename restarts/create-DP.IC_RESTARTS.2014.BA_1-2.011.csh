#! /bin/csh -fxv 

#foreach  year ( 1954 1964 1974 1984 1994 2004 )
set syr = 2015
set eyr = 2015

set yearBA1 = 2000
set yearBA2 = 1986

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )

@ yearm1 = $year - 1
set case1 = b.e11.BDP_IC_BA1.f09_g16.${yearm1}-11.01
set case2 = b.e11.BDP_IC_BA2.f09_g16.${yearm1}-11.01
set incase  = b.e11.BDP_IC.f09_g16.${yearm1}-11.01
set incaseBA1  = b.e11.BDP_IC.f09_g16.${yearBA1}-11.01
set incaseBA2  = b.e11.BDP_IC.f09_g16.${yearBA2}-11.01
set outcaseBA1 = b.e11.BDP_IC_BA1.f09_g16.${yearm1}-11.01
set outcaseBA2 = b.e11.BDP_IC_BA2.f09_g16.${yearm1}-11.01

# src 2014 ICs
set srcdir  = /glade/scratch/nanr/DP/ccsm4_init/b.e11.BDP_IC.f09_g16.${yearm1}-11.01/${yearm1}-11-01
set srcdirBA1  = /glade/scratch/nanr/DP/ccsm4_init/b.e11.BDP_IC.f09_g16.${yearBA1}-11.01/${yearBA1}-11-01
set srcdirBA2  = /glade/scratch/nanr/DP/ccsm4_init/b.e11.BDP_IC.f09_g16.${yearBA2}-11.01/${yearBA2}-11-01

# create new restart IC directories
set PicdirBA1 = /glade/scratch/nanr/DP/ccsm4_init/{$case1}/
set icdirBA1  = /glade/scratch/nanr/DP/ccsm4_init/{$case1}/${yearm1}-11-01
set PicdirBA2 = /glade/scratch/nanr/DP/ccsm4_init/{$case2}/
set icdirBA2  = /glade/scratch/nanr/DP/ccsm4_init/{$case2}/${yearm1}-11-01
if (! -d ${PicdirBA1}) then
 mkdir ${PicdirBA1}
endif
if (! -d ${icdirBA1}) then
 mkdir ${icdirBA1}
endif

if (! -d ${PicdirBA2}) then
 mkdir ${PicdirBA2}
endif
if (! -d ${icdirBA2}) then
 mkdir ${icdirBA2}
endif



# atm, lnd initial conditions

set atmfnameBA1 = ${incaseBA1}.cam.i.${yearBA1}-11-01-00000.nc
set atmfnameBA2 = ${incaseBA2}.cam.i.${yearBA2}-11-01-00000.nc
set lndfname = ${incase}.clm2.r.${yearm1}-11-01-00000.nc
set rtmfname = ${incase}.rtm.r.${yearm1}-11-01-00000.nc
set icefname = ${incase}.cice.r.${yearm1}-11-01-00000.nc
set ocnfname = ${incase}.pop.r.${yearm1}-11-01-00000.nc
set orofname = ${incase}.pop.ro.${yearm1}-11-01-00000
set oyrfname = ${incase}.pop.rh.ecosys.nyear1.${yearm1}-11-01-00000.nc

# rename atm, land IC files
set atmfout1 = ${outcaseBA1}.cam.i.${yearm1}-11-01-00000.nc
set lndfout1 = ${outcaseBA1}.clm2.r.${yearm1}-11-01-00000.nc
set rtmfout1 = ${outcaseBA1}.rtm.r.${yearm1}-11-01-00000.nc
set icefout1 = ${outcaseBA1}.cice.r.${yearm1}-11-01-00000.nc
set ocnfout1 = ${outcaseBA1}.pop.r.${yearm1}-11-01-00000.nc
set orofout1   = ${outcaseBA1}.pop.ro.${yearm1}-11-01-00000
set oyrfout1 = ${outcaseBA1}.pop.rh.ecosys.nyear1.${yearm1}-11-01-00000.nc

set atmfout2 = ${outcaseBA2}.cam.i.${yearm1}-11-01-00000.nc
set lndfout2 = ${outcaseBA2}.clm2.r.${yearm1}-11-01-00000.nc
set rtmfout2 = ${outcaseBA2}.rtm.r.${yearm1}-11-01-00000.nc
set icefout2 = ${outcaseBA2}.cice.r.${yearm1}-11-01-00000.nc
set ocnfout2 = ${outcaseBA2}.pop.r.${yearm1}-11-01-00000.nc
set orofout2   = ${outcaseBA2}.pop.ro.${yearm1}-11-01-00000
set oyrfout2 = ${outcaseBA2}.pop.rh.ecosys.nyear1.${yearm1}-11-01-00000.nc


echo $srcdirBA1/${atmfnameBA1} $icdirBA1/$atmfout1
cp $srcdirBA1/${atmfnameBA1} $icdirBA1/$atmfout1
cp $srcdir/${lndfname} $icdirBA1/$lndfout1
cp $srcdir/${rtmfname} $icdirBA1/$rtmfout1
cp $srcdir/${icefname} $icdirBA1/$icefout1
cp $srcdir/${ocnfname} $icdirBA1/$ocnfout1
cp $srcdir/${orofname} $icdirBA1/$orofout1
cp $srcdir/${oyrfname} $icdirBA1/$oyrfout1

cp $srcdirBA2/${atmfnameBA2} $icdirBA2/$atmfout2
cp $srcdir/${lndfname} $icdirBA2/$lndfout2
cp $srcdir/${rtmfname} $icdirBA2/$rtmfout2
cp $srcdir/${icefname} $icdirBA2/$icefout2
cp $srcdir/${ocnfname} $icdirBA2/$ocnfout2
cp $srcdir/${orofname} $icdirBA2/$orofout2
cp $srcdir/${oyrfname} $icdirBA2/$oyrfout2
ncatted -a OriginalFile,global,a,c,$atmfnameBA1 $icdirBA1/$atmfout1
#ncatted -a OriginalFile,global,a,c,$lndfname $icdirBA1/$lndfout1
#ncatted -a OriginalFile,global,a,c,$icefname $icdirBA1/$icefout1
#ncatted -a OriginalFile,global,a,c,$ocnfname $icdirBA1/$ocnfout1
#ncatted -a OriginalFile,global,a,c,$rtmfname $icdirBA1/$rtmfout1
#ncatted -a OriginalFile,global,a,c,$nyearfname $icdirBA1/$nyearfout1

ncatted -a OriginalFile,global,a,c,$atmfnameBA2 $icdirBA2/$atmfout2
#ncatted -a OriginalFile,global,a,c,$lndfname $icdirBA2/$lndfout2
#ncatted -a OriginalFile,global,a,c,$icefname $icdirBA2/$icefout2
#ncatted -a OriginalFile,global,a,c,$ocnfname $icdirBA2/$ocnfout2
#ncatted -a OriginalFile,global,a,c,$rtmfname $icdirBA2/$rtmfout2
#ncatted -a OriginalFile,global,a,c,$nyearfname $icdirBA2/$nyearfout2

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

echo "$case1.cice.r.$yearm1-11-01-00000.nc"  > ${icdirBA1}/rpointer.ice
echo "./$case1.pop.ro.$yearm1-11-01-00000"   > ${icdirBA1}/rpointer.ocn.ovf
echo "$case1.cam.r.$yearm1-11-01-00000.nc"   > ${icdirBA1}/rpointer.atm
echo "$case1.cpl.r.$yearm1-11-01-00000.nc"   > ${icdirBA1}/rpointer.drv
echo "$case1.clm2.r.$yearm1-11-01-00000.nc"  > ${icdirBA1}/rpointer.clm
echo "$case1.rtm.r.$yearm1-11-01-00000.nc"   > ${icdirBA1}/rpointer.rof
echo "$case1.pop.rh.ecosys.nyear1.$yearm1-11-01-00000.nc"   > ${icdirBA1}/rpointer.ocn.tavg.5

if (-e ${icdirBA1}/rpointer.ocn.restart) then
	rm ${icdirBA1}/rpointer.ocn.restart
endif
echo "./$case1.pop.r.$yearm1-11-01-00000.nc"    >> ${icdirBA1}/rpointer.ocn.restart
echo "RESTART_FMT=nc"                           >> ${icdirBA1}/rpointer.ocn.restart

echo "$case2.cice.r.$yearm1-11-01-00000.nc"  > ${icdirBA2}/rpointer.ice
echo "./$case2.pop.ro.$yearm1-11-01-00000"   > ${icdirBA2}/rpointer.ocn.ovf
echo "$case2.cam.r.$yearm1-11-01-00000.nc"   > ${icdirBA2}/rpointer.atm
echo "$case2.cpl.r.$yearm1-11-01-00000.nc"   > ${icdirBA2}/rpointer.drv
echo "$case2.clm2.r.$yearm1-11-01-00000.nc"  > ${icdirBA2}/rpointer.clm
echo "$case2.rtm.r.$yearm1-11-01-00000.nc"   > ${icdirBA2}/rpointer.rof
echo "$case2.pop.rh.ecosys.nyear1.$yearm1-11-01-00000.nc"   > ${icdirBA2}/rpointer.ocn.tavg.5

if (-e ${icdirBA2}/rpointer.ocn.restart) then
	rm ${icdirBA2}/rpointer.ocn.restart
endif
echo "./$case2.pop.r.$yearm1-11-01-00000.nc"    >> ${icdirBA2}/rpointer.ocn.restart
echo "RESTART_FMT=nc"                           >> ${icdirBA2}/rpointer.ocn.restart

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end

exit
 
 



