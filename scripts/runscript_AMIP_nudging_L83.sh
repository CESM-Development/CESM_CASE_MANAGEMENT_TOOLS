#!/bin/bash
#!!! warning - I've set the following in user_nl_cam
#ncdata='/glade/scratch/islas/archive/b.e21.B1850.f09_f09_mg17.L83_ogw2.001/rest/0037-01-01-00000/b.e21.B1850.f09_f09_mg17.L83_ogw2.001.cam.i.0037-01-01-00000.nc'


mbr='001'
mbr='002'
mbr='003'
curdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-L83/'
compset='FHIST_BGC'
resoln='f09_f09_mg17'
runname='f.e21.'$compset'.'$resoln'.L83_cam6_nudging.'$mbr
#tagdir='/glade/work/islas/cesm2.1.4-rc.08/'
tagdir='/glade/work/nanr/cesm_tags/git_sandbox/cesm2.1.4-rc.11/'
caseroot='/glade/work/nanr/L83/'
casedir=$caseroot/$runname
rundir=/glade/scratch/nanr/$runname
cd $tagdir/cime/scripts

./create_newcase --case $casedir --res $resoln --compset $compset --run-unsupported

cd $casedir

./xmlchange --append --file env_build.xml -id CAM_CONFIG_OPTS --val="-co2_cycle -nlev=83"
 
./xmlchange PROJECT=P93300313
./xmlchange STOP_N=3
./xmlchange STOP_OPTION=nyears
./xmlchange RESUBMIT=0
./xmlchange NTASKS_CPL=720
./xmlchange NTASKS_ATM=720
./xmlchange NTASKS_LND=720
./xmlchange NTASKS_ICE=720
./xmlchange NTASKS_OCN=720
./xmlchange NTASKS_ROF=720
./xmlchange NTASKS_GLC=720
./xmlchange NTASKS_WAV=720 


# GOGA SST
SSTFILE="/glade/p/cgd/cas/asphilli/cam_input_data/sst_ERSSTv5_bc_0.9x1.25_1870_2020_c200625.nc"
./xmlchange SSTICE_YEAR_ALIGN='1870'
./xmlchange SSTICE_YEAR_START='1870'
./xmlchange SSTICE_YEAR_END='2020'
./xmlchange SSTICE_DATA_FILENAME=$SSTFILE

if [[ ${mbr} == 001 ]]
then
   restyear='0106'
   userest='0106-01-01'
   echo 'member -= ${mbr} and rest = ${restyear}'
    ./xmlchange RUN_REFDATE='0106-01-01'
fi
if [[ ${mbr} == 002 ]]
then
    restyear='0100'
    userest='0100-01-01'
    echo ${restyear}
    echo '/glade/scratch/islas/archive/b.e21.B1850.f09_g17.L83_cam6.001/rest/'${restyear}'-01-01-00000/'
    ./xmlchange RUN_REFDATE='0100-01-01'
    ./xmlchange EXEROOT='/glade/scratch/nanr/f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging.001/bld/'
    ./xmlchange BUILD_COMPLETE=TRUE
fi
if [[ ${mbr} == 003 ]]
then
    restyear='0103'
    userest='0103-01-01'
    echo 'member - ${mbr} and rest = ${restyear}'
    restdir='/glade/scratch/islas/archive/b.e21.B1850.f09_g17.L83_cam6.001/rest/'${restyear}'-01-01-00000/'
    ./xmlchange RUN_REFDATE='0103-01-01'
    ./xmlchange EXEROOT='/glade/scratch/nanr/f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging.001/bld/'
    ./xmlchange BUILD_COMPLETE=TRUE
fi
#echo 'Here I am'
#echo ${restyear}'-01-01'

./xmlchange RUN_TYPE='hybrid'
#./xmlchange RUN_REFDIR='/glade/scratch/islas/archive/b.e21.B1850.f09_g17.L83_cam6.001/rest/'${restyear}'-01-01-00000/'
#./xmlchange RUN_REFDIR='/glade/scratch/islas/archive/b.e21.B1850.f09_g17.L83_cam6.001/rest/0100-01-01-00000/'
./xmlchange RUN_REFCASE='b.e21.B1850.f09_g17.L83_cam6.001'
./xmlchange RUN_STARTDATE='1979-01-01'

./case.setup

# originals from Isla: /glade/u/home/islas/CVCWG/L83_coupled_cam6/
cp $curdir/SourceMods/src.cam/* ./SourceMods/src.cam/
cp $curdir/SourceMods/src.clm/* ./SourceMods/src.clm/

cp /glade/u/home/islas/CVCWG/QBOi/nudging_nansand_cesm214rc11/srcmods/* ./SourceMods/src.cam/

cp $curdir/user_nl_files/AMIP-nudging/user_nl_cam ./user_nl_cam
cp $curdir/user_nl_files/AMIP-nudging/user_nl_cice .
cp $curdir/user_nl_files/AMIP-nudging/user_nl_clm .
cp $curdir/user_nl_files/AMIP-nudging/user_nl_cpl .
cp $curdir/user_nl_files/AMIP-nudging/user_nl_mosart .
cp $curdir/user_nl_files/AMIP-nudging/user_nl_ww .

#cp '/glade/scratch/islas/archive/b.e21.B1850.f09_g17.L83_cam6.001/rest/'${restyear}'-01-01-00000/rpointer* '${rundir}'/run/'
#ln -s '/glade/scratch/islas/archive/b.e21.B1850.f09_g17.L83_cam6.001/rest/'${restyear}'-01-01-00000/b.e21* '${rundir}'/run/'
 
