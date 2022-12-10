#!/bin/bash
#!!! warning - I've set the following in user_nl_cam
#ncdata='/glade/scratch/islas/archive/b.e21.B1850.f09_f09_mg17.L83_ogw2.001/rest/0037-01-01-00000/b.e21.B1850.f09_f09_mg17.L83_ogw2.001.cam.i.0037-01-01-00000.nc'


curdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-L83/'
compset='BHISTcmip6'
resoln='f09_g17'
runname='b.e21.'$compset'.'$resoln'.L83_cam6.001'
#tagdir='/glade/work/islas/cesm2.1.4-rc.08/'
tagdir='/glade/work/nanr/cesm_tags/git_sandbox/cesm2.1.4-rc.11/'
caseroot='/glade/work/nanr/L83/'
casedir=$caseroot/$runname
cd $tagdir/cime/scripts

./create_newcase --case $casedir --res $resoln --compset $compset --run-unsupported

cd $casedir

./xmlchange --append --file env_build.xml -id CAM_CONFIG_OPTS --val=" -nlev=83"
 
./xmlchange PROJECT=P93300313
./xmlchange STOP_N=3
./xmlchange STOP_OPTION=nyears
./xmlchange JOB_QUEUE=economy --subgroup case.run
./xmlchange RESUBMIT=2
# copy Isla's PE layout
cp /glade/work/islas/cesm2.1.4-rc.08/runs/b.e21.B1850.f09_g17.L83_cam6.001/env_mach_pes.xml .

#Comp  NTASKS  NTHRDS  ROOTPE
#CPL :   1152/     3;      0
#ATM :   1152/     3;      0
#LND :    864/     3;      0
#ICE :    252/     3;    468
#OCN :    144/     3;    576
#ROF :    864/     3;      0
#GLC :   1152/     3;      0
#WAV :     36/     3;    540
#ESP :      1/     3;      0


./xmlchange RUN_TYPE='hybrid'
#./xmlchange RUN_REFDIR='/glade/scratch/islas/archive/b.e21.B1850.f09_g17.L83_cam6.001/rest/0106-01-01-00000/'
./xmlchange RUN_REFCASE='b.e21.B1850.f09_g17.L83_cam6.001'
./xmlchange RUN_REFDATE='0106-01-01'

./case.setup

# originals from Isla: /glade/u/home/islas/CVCWG/L83_coupled_cam6/
cp $curdir/SourceMods/src.cam/* ./SourceMods/src.cam/
cp $curdir/SourceMods/src.clm/* ./SourceMods/src.clm/
cp $curdir/user_nl_files/AMIP/user_nl_cam-QBOi ./user_nl_cam
cp $curdir/user_nl_files/AMIP/user_nl_cice .
cp $curdir/user_nl_files/AMIP/user_nl_clm .
cp $curdir/user_nl_files/AMIP/user_nl_cpl .
cp $curdir/user_nl_files/AMIP/user_nl_mosart .
cp $curdir/user_nl_files/AMIP/user_nl_ww .

 
