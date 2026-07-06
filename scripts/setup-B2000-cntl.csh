#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-bruteForce/
setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.4-rc.08

set COMPSET = B2000cmip6
set EXPERIMENT = ocnSpinup
set MACHINE = cheyenne
set RESOLN = f09_g17
set RESUBMIT = 0
set STOP_N=1
set STOP_OPTION=nmonths
set PROJECT=P93300313

set smbr =  1
set embr =  1

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )

if    ($mbr < 10) then
  setenv CASENAME  b.e21.${COMPSET}.${RESOLN}.${EXPERIMENT}.00${mbr}
else
  setenv CASENAME  b.e21.${COMPSET}.${RESOLN}.${EXPERIMENT}.0${mbr}
endif

setenv CASEROOT  /glade/work/nanr/decadalPrediction/cases/$CASENAME
set RUNDIR = /glade/scratch/$USER/$CASENAME/run/

$CESMROOT/cime/scripts/create_newcase --compset ${COMPSET} --res f09_g17 --case ${CASEROOT} --project=${PROJECT} --queue=economy --run-unsupported

  cd $CASEROOT

  ./xmlchange NTASKS_ICE=36
  ./xmlchange NTASKS_LND=504
  ./xmlchange ROOTPE_ICE=504

  ./xmlchange PROJECT=${PROJECT}
  ./xmlchange JOB_QUEUE=economy --subgroup case.run

  mv  env_batch.xml tmp.batch
  cat tmp.batch | sed 's/-N {{ job_id }}/-N yr2000.cntl/' > env_batch.xml
  ./case.setup

  ./xmlchange STOP_N=$STOP_N
  ./xmlchange STOP_OPTION=$STOP_OPTION
  ./xmlchange RESUBMIT=$RESUBMIT


   ./case.setup --reset
   qcmd -- ./case.build 

end  # member loop

exit

