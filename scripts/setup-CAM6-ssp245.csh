#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-geo-ARISE/
setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.4-rc.08

set COMPSET = BSSP245cmip6
set MACHINE = cheyenne
set RESOLN = f09_g17
set STOP_N=5
set RESUBMIT=3
set STOP_OPTION=nyears

set mbr=1

if    ($mbr < 10) then
  setenv CASENAME  b.e21.${COMPSET}.${RESOLN}.CMIP6-MCB-cntl.00${mbr}
else
  setenv CASENAME  b.e21.${COMPSET}.${RESOLN}.CMIP6-ARISE-cntl.0${mbr}
endif

if ($USER == nanr) then
  setenv CASEROOT  /glade/work/$USER/waccm-geo-ARISE/$CASENAME
  set PROJECT=CESM0015
else
  setenv CASEROOT  /glade/work/$USER/$CASENAME
  set PROJECT=NCGD0050
endif

set RUNDIR = /glade/scratch/$USER/$CASENAME/run/

set REFCASE=b.e21.BHIST.f09_g17.CMIP6-historical.010

setenv REFDATE  2015-01-01
setenv REFROOT  /glade/scratch/nanr/archive/$REFCASE/rest/${REFDATE}-00000/
setenv STARTDATE  $REFDATE

$CESMROOT/cime/scripts/create_newcase --compset ${COMPSET} --res f09_g17 --case ${CASEROOT} --project=${PROJECT} --queue=economy

  cd $CASEROOT

set runCheap = True
set runCheap = False

if($runCheap == True) then
  ./xmlchange NTASKS_CPL=576
  ./xmlchange NTASKS_ATM=576
  ./xmlchange NTASKS_LND=504
  ./xmlchange NTASKS_ICE=36
  ./xmlchange ROOTPE_ICE=504
  ./xmlchange NTASKS_OCN=144
  ./xmlchange ROOTPE_OCN=576
  ./xmlchange NTASKS_ROF=468
  ./xmlchange NTASKS_GLC=576
  ./xmlchange NTASKS_WAV=36
  ./xmlchange ROOTPE_WAV=540
  ./xmlchange NTASKS_ESP=1
  ./xmlchange JOB_QUEUE=economy --subgroup case.run
else
  ./xmlchange NTASKS_CPL=1152
  ./xmlchange NTASKS_ATM=1152
  ./xmlchange NTASKS_LND=792
  ./xmlchange NTASKS_ICE=360
  ./xmlchange ROOTPE_ICE=792
  ./xmlchange NTASKS_OCN=512
  ./xmlchange ROOTPE_OCN=1152
  ./xmlchange NTASKS_ROF=792
  ./xmlchange NTASKS_GLC=1152
  ./xmlchange NTASKS_WAV=28
  ./xmlchange ROOTPE_WAV=1664
  ./xmlchange NTHRDS=3
  ./xmlchange NTASKS_ESP=1
  ./xmlchange NTHRDS_ESP=1
endif

  ./xmlchange RUN_REFCASE=$REFCASE
  ./xmlchange RUN_REFDATE=$REFDATE
  ./xmlchange RUN_STARTDATE=$STARTDATE
  ./xmlchange GET_REFCASE=FALSE
  ./xmlchange STOP_N=$STOP_N
  ./xmlchange STOP_OPTION=$STOP_OPTION
  ./xmlchange RESUBMIT=$RESUBMIT
  ./xmlchange PROJECT=${PROJECT}


  cp $CESM2_TOOLS_ROOT/SourceMods/src.cam/* $CASEROOT/SourceMods/src.cam/
  cp $CESM2_TOOLS_ROOT/user_nl_files/ssp245-cam6/user_nl_* $CASEROOT/

  ./case.setup



echo " Copy Restarts -------------"
if (! -d $RUNDIR) then
        echo 'mkdir ' $RUNDIR
        mkdir -p $RUNDIR
endif

   cp    ${REFROOT}/rpointer* $RUNDIR/
   ln -s ${REFROOT}/b.e21*    $RUNDIR/

   echo " End restarts copy -----------"

  qcmd -- ./case.build


exit

