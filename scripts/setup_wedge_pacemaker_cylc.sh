#!/bin/bash
#-------------------------------------------------------------
#- Script to set up CESM2 tropical pacific pacemaker with   --
#- wedge mask.  Initializing in 1880 from CESM2-LE restarts --
#-------------------------------------------------------------

COMPSET=BHISTcmip6
GRID=f09_g17
CESMROOT="/glade/work/islas/cesm2.1.3/"
PROJECT=P93300313
INITDIR="/glade/scratch/islas/CVCWG/CESM2_PACEMAKER_INIT/" # directory containing restart files from first 10 macro members of CESM2-LE
INITNAME="b.e21.BHISTcmip6.f09_g17.LE2-"
#SOURCEMODSDIR="/glade/u/home/islas/CVCWG/CESM2_PACEMAKER/CESM2_SourceMods/"
SOURCEMODSDIR="/glade/work/nanr/cesm_tags/CASE_tools/cesm2-pacemaker/"

STARTMEMBER=1
ENDMEMBER=2

CASEROOTBASE="/glade/work/nanr/CESM2-pacemaker/cases/" # !!change this 
BASENAME=b.e21.$COMPSET'.'$GRID'.pacemaker_pacific_TESTAGAIN1'
SCRATCHBASE="/glade/scratch/nanr/" # !!!change this

cd ~nanr/CESM-WF/
  ./create_cylc_cesm2-pacemaker-ensemble --case $CASEROOTBASE$BASENAME --compset $COMPSET --res $GRID --mach cheyenne --run-unsupported

for imem in `seq $STARTMEMBER $ENDMEMBER` ; do
  memstr=`printf %03d $imem`
  #get initialization member name (first 10 macro's of CESM2-LE)
  initmem=$((1000 + 20*$(($imem-1)) + 1))
  initcase=$INITNAME$initmem'.'$memstr
  initcaseshort=$initmem'.'$memstr

  memstr=`printf %03d $imem`
  caseroot=$CASEROOTBASE$BASENAME'.'$memstr
  REFROOT=$INITDIR$initmem'.'$memstr
  
echo "======="
  echo $caseroot
  echo $INITDIR
  echo $INITDIR$initmem'.'$memstr
echo "======="
 
  cd $caseroot
  ./xmlchange RUN_TYPE=hybrid
  ./xmlchange RUN_STARTDATE="1880-01-01"
  ./xmlchange STOP_OPTION="nyears"
  ./xmlchange STOP_N=10
  ./xmlchange RESUBMIT=13
  ./xmlchange RUN_REFDIR=$INITDIR$initmem'.'$memstr
  ./xmlchange RUN_REFCASE=$initcase
  ./xmlchange RUN_REFDATE="1880-01-01"
  ./xmlchange JOB_QUEUE=economy

  ./xmlchange NTASKS_CPL=1152
  ./xmlchange NTASKS_ATM=1152
  ./xmlchange NTASKS_LND=864
  ./xmlchange NTASKS_ICE=288
  ./xmlchange NTASKS_OCN=256
  ./xmlchange NTASKS_ROF=864
  ./xmlchange NTASKS_GLC=1152
  ./xmlchange NTASKS_WAV=32
  ./xmlchange NTHRDS_CPL=3
  ./xmlchange NTHRDS_ATM=3
  ./xmlchange NTHRDS_LND=3
  ./xmlchange NTHRDS_ICE=3
  ./xmlchange NTHRDS_OCN=3
  ./xmlchange NTHRDS_ROF=3
  ./xmlchange NTHRDS_GLC=3
  ./xmlchange NTHRDS_WAV=3
  ./xmlchange ROOTPE_ICE=864
  ./xmlchange ROOTPE_OCN=1152
  ./xmlchange ROOTPE_WAV=1408

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



