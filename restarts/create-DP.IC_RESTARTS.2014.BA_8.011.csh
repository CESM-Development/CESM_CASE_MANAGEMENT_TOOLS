#! /bin/csh -fxv 

#foreach  year ( 1954 1964 1974 1984 1994 2004 )
set syr = 2015
set eyr = 2015

# 2) BA8:   Use normal DPLE restart files for 2014-11-01 in all respects EXCEPT:
# BA8: 11/01/2014 initialization from FOSI ocean/ice state, the same Land IC as used in the DPLE, and this new atmospheric IC file:
# /glade/work/emaroon/ba_cases/atmos_ic/EI_fv_0.9x1.25_L30.cam2.i.2014-11-01-00000.nc

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )

@ yearm1 = $year - 1
set case1 = b.e11.BDP_IC_BA8.f09_g16.${yearm1}-11.01
set incase  = b.e11.BDP_IC.f09_g16.${yearm1}-11.01
set incaseBA8ice  = b.e11.B20TRC5CNBDRD.f09_g16.034
set incaseBA8pop  = b.e11.B20TRC5CNBDRD.f09_g16.034
set incaseBA8atm  = EI_fv_0.9x1.25_L30
set outcaseBA8 = b.e11.BDP_IC_BA8.f09_g16.${yearm1}-11.01

# src 2014 ICs
set srcdir  = /glade/scratch/nanr/DP/ccsm4_init/b.e11.BDP_IC.f09_g16.${yearm1}-11.01/${yearm1}-11-01
set srcdirBA8   = /glade/scratch/yeager/BA34/
set srcdirBA8a  = /glade/work/emaroon/ba_cases/atmos_ic/


# create new restart IC directories
set PicdirBA8 = /glade/scratch/nanr/DP/ccsm4_init/{$case1}/
set  icdirBA8 = /glade/scratch/nanr/DP/ccsm4_init/{$case1}/${yearm1}-11-01
if (! -d ${PicdirBA8}) then
 mkdir   ${PicdirBA8}
endif
if (! -d ${icdirBA8}) then
 mkdir   ${icdirBA8}
endif



# atm, lnd initial conditions

set atmfnameBA8 = ${incaseBA8atm}.cam2.i.${yearm1}-11-01-00000.nc
set lndfname = ${incase}.clm2.r.${yearm1}-11-01-00000.nc
set rtmfname = ${incase}.rtm.r.${yearm1}-11-01-00000.nc
set icefnameBA8  = ${incaseBA8ice}.cice.r.1954_2005-11-01-00000.clim.nc
set ocnfnameBA8  = ${incaseBA8pop}.pop.r.2014-11-01-00000.FOSIanomTS.nc
set orofname = ${incase}.pop.ro.${yearm1}-11-01-00000
set oyrfname = ${incase}.pop.rh.ecosys.nyear1.${yearm1}-11-01-00000.nc

# rename atm, land IC files
set atmfout1 = ${outcaseBA8}.cam.i.${yearm1}-11-01-00000.nc
set lndfout1 = ${outcaseBA8}.clm2.r.${yearm1}-11-01-00000.nc
set rtmfout1 = ${outcaseBA8}.rtm.r.${yearm1}-11-01-00000.nc
set icefout1 = ${outcaseBA8}.cice.r.${yearm1}-11-01-00000.nc
set ocnfout1 = ${outcaseBA8}.pop.r.${yearm1}-11-01-00000.nc
set orofout1 = ${outcaseBA8}.pop.ro.${yearm1}-11-01-00000
set oyrfout1 = ${outcaseBA8}.pop.rh.ecosys.nyear1.${yearm1}-11-01-00000.nc



#echo $srcdirBA8/${atmfnameBA8} $icdirBA8/$atmfout1
cp $srcdirBA8a/${atmfnameBA8}    $icdirBA8/$atmfout1
cp $srcdir/${lndfname}           $icdirBA8/$lndfout1
cp $srcdir/${rtmfname}           $icdirBA8/$rtmfout1
cp $srcdirBA8/${icefnameBA8}     $icdirBA8/$icefout1
cp $srcdirBA8/${ocnfnameBA8}     $icdirBA8/$ocnfout1
cp $srcdir/${orofname}           $icdirBA8/$orofout1
cp $srcdir/${oyrfname}           $icdirBA8/$oyrfout1

 ncatted -a OriginalFile,global,a,c,$atmfnameBA8 $icdirBA8/$atmfout1
#ncatted -a OriginalFile,global,a,c,$lndfname $icdirBA8/$lndfout1
 ncatted -a OriginalFile,global,a,c,$icefnameBA8 $icdirBA8/$icefout1
 ncatted -a OriginalFile,global,a,c,$ocnfnameBA8 $icdirBA8/$ocnfout1
#ncatted -a OriginalFile,global,a,c,$rtmfname $icdirBA8/$rtmfout1
#ncatted -a OriginalFile,global,a,c,$nyearfname $icdirBA8/$nyearfout1


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

echo "$case1.cice.r.$yearm1-11-01-00000.nc"  > ${icdirBA8}/rpointer.ice
echo "./$case1.pop.ro.$yearm1-11-01-00000"   > ${icdirBA8}/rpointer.ocn.ovf
echo "$case1.cam.r.$yearm1-11-01-00000.nc"   > ${icdirBA8}/rpointer.atm
echo "$case1.cpl.r.$yearm1-11-01-00000.nc"   > ${icdirBA8}/rpointer.drv
echo "$case1.clm2.r.$yearm1-11-01-00000.nc"  > ${icdirBA8}/rpointer.clm
echo "$case1.rtm.r.$yearm1-11-01-00000.nc"   > ${icdirBA8}/rpointer.rof
echo "$case1.pop.rh.ecosys.nyear1.$yearm1-11-01-00000.nc"   > ${icdirBA8}/rpointer.ocn.tavg.5

if (-e ${icdirBA8}/rpointer.ocn.restart) then
	rm ${icdirBA8}/rpointer.ocn.restart
endif
echo "./$case1.pop.r.$yearm1-11-01-00000.nc"    >> ${icdirBA8}/rpointer.ocn.restart
echo "RESTART_FMT=nc"                           >> ${icdirBA8}/rpointer.ocn.restart



#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end

exit
 
 



