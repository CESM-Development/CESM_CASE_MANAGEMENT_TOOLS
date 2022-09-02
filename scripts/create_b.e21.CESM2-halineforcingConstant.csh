#!/bin/csh -f
### set env variables

## Tag includes sfwf SourceMods!
setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.4-rc.08
setenv CESM_TOOLS /glade/work/nanr/cesm_tags/CASE_tools/aixue/cesm2-thermal-haline/

set COMPSET = B1850cmip6
set MACHINE = cheyenne
set RESOLN = f09_g17
set mbr = 1
set PROJECT = P93300313
set PROJECT = P06010014

setenv CASENAME b.e21.${COMPSET}.f09_g17.hosingConstant.00${mbr}
setenv REFCASE  b.e21.${COMPSET}.f09_g17.hosing.00${mbr}
setenv REFDATE  0151-01-01

setenv CASEROOT /glade/work/nanr/amoc-hosing/cases/$CASENAME

cd $CESMROOT/cime/scripts/
./create_newcase --case $CASEROOT --res $RESOLN  --compset $COMPSET  --project $PROJECT

cd $CASEROOT

./xmlchange RUN_REFCASE=$REFCASE
./xmlchange RUN_REFDATE=$REFDATE
./xmlchange GET_REFCASE=FALSE
./xmlchange STOP_N=3
./xmlchange STOP_OPTION=nyears
./xmlchange RESUBMIT=49
#/./xmlchange JOB_QUEUE=economy --subgroup case.run
cp $CESM_TOOLS/pelayout/env_mach_pes.xml .

#./xmlchange NTASKS_ICE=36
#./xmlchange NTASKS_LND=504
#.sxmlchange ROOTPE_ICE=504


cp $CESM_TOOLS/user_nl_files/halineConstant/user_nl_pop $CASEROOT/user_nl_pop
cp $CESM_TOOLS/SourceMods/src.pop/haline/* $CASEROOT/SourceMods/src.pop/

set RUNDIR=/glade/scratch/nanr/$CASENAME/run/

if (! -d /glade/scratch/nanr/$CASENAME/run/) then
   mkdir -p /glade/scratch/nanr/$CASENAME/run/
endif

cp /glade/work/nanr/amoc-hosing/fromFred/hosing_AMOChaline_50-70N_years1850-1999.211113.nc /glade/scratch/nanr/$CASENAME/run/
cp /glade/scratch/nanr/archive/b.e21.B1850cmip6.f09_g17.hosing.001/rest/0151-01-01-00000/rpointer.* $RUNDIR
ln -s /glade/scratch/nanr/archive/b.e21.B1850cmip6.f09_g17.hosing.001/rest/0151-01-01-00000/b.e21.B1850cmip6.f09_g17.hosing.001.* $RUNDIR

./case.setup

./preview_namelists

qcmd -- ./case.build >& bld.`date +%m%d-%H%M`

