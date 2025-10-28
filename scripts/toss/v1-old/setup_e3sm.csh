#!/bin/csh -f

set MACHINE = cori-knl

set EXPERIMENT = test
set RESOLN  = ne30_oECv3_ICG
set COMPSET = A_WCYCL20TRS_CMIP6
set PROJECT = mp9
set TAG = E3SM

set mbr=2

if ($mbr < 10) then
	setenv CASE v1.${COMPSET}.${RESOLN}.${EXPERIMENT}.00${mbr}
else
	setenv CASE v1.${COMPSET}.${RESOLN}.${EXPERIMENT}.0${mbr}
endif

set PATH      = /global/project/projectdirs/ccsm1/people/$USER/
set RUNDIR    = $SCRATCH/$USER/$CASE/run
set BLDDIR    = $SCRATCH/$USER/$CASE/bld
setenv CASEROOT $PATH/cases/e3smv1/$CASE
set TOOLSROOT = /global/homes/n/nanr/CESM_tools/e3sm/

setenv E3SMROOT ${PATH}/e3sm_tags/${TAG}/

#$E3SMROOT/cime/scripts/create_newcase --case MCSP_CMT_5_coupled --compset A_WCYCL20TRS_CMIP6 --res ne30_oECv3_ICG --pecount L --handle-preexisting-dirs u --mach cori-knl --output-root /global/cscratch1/sd/sglanvil/ --script-root /global/homes/s/sglanvil/cases/MCSP_CMT_5_coupled -project mp9

$E3SMROOT/cime/scripts/create_newcase --case $CASE --compset $COMPSET --res $RESOLN --pecount L --handle-preexisting-dirs u --mach $MACHINE --output-root $SCRATCH --script-root $CASEROOT -project $PROJECT

cd $CASEROOT

cp $TOOLSROOT/SourceMods/src.cam/cam_diagnostics.F90 ./SourceMods/src.cam/



