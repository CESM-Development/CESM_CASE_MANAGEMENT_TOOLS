#!/bin/csh -f

set MACHINE = cori-knl
set MACHINE = cheyenne

set EXPERIMENT = trbelt
# "mg17 = masked ocn.  Ignored for aquaplanet
set RESOLN  = ne0np4.trbelt.ne30x8_mg17
set TAG     = cesm2.1.4-rc.08
set COMPSET = QPC6

#set RESUBMIT = 1
#set STOP_OPTION=nmonths
#set STOP_N=31
set RESUBMIT = 0
set STOP_OPTION=nmonths
set STOP_N=1
set REST_OPTION=nmonths
set REST_N=1

set mbr=1

if ($mbr < 10) then
	setenv CASE f.e21.${COMPSET}.${RESOLN}.${EXPERIMENT}.00${mbr}
else
	setenv CASE f.e21.${COMPSET}.${RESOLN}.${EXPERIMENT}.0${mbr}
endif

if ($MACHINE == cori-knl) then
	set PATH      = /global/project/projectdirs/ccsm1/people/nanr/
	set RUNDIR    = /global/cscratch1/sd/nanr/$CASE/run
	set BLDDIR    = /global/cscratch1/sd/nanr/$CASE/bld
	setenv CASEROOT $PATH/cases/cesm21/trbelt/$CASE
        set TOOLSROOT = /global/homes/n/nanr/CESM_tools/cesm2-trbelt
	set REFROOT   = /global/cscratch1/sd/nanr/archive
        set ICEOCNDOMAIN = $PATH/VRM/ne0np4.trbelt.ne30x8/domains
        set ATMLNDDOMAIN = $PATH/VRM/ne0np4.trbelt.ne30x8/domains
else 
	set PATH      = /glade/work/nanr/
	set RUNDIR    = /glade/scratch/nanr/$CASE/run
	set BLDDIR    = /glade/scratch/nanr/$CASE/bld
	setenv CASEROOT /glade/work/nanr/trbelt/$CASE
        set TOOLSROOT = /glade/work/nanr/cesm_tags/CASE_tools/cesm2-trbelt
        set REFROOT   = /glade/scratch/nanr/archive/
        set ICEOCNDOMAIN = /glade/work/brianpm/VRM/ne0np4.trbelt.ne30x8/domains
        set ATMLNDDOMAIN = /glade/work/brianpm/VRM/ne0np4.trbelt.ne30x8/domains

endif

setenv CESMROOT ${PATH}/cesm_tags/${TAG}/


$CESMROOT/cime/scripts/create_newcase --case $CASEROOT --res $RESOLN  --mach $MACHINE --compset $COMPSET --pecount L --run-unsupported

cd $CASEROOT

set doThis = 1
if ($doThis == 1) then
if ($MACHINE == cori-knl) then
	./xmlchange NTASKS_CPL=16256
	./xmlchange ROOTPE_CPL=1216
	./xmlchange NTASKS_ATM=16256
	./xmlchange NTASKS_LND=4096
	./xmlchange NTASKS_ICE=8192
	./xmlchange ROOTPE_ICE=4096
	./xmlchange NTASKS_OCN=16256
	./xmlchange ROOTPE_OCN=16256
	./xmlchange NTASKS_ROF=1280
	./xmlchange NTASKS_GLC=64
	./xmlchange NTASKS_WAV=64
	./xmlchange JOB_WALLCLOCK_TIME=24:00:00 --subgroup case.run

else
	./xmlchange NTASKS_CPL=7200
	./xmlchange NTASKS_ATM=7200
	./xmlchange NTASKS_LND=7200
	./xmlchange NTASKS_ICE=7200
	./xmlchange ROOTPE_ICE=7200
	./xmlchange NTASKS_OCN=7200
	./xmlchange ROOTPE_OCN=7200
	./xmlchange NTASKS_ROF=7200
	./xmlchange NTASKS_GLC=1
	./xmlchange NTASKS_WAV=1
endif
endif

./xmlchange STOP_OPTION=$STOP_OPTION
./xmlchange STOP_N=$STOP_N
./xmlchange RUN_TYPE=startup
./xmlchange ICE_DOMAIN_FILE=domain.ocn.ne0np4.trbelt.ne30x8_gx1v7.210414.nc
./xmlchange ICE_DOMAIN_PATH=$ICEDOMAINPATH
./xmlchange OCN_DOMAIN_FILE=domain.ocn.ne0np4.trbelt.ne30x8_gx1v7.210414.nc
./xmlchange OCN_DOMAIN_PATH=$ICEOCNDOMAIN
./xmlchange ATM_DOMAIN_FILE=domain.lnd.ne0np4.trbelt.ne30x8_gx1v7.210414.nc
./xmlchange ATM_DOMAIN_PATH=$ATMLNDDOMAIN
./xmlchange LND_DOMAIN_FILE=domain.lnd.ne0np4.trbelt.ne30x8_gx1v7.210414.nc
./xmlchange LND_DOMAIN_PATH=$ATMLNDDOMAIN


if ($MACHINE == cheyenne) then
        ./xmlchange PROJECT=P93300313
endif

./case.setup --reset; 
if ($MACHINE == cheyenne) then
qcmd -- ./case.build
else
./case.build
endif

