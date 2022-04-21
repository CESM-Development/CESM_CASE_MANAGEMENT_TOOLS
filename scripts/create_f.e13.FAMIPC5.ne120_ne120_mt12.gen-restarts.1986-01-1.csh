#!/bin/csh -f
### set env variables


## We need to create

set COMPSET = FAMIPC5
set RESOLN  = ne120_ne120_mt12
set MACHINE = cheyenne
set MACHINE = frontera
set TAG     = cesm-ihesp-hires1.0.35
set GITREPO = https://github.com/ihesp/cesm.git
set STARTDATE=1986-04-01

set mbr = 1
setenv CASE f.e13.${COMPSET}.${RESOLN}.rerun-gen-restarts.00${mbr}
#setenv CASE f.e13.${COMPSET}.${RESOLN}.chey-gen-restarts.$STARTDATE.00${mbr}

if ($MACHINE == frontera) then
	set PATH    = $STOCKYARD
        #set PATH    = /work/06091/nanr/
        set RUNDIR  = /scratch1/06091/nanr/$CASE/run
        set IHESPTOOLS = /home1/06091/nanr/CESM_tools/ihesp-tools/
	#setenv CROOT $WORK/cases/cesm13/$CASE
        setenv CROOT /work/06091/nanr/frontera/cases/cesm13/
else
        set PATH    = /glade/work/nanr/
        set RUNDIR  = /glade/scratch/nanr/$CASE/run
        set TOOLSROOT = /glade/work/nanr/cesm_tags/CASE_tools/ihesp-tools/
        set IHESPTOOLS = /glade/work/nanr/cesm_tags/CASE_tools/ihesp-tools/
	setenv CROOT /glade/work/nanr/ihesp-HiRes/cases/ne120_t12/
	set SCRATCH   = /glade/scratch/$USER
endif

setenv CESMROOT ${PATH}/cesm_tags/${TAG}/

setenv CASEROOT $CROOT/$CASE
set RUNDIR   = $SCRATCH/$CASE/run

# $CESMROOT/scripts/create_newcase -case $CASEROOT -res $RESOLN  -mach $MACHINE -compset $COMPSET -compiler $COMPILER
  $CESMROOT/cime/scripts/create_newcase --case $CASEROOT --res $RESOLN  --mach $MACHINE --compset $COMPSET --run-unsupported

cd $CASEROOT


### modify case parameters
./xmlchange RUN_TYPE=branch
./xmlchange STOP_OPTION=nyears
./xmlchange RUN_STARTDATE=$STARTDATE
./xmlchange RUN_REFCASE=f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-hires1.0.32_gen-restarts.0097
./xmlchange RUN_REFDATE=$STARTDATE
./xmlchange STOP_N=7
./xmlchange STOP_OPTION=nmonths
./xmlchange GET_REFCASE=FALSE

if ($MACHINE == cheyenne) then
	./xmlchange PROJECT=CESM0019
	./xmlchange JOB_QUEUE=economy --subgroup case.run
endif
#./xmlchange DIN_LOC_ROOT='/glade/p/cesm/cseg/inputdata'
#./xmlchange DIN_LOC_ROOT_CLMFORC='/glade/p/cesm/cseg/inputdata/atm/datm7'

 ./xmlchange REST_N=1
 ./xmlchange REST_OPTION=nmonths
 ./xmlchange DOUT_S_SAVE_INTERIM_RESTART_FILES=TRUE

if ($MACHINE == frontera) then
 ./xmlchange NTASKS_ATM=21616
 ./xmlchange NTASKS_LND=21616
 ./xmlchange NTASKS_ICE=21616
 ./xmlchange NTASKS_OCN=21616
 ./xmlchange NTASKS_CPL=21616
 ./xmlchange NTASKS_ROF=21616
else
 ./xmlchange PROJECT=CESM0019
 ./xmlchange NTASKS_ATM=14400
 ./xmlchange NTASKS_LND=14400
 ./xmlchange NTASKS_ICE=14400
 ./xmlchange NTASKS_OCN=14400
 ./xmlchange NTASKS_CPL=14400
 ./xmlchange NTASKS_ROF=14400
endif

# ./xmlchange RUNDIR='/glade/scratch/nanr/$CASE/run'
# ./xmlchange EXEROOT='/glade/scratch/nanr/$CASE/bld'

 ./xmlchange ICE_DOMAIN_FILE=domain.ocn.ne120np4_tx0.1v2.191122.nc
 ./xmlchange OCN_DOMAIN_FILE=domain.ocn.ne120np4_tx0.1v2.191122.nc
 ./xmlchange SSTICE_YEAR_ALIGN=1950
 ./xmlchange SSTICE_YEAR_START=1950
 ./xmlchange SSTICE_YEAR_END=2050

 ./xmlchange RUN_REFDIR=cesm2_init
 ./xmlchange GET_REFCASE=FALSE

 if ($MACHINE == frontera) then
 	./xmlchange SSTICE_GRID_FILENAME=/work/06091/nanr/frontera/SST-highres/domain.ocn.0.25x0.25_mask.181109.nc
	cp /scratch1/06091/nanr/archive/f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-hires1.0.32_gen-restarts.0097/rest/1986-04-01-00000/rpointer* $RUNDIR
	ln -s /scratch1/06091/nanr/archive/f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-hires1.0.32_gen-restarts.0097/rest/1986-04-01-00000/f.e13.F* $RUNDIR
	cp $IHESPTOOLS/user_nl_files/gen-InitRestarts-AMIP-1950-2019/frontera/* $CASEROOT/
 else
        ./xmlchange SSTICE_GRID_FILENAME=/glade/p/cesm/cseg/inputdata/atm/cam/ocnfrac/domain.ocn.0.25x0.25_mask.181109.nc
	#cp /glade/scratch/fredc/archive/f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-1950-2050.001/rest/1982-01-01-00000/rpoint* $RUNDIR
	#ln -s /glade/scratch/fredc/archive/f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-1950-2050.001/rest/1982-01-01-00000/f.e13.F* $RUNDIR
	cp /glade/scratch/fredc/archive/f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-1950-2050.001/rest/$STARTDATE-00000/rpoint* $RUNDIR
	ln -s /glade/scratch/fredc/archive/f.e13.FAMIPC5.ne120_ne120_mt12.cesm-ihesp-1950-2050.001/rest/$STARTDATE-00000/f.e13.F* $RUNDIR
	cp $IHESPTOOLS/user_nl_files/gen-InitRestarts-AMIP-1950-2019/cheyenne/* $CASEROOT/
 endif

./case.setup

 if ($MACHINE == frontera) then
        ./case.build
 else
	qcmd -- ./case.build
 endif