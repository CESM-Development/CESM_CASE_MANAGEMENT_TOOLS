#!/bin/bash
# --------------------------------------------------------------
# - Script to set up the CESM2 SSP2-4.5 ensemble with smoothed -
# - biomass burning.  Initializzing from 2015-01-01 of the 2nd -
# - round of LENS2 members                                     -
# --------------------------------------------------------------

CURDIR=$(pwd)
TOOLSDIR=/glade/work/nanr/cesm_tags/CASE_tools/cesm2-ssp245/
COMPSET=BSSP245smbb
GRID=f09_g17
#CESMROOT="/glade/work/islas/release-cesm2.1.2/" # !!! Adam will want to change this or $CASEROOTBASE
CESMROOT="/glade/work/nanr/cesm_tags/cesm2.1.4-rc.07/" # !!! Adam will want to change this or $CASEROOTBASE
PROJECT=P93300313
INITDIR="/glade/scratch/islas/inputdata/CESM2_SSP245/" # directory containing restart files
INITNAME="b.e21.BHISTsmbb.f09_g17.LE2-"

STARTMEMBER=1
ENDMEMBER=5

CASEROOTBASE=$CESMROOT/runs/CESM2_SSP245/
CASEROOTBASE=/glade/scratch/nanr/CESM2_SSP245/
BASENAME=b.e21.$COMPSET'.'$GRID'.test'
SCRATCHBASE="/glade/scratch/nanr/" # !!! change this

#cd ~nanr/CESM-WF/
#./create_cylc_covid_ensemble-ssp245 --case $CASEROOTBASE$BASENAME --compset $COMPSET --res $GRID --mach cheyenne --user-mods-dir /glade/u/home/cmip6/cesm_tags/cesm2.1.2-rc.01/components/clm/cime_config/usermods_dirs/cmip6_deck

for imem in `seq $STARTMEMBER $ENDMEMBER` ; do
    memstr=`printf %03d $imem`
    memstrp10=`printf %03d $(($imem+10))`
    # get initialization member name
    initmem="1231."$memstrp10
    #initcase=$INITNAME$initmem'.'$memstrp10
    initcase=$INITNAME$initmem

    caseroot=$CASEROOTBASE$BASENAME'.'$memstr

#   cd $CESMROOT/cime/scripts
#   ./create_newcase --case $caseroot --compset $COMPSET --res $GRID --mach cheyenne 


    cd $caseroot
    ./xmlchange RUN_TYPE=hybrid
    ./xmlchange RUN_STARTDATE="2015-01-01"
    ./xmlchange RUN_REFDIR=$INITDIR$initmem"/2015-01-01-00000/"
    ./xmlchange RUN_REFCASE=$initcase
    ./xmlchange RUN_REFDATE="2015-01-01"
    ./xmlchange JOB_QUEUE=economy
    ./xmlchange STOP_OPTION=nyears
    ./xmlchange STOP_N=3
    ./xmlchange RESUBMIT=27

    ./xmlchange NTASKS_CPL=576
    ./xmlchange NTASKS_ATM=576
    ./xmlchange NTASKS_LND=504
    ./xmlchange NTASKS_ICE=36
    ./xmlchange NTASKS_OCN=144
    ./xmlchange NTASKS_ROF=468
    ./xmlchange NTASKS_GLC=576
    ./xmlchange NTASKS_WAV=36
    ./xmlchange NTASKS_ESP=1
    ./xmlchange ROOTPE_ICE=504
    ./xmlchange ROOTPE_OCN=576
    ./xmlchange ROOTPE_WAV=540

    ./case.setup
    cp $TOOLSDIR/user_nl_files/* $caseroot

    #qcmd -- ./case.build
done
