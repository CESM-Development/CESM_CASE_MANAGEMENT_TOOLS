#!/bin/bash
#!!! warning - I've set the following in user_nl_cam

usembr='002'
usembr='003'

curdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-L83/'
compset='BSSP370cmip6'
resoln='f09_g17'
runname='b.e21.'$compset'.'$resoln'.L83_cam6.'$usembr
#tagdir='/glade/work/islas/cesm2.1.4-rc.08/'
tagdir='/glade/work/nanr/cesm_tags/git_sandbox/cesm2.1.4-rc.11/'
caseroot='/glade/work/nanr/L83/'
casedir=$caseroot/$runname
cd $tagdir/cime/scripts

./create_newcase --case $casedir --res $resoln --compset $compset --run-unsupported

cd $casedir

./xmlchange --append --file env_build.xml -id CAM_CONFIG_OPTS --val=" -nlev=83"
 
./xmlchange PROJECT=P93300313
./xmlchange STOP_N=24
./xmlchange STOP_OPTION=nmonths
./xmlchange REST_N=6
./xmlchange REST_OPTION=nmonths
#./xmlchange JOB_QUEUE=economy --subgroup case.run
./xmlchange RESUBMIT=2
# copy Jim's PE layout
# Try /glade/derecho/scratch/jedwards/b.e21.BSSP370cmip6.f09_g17.L83_cam6.002a/env_mach_pes.xml.1242150
# timing/cesm_timing.b.e21.BSSP370cmip6.f09_g17.L83_cam6.002a.1242150.desched1.230718-084905:    Model Cost:           10428.36   pe-hrs/simulated_year
# timing/cesm_timing.b.e21.BSSP370cmip6.f09_g17.L83_cam6.002a.1242150.desched1.230718-084905:    Model Throughput:         4.42   simulated_years/day

cp $curdir/PES/env_mach_pes.xml-derecho $casedir/env_mach_pes.xml

./xmlchange RUN_TYPE='hybrid'
./xmlchange RUN_REFDIR='/glade/derecho/scratch/nanr/archive/b.e21.BHISTcmip6.f09_g17.L83_cam6.'$usembr'/rest/2015-01-01-00000/'
./xmlchange RUN_REFCASE='b.e21.BHISTcmip6.'$resoln'.L83_cam6.'$usembr
#./xmlchange RUN_REFDATE='2015-01-01'
#./xmlchange RUN_REFDATE='2015-01-01'

./case.setup

# originals from Isla: /glade/u/home/islas/CVCWG/L83_coupled_cam6/
cp $curdir/SourceMods/src.cam/* ./SourceMods/src.cam/
cp $curdir/SourceMods/src.clm/* ./SourceMods/src.clm/
cp $curdir/user_nl_files/SSP370-branch/user_nl_cam .
cp $curdir/user_nl_files/SSP370-branch/user_nl_cice .
cp $curdir/user_nl_files/SSP370-branch/user_nl_clm .
cp $curdir/user_nl_files/SSP370-branch/user_nl_cpl .
cp $curdir/user_nl_files/SSP370-branch/user_nl_mosart .
cp $curdir/user_nl_files/SSP370-branch/user_nl_ww .

 
