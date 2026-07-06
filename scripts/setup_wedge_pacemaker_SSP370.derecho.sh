#!/bin/bash
#-------------------------------------------------------------
#- Script to set up CESM2 tropical pacific pacemaker with   --
#- wedge mask.  Initializing in 1880 from CESM2-LE restarts --
#-------------------------------------------------------------

COMPSET=BSSP370cmip6
GRID=f09_g17
CESMROOT="/glade/work/nanr/cesm_tags/cesm2.1.5/"
PROJECT=P93300313
INITDIR="/glade/derecho/scratch/nanr/archive/" # directory containing restart files from first 10 macro members of CESM2-LE
INITNAME="b.e21.BSSP370cmip6.f09_g17.pacemaker_pacific"
#SOURCEMODSDIR="/glade/u/home/islas/CVCWG/CESM2_PACEMAKER/CESM2_SourceMods/"
SOURCEMODSDIR="/glade/work/nanr/cesm_tags/CASE_tools/cesm2-pacemaker/"

STARTMEMBER=3
ENDMEMBER=10

CASEROOTBASE="/glade/work/nanr/CESM2-pacemaker/cases/" # !!change this 
BASENAME=b.e21.$COMPSET'.'$GRID'.pacemaker_pacific_xtnd'
SCRATCHBASE="/glade/derecho/scratch/nanr/" # !!!change this


for imem in `seq $STARTMEMBER $ENDMEMBER` ; do
  memstr=`printf %03d $imem`
  initcase=$INITNAME'.'$memstr

  memstr=`printf %03d $imem`
  caseroot=$CASEROOTBASE$BASENAME'.'$memstr
  REFROOT=$INITDIR$INITNAME'.'$memstr'/rest/2020-01-01-00000/'
  cd $CESMROOT/cime/scripts
  ./create_newcase --case $caseroot --compset $COMPSET --res $GRID  --run-unsupported
  
echo "======="
  echo $caseroot
  echo $INITDIR
  echo $INITDIR$INITNAME'.'$memstr
  echo $REFROOT
echo "======="
 
  cd $caseroot
  ./xmlchange RUN_TYPE=hybrid
  ./xmlchange RUN_STARTDATE="2020-01-01"
  ./xmlchange STOP_OPTION="nmonths"
  ./xmlchange STOP_N=24
  ./xmlchange RESUBMIT=1
  ./xmlchange RUN_REFDIR=$INITDIR$INITNAME'.'$memstr
  ./xmlchange RUN_REFCASE=$initcase
  ./xmlchange RUN_REFDATE="2020-01-01"
  ./xmlchange GET_REFCASE=FALSE

  ./case.setup

  if ($memstr == '001') then
      qcmd -- ./case.build
  else
      ./xmlchange EXEROOT="/glade/derecho/scratch/nanr/b.e21.BSSP370cmip6.f09_g17.pacemaker_pacific_xtnd.001/bld/"
      ./xmlchange BUILD_COMPLETE=TRUE
  fi

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



