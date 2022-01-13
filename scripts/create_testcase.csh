#!/bin/csh -fx
### set env variables
setenv TOOLS_ROOT /glade/work/$USER/cesm_tags/CASE_tools/cesm2-tutorial/
setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.4-rc.07

set COMPSET = BHISTcmip6
set EXPERIMENT = mytest
set MACHINE = cheyenne
set RESOLN = f09_g17
set RESUBMIT = 0
set STOP_N=3
set STOP_OPTION=nyears
set PROJECT=P93300313

setenv SCENARIO TEST
setenv BASENAME b.e21.${COMPSET}.${RESOLN}.${EXPERIMENT}
setenv RUNROOT  /glade/scratch/$USER/

# case name counter
set mbr = 1
setenv CASENAME b.e21.${COMPSET}.${RESOLN}.${EXPERIMENT}.00${mbr}
setenv CASEROOT /glade/work/$USER/testCases/$CASENAME

cd $CESMROOT/cime/scripts/
 ./create_newcase --case $CASEROOT --res $RESOLN  --compset $COMPSET --project $PROJECT
 
cd $CASEROOT

./xmlchange PROJECT=$PROJECT
./case.setup

exit

