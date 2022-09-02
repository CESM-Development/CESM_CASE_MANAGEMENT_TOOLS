#!/bin/csh -f
### set env variables

## Tag includes sfwf SourceMods!
setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.4-rc.08
setenv CESM_TOOLS /glade/work/nanr/cesm_tags/CASE_tools/aixue/cesm2-thermal-haline/

set COMPSET = B1850cmip6
set USECOMPSET = B1PCTcmip6
set MACHINE = cheyenne
set RESOLN = f09_g17
set mbr = 1
set PROJECT = P93300313

setenv CASENAME b.e21.${COMPSET}.f09_g17.thermalHaline.00${mbr}
setenv REFCASE  b.e21.B1850.f09_g17.CMIP6-piControl.001
setenv REFDATE  0501-01-01

setenv CASEROOT /glade/work/nanr/amoc-hosing/cases/$CASENAME

cd $CESMROOT/cime/scripts/
./create_newcase --case $CASEROOT --res $RESOLN  --compset $USECOMPSET  --project $PROJECT

cd $CASEROOT

./xmlchange RUN_REFCASE=$REFCASE
./xmlchange RUN_REFDATE=$REFDATE
./xmlchange STOP_N=3
./xmlchange STOP_OPTION=nyears
./xmlchange RESUBMIT=49
./xmlchange JOB_QUEUE=economy --subgroup case.run

./xmlchange NTASKS_ICE=36
./xmlchange NTASKS_LND=504
./xmlchange ROOTPE_ICE=504

./case.setup

cp $CESM_TOOLS/user_nl_files/haline/user_nl_clm $CASEROOT/user_nl_clm
cp $CESM_TOOLS/user_nl_files/haline/user_nl_pop $CASEROOT/user_nl_pop
cp $CESM_TOOLS/SourceMods/src.pop/haline/* $CASEROOT/SourceMods/src.pop/
cp /glade/work/nanr/amoc-hosing/fromFred/hosing_AMOChaline_50-70N_years1850-1999.211113.nc /glade/scratch/nanr/$CASENAME/run/

./preview_namelists

qcmd -- ./case.build >& bld.`date +%m%d-%H%M`

