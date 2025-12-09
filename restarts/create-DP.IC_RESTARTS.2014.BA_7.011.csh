#! /bin/csh -fxv 

#foreach  year ( 1954 1964 1974 1984 1994 2004 )
set syr = 2015
set eyr = 2015

# 2) BA7:   Use normal DPLE restart files for 2014-11-01 in all respects EXCEPT:
# b.e11.B20TRC5CNBDRD.f09_g16.034.cice.r.1954_2005-11-01-00000.clim.nc   (climatological Nov. 1 from LENS #34)
# b.e11.B20TRC5CNBDRD.f09_g16.034.pop.r.2014-11-01-00000.FOSIanomTS.nc  (FOSI anomalous T/S added to above clim)

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )

@ yearm1 = $year - 1
set case1 = b.e11.BDP_IC_BA7.f09_g16.${yearm1}-11.01
set incase  = b.e11.BDP_IC.f09_g16.${yearm1}-11.01
set incaseBA7ice  = b.e11.B20TRC5CNBDRD.f09_g16.034
set incaseBA7pop  = b.e11.B20TRC5CNBDRD.f09_g16.034
set outcaseBA7 = b.e11.BDP_IC_BA7.f09_g16.${yearm1}-11.01

# src 2014 ICs
set srcdir  = /glade/scratch/nanr/DP/ccsm4_init/b.e11.BDP_IC.f09_g16.${yearm1}-11.01/${yearm1}-11-01
set srcdirBA7o  = /glade/work/emaroon/python/coldblob/ba_atmos_init_experiments
set srcdirBA7o  = /glade/work/emaroon/python/coldblob/ba_atmos_init_experiments/restartfiles/
set srcdirBA7i  = /glade/scratch/yeager/BA34/

#ocn: /glade/work/emaroon/python/coldblob/ba_atmos_init_experiments/b.e11.B20TRC5CNBDRD.f09_g16.034.pop.r.2014-11-01-00000.EN4anomTS.nc
#ice: /glade/scratch/yeager/BA34/b.e11.B20TRC5CNBDRD.f09_g16.034.cice.r.1954_2005-11-01-00000.clim.nc

# create new restart IC directories
set PicdirBA7 = /glade/scratch/nanr/DP/ccsm4_init/{$case1}/
set  icdirBA7 = /glade/scratch/nanr/DP/ccsm4_init/{$case1}/${yearm1}-11-01
if (! -d ${PicdirBA7}) then
 mkdir   ${PicdirBA7}
endif
if (! -d ${icdirBA7}) then
 mkdir   ${icdirBA7}
endif



# atm, lnd initial conditions

set atmfname = ${incase}.cam.i.${yearm1}-11-01-00000.nc
set lndfname = ${incase}.clm2.r.${yearm1}-11-01-00000.nc
set rtmfname = ${incase}.rtm.r.${yearm1}-11-01-00000.nc
set icefnameBA7  = ${incaseBA7ice}.cice.r.1954_2005-11-01-00000.clim.nc
set ocnfnameBA7  = ${incaseBA7pop}.pop.r.2014-11-01-00000.EN4_TEMP_CLIMO_SALT.nc
set orofname = ${incase}.pop.ro.${yearm1}-11-01-00000
set oyrfname = ${incase}.pop.rh.ecosys.nyear1.${yearm1}-11-01-00000.nc

# rename atm, land IC files
set atmfout1 = ${outcaseBA7}.cam.i.${yearm1}-11-01-00000.nc
set lndfout1 = ${outcaseBA7}.clm2.r.${yearm1}-11-01-00000.nc
set rtmfout1 = ${outcaseBA7}.rtm.r.${yearm1}-11-01-00000.nc
set icefout1 = ${outcaseBA7}.cice.r.${yearm1}-11-01-00000.nc
set ocnfout1 = ${outcaseBA7}.pop.r.${yearm1}-11-01-00000.nc
set orofout1 = ${outcaseBA7}.pop.ro.${yearm1}-11-01-00000
set oyrfout1 = ${outcaseBA7}.pop.rh.ecosys.nyear1.${yearm1}-11-01-00000.nc



#echo $srcdirBA7/${atmfnameBA7} $icdirBA7/$atmfout1
cp $srcdir/${atmfname}    $icdirBA7/$atmfout1
cp $srcdir/${lndfname}    $icdirBA7/$lndfout1
cp $srcdir/${rtmfname}    $icdirBA7/$rtmfout1
cp $srcdirBA7i/${icefnameBA7} $icdirBA7/$icefout1
cp $srcdirBA7o/${ocnfnameBA7} $icdirBA7/$ocnfout1
cp $srcdir/${orofname}    $icdirBA7/$orofout1
cp $srcdir/${oyrfname}    $icdirBA7/$oyrfout1

#ncatted -a OriginalFile,global,a,c,$atmfnameBA7 $icdirBA7/$atmfout1
#ncatted -a OriginalFile,global,a,c,$lndfname $icdirBA7/$lndfout1
 ncatted -a OriginalFile,global,a,c,$icefnameBA7 $icdirBA7/$icefout1
 ncatted -a OriginalFile,global,a,c,$ocnfnameBA7 $icdirBA7/$ocnfout1
#ncatted -a OriginalFile,global,a,c,$rtmfname $icdirBA7/$rtmfout1
#ncatted -a OriginalFile,global,a,c,$nyearfname $icdirBA7/$nyearfout1


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

echo "$case1.cice.r.$yearm1-11-01-00000.nc"  > ${icdirBA7}/rpointer.ice
echo "./$case1.pop.ro.$yearm1-11-01-00000"   > ${icdirBA7}/rpointer.ocn.ovf
echo "$case1.cam.r.$yearm1-11-01-00000.nc"   > ${icdirBA7}/rpointer.atm
echo "$case1.cpl.r.$yearm1-11-01-00000.nc"   > ${icdirBA7}/rpointer.drv
echo "$case1.clm2.r.$yearm1-11-01-00000.nc"  > ${icdirBA7}/rpointer.clm
echo "$case1.rtm.r.$yearm1-11-01-00000.nc"   > ${icdirBA7}/rpointer.rof
echo "$case1.pop.rh.ecosys.nyear1.$yearm1-11-01-00000.nc"   > ${icdirBA7}/rpointer.ocn.tavg.5

if (-e ${icdirBA7}/rpointer.ocn.restart) then
	rm ${icdirBA7}/rpointer.ocn.restart
endif
echo "./$case1.pop.r.$yearm1-11-01-00000.nc"    >> ${icdirBA7}/rpointer.ocn.restart
echo "RESTART_FMT=nc"                           >> ${icdirBA7}/rpointer.ocn.restart



#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end

exit
 
 



