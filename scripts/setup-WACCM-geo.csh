#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-waccm/
setenv CESMROOT /glade/u/home/cmip6/cesm_tags/release-cesm2.1.3
setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.4-rc.08

set COMPSET = BWSSP245cmip6
set SCENARIO = SSP245
set VERSION = TSMLT
set NAMESIM = DEFAULT
set ENS = 001
set MACHINE = cheyenne
set RESOLN = f09_g17
set RESUBMIT = 0
set STOP_N=1
set STOP_OPTION=nmonths
set PROJECT=P93300607

set smbr =  1
set embr =  5

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )

if    ($mbr < 10) then
  setenv CASENAME  b.e21.BW.${RESOLN}.${SCENARIO}-${VERSION}-GAUSS-${NAMESIM}.00${mbr}
  setenv REFCASE   b.e21.BWSSP245cmip6.f09_g17.CMIP6-SSP2-4.5-WACCM.00${mbr}
else
  setenv CASENAME  b.e21.BW.${RESOLN}.${SCENARIO}-${VERSION}-GAUSS-${NAMESIM}.0${mbr}
  setenv REFCASE   b.e21.BWSSP245cmip6.f09_g17.CMIP6-SSP2-4.5-WACCM.0${mbr}
endif

setenv CASEROOT  /glade/work/geostrat/cases/$CASENAME
#setenv CASEROOT  /glade/scratch/$USER/$CASENAME
setenv REFDATE  2035-01-01
setenv REFROOT  /glade/scratch/nanr/archive/$REFCASE/${REFDATE}-00000/
setenv STARTDATE  $REFDATE
set RUNDIR = /glade/scratch/$USER/$CASENAME/run/

$CESMROOT/cime/scripts/create_newcase --compset ${COMPSET} --res f09_g17 --case ${CASEROOT} --project=${PROJECT} --queue=economy

  cd $CASEROOT

  ./xmlchange NTASKS_CPL=576
  ./xmlchange NTASKS_ATM=576
  ./xmlchange NTASKS_LND=144
  ./xmlchange NTASKS_ICE=432
  ./xmlchange ROOTPE_ICE=144
  ./xmlchange NTASKS_OCN=36
  ./xmlchange ROOTPE_OCN=576
  ./xmlchange NTASKS_ROF=40
  ./xmlchange NTASKS_GLC=36
  ./xmlchange NTASKS_WAV=36
  ./xmlchange ROOTPE_WAV=252
  ./xmlchange NTASKS_ESP=1
  ./xmlchange NTHRDS=3

  ./xmlchange RUN_REFCASE=$REFCASE
  ./xmlchange RUN_REFDATE=$REFDATE
  ./xmlchange RUN_STARTDATE=$STARTDATE
  ./xmlchange GET_REFCASE=FALSE
  ./xmlchange PROJECT=${PROJECT}
  ./xmlchange JOB_QUEUE=economy --subgroup case.run


  cp $CESM2_TOOLS_ROOT/SourceMods/src.cam/* $CASEROOT/SourceMods/src.cam/
  cp $CESM2_TOOLS_ROOT/user_nl_files/user_nl_* $CASEROOT/

  mv  env_batch.xml tmp.batch
  cat tmp.batch | sed 's/-N {{ job_id }}/-N TSMLT.{{ job_id }}/' > env_batch.xml
  ./case.setup

  ./xmlchange STOP_N=$STOP_N
  ./xmlchange STOP_OPTION=$STOP_OPTION
  ./xmlchange RESUBMIT=$RESUBMIT


echo " Copy Restarts -------------"
if (! -d $RUNDIR) then
        echo 'mkdir ' $RUNDIR
        mkdir -p $RUNDIR
endif

   cp    ${REFROOT}/rpointer* $RUNDIR/
   ln -s ${REFROOT}/b.e21*    $RUNDIR/

echo " End restarts copy -----------"

   #./case.setup --reset; ./case.setup
   ./case.setup --reset; ./case.setup; qcmd -- ./case.build >& bld.`date +%m%d-%H%M`

end  # member loop

exit

