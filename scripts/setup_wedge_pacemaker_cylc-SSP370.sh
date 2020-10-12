#!/bin/bash
#-------------------------------------------------------------
#- Script to set up CESM2 tropical pacific pacemaker with   --
#- wedge mask.  Initializing in 1880 from CESM2-LE restarts --
#-------------------------------------------------------------

COMPSET=BSSP370cmip6
GRID=f09_g17
CESMROOT="/glade/work/islas/cesm2.1.3/"
PROJECT=P93300313
INITDIR="/glade/scratch/asphilli/archive/" # directory containing restart files from first 10 macro members of CESM2-LE
INITNAME="b.e21.BHISTcmip6.f09_g17.pacemaker_pacific"
#SOURCEMODSDIR="/glade/u/home/islas/CVCWG/CESM2_PACEMAKER/CESM2_SourceMods/"
SOURCEMODSDIR="/glade/work/nanr/cesm_tags/CASE_tools/cesm2-pacemaker/"

STARTMEMBER=1
ENDMEMBER=5

CASEROOTBASE="/glade/work/nanr/CESM2-pacemaker/cases/" # !!change this 
BASENAME=b.e21.$COMPSET'.'$GRID'.pacemaker_pacific'
SCRATCHBASE="/glade/scratch/nanr/" # !!!change this

cd ~nanr/CESM-WF/
  ./create_cylc_cesm2-pacemaker-ensemble-SSP370 --case $CASEROOTBASE$BASENAME --compset $COMPSET --res $GRID --mach cheyenne --run-unsupported

for imem in `seq $STARTMEMBER $ENDMEMBER` ; do
  memstr=`printf %03d $imem`
  initcase=$INITNAME'.'$memstr

  memstr=`printf %03d $imem`
  caseroot=$CASEROOTBASE$BASENAME'.'$memstr
  REFROOT=$INITDIR$INITNAME'.'$memstr'-b/rest/2015-01-01-00000/'
  
echo "======="
  echo $caseroot
  echo $INITDIR
  echo $INITDIR$INITNAME'.'$memstr
echo "======="
 
  cd $caseroot
  ./xmlchange RUN_TYPE=hybrid
  ./xmlchange RUN_STARTDATE="2015-01-01"
  ./xmlchange STOP_OPTION="nyears"
  ./xmlchange STOP_N=2
  ./xmlchange RESUBMIT=1
  ./xmlchange RUN_REFDIR=$INITDIR$INITNAME'.'$memstr'-b'
  ./xmlchange RUN_REFCASE=$initcase
  ./xmlchange RUN_REFDATE="2015-01-01"
  ./xmlchange JOB_QUEUE=regular

  ./xmlchange NTASKS_ICE=36
  ./xmlchange NTASKS_LND=504
  ./xmlchange ROOTPE_ICE=504

# ./xmlchange NTASKS_CPL=1152
# ./xmlchange NTASKS_ATM=1152
# ./xmlchange NTASKS_LND=864
# ./xmlchange NTASKS_ICE=288
# ./xmlchange NTASKS_OCN=256
# ./xmlchange NTASKS_ROF=864
# ./xmlchange NTASKS_GLC=1152
# ./xmlchange NTASKS_WAV=32
# ./xmlchange NTHRDS_CPL=3
# ./xmlchange NTHRDS_ATM=3
# ./xmlchange NTHRDS_LND=3
# ./xmlchange NTHRDS_ICE=3
# ./xmlchange NTHRDS_OCN=3
# ./xmlchange NTHRDS_ROF=3
# ./xmlchange NTHRDS_GLC=3
# ./xmlchange NTHRDS_WAV=3
# ./xmlchange ROOTPE_ICE=864
# ./xmlchange ROOTPE_OCN=1152
# ./xmlchange ROOTPE_WAV=1408

  ./case.setup

##copy over namelist_definitions 
cp $SOURCEMODSDIR/user_nl_files/* $caseroot/
#
##copy over SourceMods and namelist_definitions for pacemaker set-up
cp $SOURCEMODSDIR/SourceMods/src.pop/* $caseroot/SourceMods/src.pop/
#
##copy restarts into run directory
echo "==========2"
echo cp $REFROOT/rpointer* $SCRATCHBASE/$BASENAME'.'$memstr/run/
echo ln -s $REFROOT/b.e21.B* $SCRATCHBASE/$BASENAME'.'$memstr/run/
echo "==========2"
cp $REFROOT/rpointer.* $SCRATCHBASE/$BASENAME'.'$memstr/run/
ln -s $REFROOT/b.e21.B* $SCRATCHBASE/$BASENAME'.'$memstr/run/

#qcmd -- ./case.build

done



