#!/bin/csh -f
### set env variables


## We need to create

set COMPSET = FAMIPC5
set RESOLN  = ne120_ne120_mt12
set MACHINE = frontera
set TAG     = cesm-ihesp-hires1.0.41
set EXPER   = myTestRun
set GITREPO = https://github.com/ihesp/cesm.git

set mbr = 1
setenv CASE f.e13.${COMPSET}.${RESOLN}.${EXPER}.00${mbr}

set RUNDIR  = /glade/scratch/$USER/$CASE/run
set CROOT   = /glade/work/$USER/myPath
set SCRATCH = /glade/scratch/$USER

setenv CESMROOT ${MYPATH}/${TAG}/

setenv CASEROOT $CROOT/$CASE
set RUNDIR   = $SCRATCH/$CASE/run

$CESMROOT/cime/scripts/create_newcase --case $CASEROOT --res $RESOLN  --mach $MACHINE --compset $COMPSET --run-unsupported

cd $CASEROOT

### modify case parameters
./xmlchange RUN_TYPE=hybrid
./xmlchange STOP_OPTION=nyears
./xmlchange RUN_STARTDATE=1982-01-01
./xmlchange RUN_REFCASE=f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-1950-2050.001
./xmlchange RUN_REFDATE=1982-01-01
./xmlchange STOP_N=5
./xmlchange REST_N=1
./xmlchange REST_OPTION=nmonths
./xmlchange GET_REFCASE=FALSE

### set PE layout
./xmlchange NTASKS_ATM=14400
./xmlchange NTASKS_LND=14400
./xmlchange NTASKS_ICE=14400
./xmlchange NTASKS_OCN=14400
./xmlchange NTASKS_CPL=14400
./xmlchange NTASKS_ROF=14400

### set domain files and SST parameters
./xmlchange ICE_DOMAIN_FILE=domain.ocn.ne120np4_tx0.1v2.191122.nc
./xmlchange OCN_DOMAIN_FILE=domain.ocn.ne120np4_tx0.1v2.191122.nc
./xmlchange SSTICE_YEAR_ALIGN=1950
./xmlchange SSTICE_YEAR_START=1950
./xmlchange SSTICE_YEAR_END=2050

./xmlchange SSTICE_GRID_FILENAME=/glade/p/cesm/cseg/inputdata/atm/cam/ocnfrac/domain.ocn.0.25x0.25_mask.181109.nc

# You will need to copy restart files to your $RUNDIR
#cp $MYRESTARTFILES/rpoint* $RUNDIR
#ln -s $MYRESTARTFILES/f.e* $RUNDIR

./case.setup

qcmd -- ./case.build
