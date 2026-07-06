#!/bin/csh -f
### set env variables

## Tag includes sfwf SourceMods!
setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.5/
setenv CESM_TOOLS /glade/work/nanr/cesm_tags/CASE_tools/cesm2-subCESMulator/

#set COMPSET = BHISTcmip6
#set USECOMPSET = BHISTcmip6
set COMPSET = BSSP370cmip6
set USECOMPSET = BSSP370cmip6
set MACHINE = derecho
set RESOLN = f09_g17
set mbr = 1
set PROJECT = P06010014

setenv CASENAME b.e21.${USECOMPSET}.f09_g17.subCESMulator.00${mbr}
setenv REFCASE  b.e21.BHISTcmip6.f09_g17.subCESMulator.00${mbr}
setenv REFDATE  2015-01-01

#setenv CASEROOT /glade/derecho/scratch/nanr/$CASENAME
setenv CASEROOT /glade/work/nanr/subCESMulator/cases/$CASENAME

cd $CESMROOT/cime/scripts/
./create_newcase --case $CASEROOT --res $RESOLN  --compset $USECOMPSET  --project $PROJECT

cd $CASEROOT

./xmlchange RUN_REFCASE=$REFCASE
./xmlchange RUN_REFDATE=$REFDATE
./xmlchange RUN_STARTDATE=$REFDATE
./xmlchange STOP_N=3
./xmlchange STOP_OPTION=nyears
./xmlchange RESUBMIT=5
#./xmlchange JOB_QUEUE=economy --subgroup case.run
./xmlchange GET_REFCASE=FALSE

#./xmlchange NTASKS_ICE=36
#./xmlchange NTASKS_LND=504
#./xmlchange ROOTPE_ICE=504

./case.setup

#cp $CESM_TOOLS/user_nl_files/haline/user_nl_clm $CASEROOT/user_nl_clm
cp $CESM_TOOLS/user_nl_files/round1/user_nl_cam $CASEROOT/user_nl_cam
#cp $CESM_TOOLS/user_nl_files/round1/user_nl_pop $CASEROOT/user_nl_pop
cp $CESM_TOOLS/user_nl_files/round1/user_nl_clm $CASEROOT/user_nl_clm
cp $CESM_TOOLS/SourceMods/src.cam/* $CASEROOT/SourceMods/src.cam/


#copy restarts
#echo /glade/campaign/cgd/cesm/CESM2-LE/restarts/b.e21.BHISTsmbb.f09_g17.LE2-1231.011/rest/1950-01-01-00000/
#cp /glade/campaign/cgd/cesm/CESM2-LE/restarts/b.e21.BHISTsmbb.f09_g17.LE2-1231.011/rest/1950-01-01-00000/* $SCRATCH/$CASENAME/run/
echo /glade/derecho/scratch/nanr/archive/b.e21.BHISTcmip6.f09_g17.subCESMulator.001/rest/1950-01-01-00000/
cp /glade/derecho/scratch/nanr/archive/b.e21.BHISTcmip6.f09_g17.subCESMulator.001/rest/2015-01-01-00000/*  $SCRATCH/$CASENAME/run/

./preview_namelists

qcmd -- ./case.build >& bld.`date +%m%d-%H%M`

