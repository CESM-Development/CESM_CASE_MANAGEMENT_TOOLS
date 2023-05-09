#!/bin/bash
#!!! warning - I've set the following in user_nl_cam

mbr='002'
#mbr='003'

curdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-L83/'
compset='BHISTcmip6'
resoln='f09_g17'
runname='b.e21.'$compset'.'$resoln'.L83_cam6.'$mbr
#tagdir='/glade/work/islas/cesm2.1.4-rc.08/'
tagdir='/glade/work/nanr/cesm_tags/git_sandbox/cesm2.1.4-rc.11/'
caseroot='/glade/work/nanr/L83/'
casedir=$caseroot/$runname
#mv $caseroot/$runname $caseroot/$runname'-preBranch'


cd $tagdir/cime/scripts

./create_newcase --case $casedir --res $resoln --compset $compset --run-unsupported

cd $casedir

./xmlchange --append --file env_build.xml -id CAM_CONFIG_OPTS --val=" -nlev=83"
 
./xmlchange PROJECT=P93300313
./xmlchange STOP_N=3
./xmlchange STOP_OPTION=nyears
./xmlchange JOB_QUEUE=economy --subgroup case.run
./xmlchange RESUBMIT=5
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


./xmlchange RUN_TYPE='branch'
./xmlchange RUN_REFCASE=$runname

 restyear='1876'
 userest='1876-01-01'
 echo ${restyear}
 echo '/glade/scratch/nanr/archive/'$runname'/rest/'${restyear}'-01-01-00000/'
 ./xmlchange RUN_REFDATE='1876-01-01'

./case.setup

# originals from Isla: /glade/u/home/islas/CVCWG/L83_coupled_cam6/
cp $curdir/SourceMods/src.cam/* ./SourceMods/src.cam/
cp $curdir/SourceMods/src.clm/* ./SourceMods/src.clm/
cp $curdir/user_nl_files/BHIST-branch/user_nl_cam ./user_nl_cam
cp $curdir/user_nl_files/BHIST-branch/user_nl_cice .
cp $curdir/user_nl_files/BHIST-branch/user_nl_clm .
cp $curdir/user_nl_files/BHIST-branch/user_nl_cpl .
cp $curdir/user_nl_files/BHIST-branch/user_nl_mosart .
cp $curdir/user_nl_files/BHIST-branch/user_nl_ww .

 
