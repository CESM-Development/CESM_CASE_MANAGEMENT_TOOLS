#!/bin/csh -f

set MACHINE = cori-knl

set EXPERIMENT = LE-v1
set RESOLN       = ne30_oECv3_ICG
set COMPSET      = A_WCYCL20TRS_CMIP6
set COMPSETSHORT = 20TR_CMIP6
set PROJECT = mp9
set TAG = E3SM
set TAG = e3sm-le-v1

set mbr=5

#Start Years        210, 320, 365, 410, 480 
if (${mbr} == 1) then
   set REFYEAR   = "0210"
   set REFDATE   = $REFYEAR-"01-01"
endif
if (${mbr} == 2) then
   set REFYEAR   = "0480"
   set REFDATE   = $REFYEAR-"01-01"
endif
if (${mbr} == 3) then
   set REFYEAR   = "0320"
   set REFDATE   = $REFYEAR-"01-01"
endif
if (${mbr} == 4) then
   set REFYEAR   = "0365"
   set REFDATE   = $REFYEAR-"01-01"
endif
if (${mbr} == 5) then
   set REFYEAR   = "0410"
   set REFDATE   = $REFYEAR-"01-01"
endif



if ($mbr < 10) then
	setenv CASE e3smv1.${COMPSETSHORT}.${RESOLN}.${EXPERIMENT}.$REFYEAR.00${mbr}
else
	setenv CASE e3smv1.${COMPSETSHORT}.${RESOLN}.${EXPERIMENT}.0${mbr}
endif

set PATH      = /global/project/projectdirs/ccsm1/people/$USER/
set RUNDIR    = $SCRATCH/$CASE/run
set BLDDIR    = $SCRATCH/$CASE/bld
setenv CASEROOT $PATH/cases/e3smv1-le/$CASE
set TOOLSROOT = /global/homes/n/nanr/CESM_tools/e3sm/
set REFCASE   = 20180129.DECKv1b_piControl.ne30_oEC.edison
set RESTDIR   = $SCRATCH/archive/
set STARTDATE = "1850-01-01"

#setenv E3SMROOT ${PATH}/e3sm_tags/${TAG}/
#setenv E3SMROOT /global/u2/x/xyhuang/e3sm-le-v1/
setenv E3SMROOT ${PATH}/e3sm_tags/${TAG}/


$E3SMROOT/cime/scripts/create_newcase --case $CASE --compset $COMPSET --res $RESOLN --pecount L --handle-preexisting-dirs u --mach $MACHINE --output-root $SCRATCH --script-root $CASEROOT -project $PROJECT

cd $CASEROOT

cp $TOOLSROOT/SourceMods/src.cam/*.F90 ./SourceMods/src.cam/
cp $TOOLSROOT/user_nl_files/le-v1-catalyst/user_nl_* $CASEROOT/

if (${mbr} == 1) then
   cp $TOOLSROOT/user_nl_files/le-v1-catalyst/user_nl_cam-mbr1 $CASEROOT/user_nl_cam
else
   cp $TOOLSROOT/user_nl_files/le-v1-catalyst/user_nl_cam-mbr2-3 $CASEROOT/user_nl_cam
endif

./xmlchange RUN_TYPE=hybrid
./xmlchange RUN_REFCASE=$REFCASE
./xmlchange RUN_REFDATE=$REFDATE
./xmlchange RUN_STARTDATE=$STARTDATE
./xmlchange GET_REFCASE=FALSE
./xmlchange JOB_WALLCLOCK_TIME=24:00:00
./xmlchange STOP_OPTION=nyears
./xmlchange STOP_N=3
./xmlchange DOUT_S=TRUE


echo "$RESTDIR/$REFCASE/rest/${REFDATE}-00000/* $RUNDIR/"
mkdir -p $RUNDIR
cp $RESTDIR/$REFCASE/rest/${REFDATE}-00000/* $RUNDIR/
./case.setup
./case.build

