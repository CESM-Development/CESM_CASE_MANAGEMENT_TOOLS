#!/bin/csh -f

set MACHINE = cori-knl

set EXPERIMENT = 4CO2
set RESOLN  = ne30_oECv3_ICG
set COMPSET = A_WCYCL20TRS_CMIP6
set PROJECT = mp9
set TAG = E3SMv2


set mbr=2

if ($mbr < 10) then
	setenv CASE v2.LR.${EXPERIMENT}.00${mbr}
else
	setenv CASE v2.LR.${EXPERIMENT}.0${mbr}
endif

set PATH      = /global/project/projectdirs/ccsm1/people/$USER/
set RUNDIR    = $SCRATCH/$USER/$CASE/run
set BLDDIR    = $SCRATCH/$USER/$CASE/bld
setenv CASEROOT $PATH/cases/e3smv2/$CASE
set TOOLSROOT = /global/homes/n/nanr/CESM_tools/e3sm/e3sm2-hosing/

setenv E3SMROOT ${PATH}/e3sm_tags/${TAG}/

#$E3SMROOT/cime/scripts/create_newcase --case MCSP_CMT_5_coupled --compset A_WCYCL20TRS_CMIP6 --res ne30_oECv3_ICG --pecount L --handle-preexisting-dirs u --mach cori-knl --output-root /global/cscratch1/sd/sglanvil/ --script-root /global/homes/s/sglanvil/cases/MCSP_CMT_5_coupled -project mp9

$E3SMROOT/cime/scripts/create_newcase --case $CASE --compset $COMPSET --res $RESOLN --pecount L --handle-preexisting-dirs u --mach $MACHINE --output-root $SCRATCH --script-root $CASEROOT -project $PROJECT

cd $CASEROOT
./xmlchange RUN_REFCASE=v2.LR.1pctCO2_0101
./xmlchange RUN_REFDATE=0151-01-01
./xmlchange RUN_STARTDATE=0151-01-01

cp $TOOLSROOT/SourceMods/src.cam/cam_diagnostics.F90 ./SourceMods/src.cam/

cp /global/cscratch1/sd/lvroekel/hosing_experiments/0151-01-01-00000/* $RUNDIR/



