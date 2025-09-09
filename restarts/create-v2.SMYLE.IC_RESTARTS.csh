#! /bin/csh -fxv 

setenv TOOLS_ROOT /global/u2/n/nanr/CESM_tools/e3sm/v2/scripts/v2.SMYLE/
# module load e4s
# spack env activate gcc
# spack load nco
# module load cudatoolkit/11.5

## FOSI alignment
# 1958 = 0306
# ...

# 20230123.GMPAS-JRA1p4.TL319_EC30to60E2r2.anvil.mpaso.rst.0306-11-01_00000.nc
# 20230123.GMPAS-JRA1p4.TL319_EC30to60E2r2.anvil.mpassi.rst.0306-11-01_00000.nc
# /pscratch/sd/l/lvroekel/cycle6_monthly-restarts/restarts_monthly/


#Remove xtime:
#mv v2.LR.piControl.mpaso.rst.0501-01-01_00000.nc v2.LR.piControl.mpaso.rst.0501-01-01_00000.orig.nc
#ncrename -v xtime,xtime.orig v2.LR.piControl.mpaso.rst.0501-01-01_00000.orig.nc v2.LR.piControl.mpaso.rst.0501-01-01_00000.nc
#
#mv v2.LR.piControl.mpassi.rst.0501-01-01_00000.nc v2.LR.piControl.mpassi.rst.0501-01-01_00000.orig.nc
#ncrename -v xtime,xtime.orig v2.LR.piControl.mpassi.rst.0501-01-01_00000.orig.nc v2.LR.piControl.mpassi.rst.0501-01-01_00000.nc

#foreach  year ( 1954 1964 1974 1984 1994 2004 )
# set syr = 1970
# set eyr = 1975
# set syr = 1976
# set eyr = 1980
# set syr = 1981
# set eyr = 2000
set syr = 2020
set eyr = 2020

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 11 )

set case = v21.LR.SMYLE_IC.${year}-${mon}.01

set Picdir = /global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/${case}/
set icdir  = /global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/${case}/${year}-${mon}-01
if (! -d ${Picdir}) then
 mkdir ${Picdir}
endif
if (! -d ${icdir}) then
 mkdir ${icdir}
endif


set doThis99 = 1
if ($doThis99 == 1) then

# atm, lnd initial conditions
set atmcase = eami.HICCUP-ERA5-CATALYST
set lndcase = v21.LR.I20TRELM_CRUNCEP

# names
set atmfname = ${atmcase}.${year}-${mon}-01.ne30np4.L72.c20230203.nc
set lndfname = ${lndcase}.elm.r.${year}-${mon}-01-00000.nc
set roffname = ${lndcase}.mosart.r.${year}-${mon}-01-00000.nc

# directories
set atmdir = /global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/initial_conditions/atm/
#set lnddir = /pscratch/sd/s/sglanvil/archive/s2sLandRun_ICRUELM_final/rest/${year}-${mon}-01-00000/
set lnddir = /pscratch/sd/n/nanr/v21.SMYLE/v21.LR.I20TRELM_CRUNCEP/archive/rest/${year}-${mon}-01-00000/

# rename atm, land IC files
set atmfout = ${case}.eam.i.${year}-${mon}-01-00000.nc
set lndfout = ${case}.elm.r.${year}-${mon}-01-00000.nc
set roffout = ${case}.mosart.r.${year}-${mon}-01-00000.nc

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
# years used for ICs:   0306 (1958) - 0336 (1988)
#1958 = 0306
#1959 = 0307
# ...
#1988 = 0336

set doThis = 1
if ($doThis == 1) then

set ocncase = 20230123.GMPAS-JRA1p4.TL319_EC30to60E2r2.anvil
set first_rest_year = 1958
set ocean_base_year = 306


# Comment:  year translation:  if ($year == 2018 ) set ocnyr = 0366
# years used for ICs:   0306 (1958) - 0366 (2018)
# atmyr 1958 = ocnyr 306
@ offset = $first_rest_year - $ocean_base_year 
@ ocnyr   = $year - $offset
set ocndir = /pscratch/sd/l/lvroekel/cycle6_monthly-restarts/restarts_monthly/

set icefname   = ${ocncase}.mpassi.rst.0${ocnyr}-${mon}-01_00000.nc 
set poprfname  = ${ocncase}.mpaso.rst.0${ocnyr}-${mon}-01_00000.nc  

set icefout   = ${case}.mpassi.rst.${year}-${mon}-01_00000.nc
set poprfout  = ${case}.mpaso.rst.${year}-${mon}-01_00000.nc


echo $icefname
echo $poprfname

cp $ocndir/${icefname}    $icdir/${icefout}
cp $ocndir/${poprfname}   $icdir/${poprfout}.xtime.nc

# fix xtime offline:  fix_xtime.sh (using bash)
# ncrename -v xtime,xtime.orig $icdir/${poprfout}.xtime.nc $icdir/${poprfout}
# rm $icdir/${poprfout}.xtime.nc

ncatted -a OriginalFile,global,a,c,$icefname    $icdir/$icefout
ncatted -a OriginalFile,global,a,c,$poprfname   $icdir/$poprfout

# create rpointer files
echo "$case.eam.r.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.atm
echo "$case.cpl.r.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.drv
echo "./$case.elm.r.$year-${mon}-01-00000.nc"  > ${icdir}/rpointer.lnd
echo "$case.mosart.r.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.rof
echo "$year-${mon}-01_00:00:00"  > ${icdir}/rpointer.ice
echo "$year-${mon}-01_00:00:00"  > ${icdir}/rpointer.ocn

endif	# doThis2

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

endif	# doThis99

# ==================================
# generate perturbed cam.i.restarts
# ==================================
#setenv CYLC_TASK_CYCLE_POINT ${year}-${mon}-01
#./generate_cami_ensemble_offline.py

# bash
 #export CYLC_TASK_CYCLE_POINT=${year}-${mon}-01
 #setenv CYLC_TASK_CYCLE_POINT ${year}-${mon}-01
 #cd ${TOOLS_ROOT}/restarts/
 #PYTHONPATH=/global/cfs/cdirs/ccsm1/people/nanr/e3sm_tags/E3SMv2.1/E3SM/cime/CIME/Tools ./generate_cami_ensemble_offline.py 

end
end

exit
 
 



