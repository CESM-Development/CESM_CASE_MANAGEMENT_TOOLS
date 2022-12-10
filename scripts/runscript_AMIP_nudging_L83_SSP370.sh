#!/bin/bash
#!!! warning - I've set the following in user_nl_cam
#ncdata='/glade/scratch/islas/archive/b.e21.B1850.f09_f09_mg17.L83_ogw2.001/rest/0037-01-01-00000/b.e21.B1850.f09_f09_mg17.L83_ogw2.001.cam.i.0037-01-01-00000.nc'


mbr='003'
mbr='002'
mbr='001'
curdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-L83/'
compset='FHIST_BGC'
resoln='f09_f09_mg17'
runname='f.e21.'$compset'.'$resoln'.L83_cam6_nudging_SSP370.'$mbr
#tagdir='/glade/work/islas/cesm2.1.4-rc.08/'
tagdir='/glade/work/nanr/cesm_tags/git_sandbox/cesm2.1.4-rc.11/'
caseroot='/glade/work/nanr/L83/'
casedir=$caseroot/$runname
rundir=/glade/scratch/nanr/$runname/run

echo $rundir

cd $tagdir/cime/scripts

./create_newcase --case $casedir --res $resoln --compset $compset --run-unsupported

cd $casedir

./xmlchange --append --file env_build.xml -id CAM_CONFIG_OPTS --val="-co2_cycle -nlev=83"

./xmlchange RUN_TYPE=hybrid
./xmlchange GET_REFCASE=FALSE
./xmlchange RUN_REFCASE=f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging.${mbr}
./xmlchange RUN_REFDATE='2015-01-01'
./xmlchange RUN_STARTDATE='2015-01-01'
 
./xmlchange PROJECT=P93300313
./xmlchange STOP_N=3
./xmlchange STOP_OPTION=nyears
./xmlchange RESUBMIT=1

./xmlchange NTASKS_CPL=720
./xmlchange NTASKS_ATM=720
./xmlchange NTASKS_LND=720
./xmlchange NTASKS_ICE=720
./xmlchange NTASKS_OCN=720
./xmlchange NTASKS_ROF=720
./xmlchange NTASKS_GLC=720
./xmlchange NTASKS_WAV=720 

./case.setup


# GOGA SST
SSTFILE="/glade/p/cgd/cas/asphilli/cam_input_data/sst_ERSSTv5_bc_0.9x1.25_1870_2021_c210824.nc"
./xmlchange SSTICE_YEAR_ALIGN='1870'
./xmlchange SSTICE_YEAR_START='1870'
./xmlchange SSTICE_YEAR_END='2021'
./xmlchange SSTICE_DATA_FILENAME=$SSTFILE

# originals from Isla: /glade/u/home/islas/CVCWG/L83_coupled_cam6/
cp $curdir/SourceMods/src.cam/* ./SourceMods/src.cam/
cp $curdir/SourceMods/src.clm/* ./SourceMods/src.clm/

cp /glade/u/home/islas/CVCWG/QBOi/nudging_nansand_cesm214rc11/srcmods/* ./SourceMods/src.cam/

cp $curdir/user_nl_files/AMIP-nudging-SSP370/user_nl_cam ./user_nl_cam
cp $curdir/user_nl_files/AMIP-nudging-SSP370/user_nl_cice .
cp $curdir/user_nl_files/AMIP-nudging-SSP370/user_nl_clm .
cp $curdir/user_nl_files/AMIP-nudging-SSP370/user_nl_cpl .
cp $curdir/user_nl_files/AMIP-nudging-SSP370/user_nl_mosart .

# =========================
# add ncdata
# =========================
cat >> head.${mbr} << EOF
! add ncdata for 2015 branch extension
ncdata         = 'f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging.${mbr}.cam.i.2015-01-01-00000.nc'

EOF

mv user_nl_cam tmp.cam
cat head.${mbr} tmp.cam  > user_nl_cam
rm tmp.cam head.${mbr}

mkdir -p $rundir

echo "made it this far"
  
echo "/glade/scratch/nanr/archive/f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging.${mbr}/rest/2015-01-01-00000/rpointer* $rundir"
cp /glade/scratch/nanr/archive/f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging.${mbr}/rest/2015-01-01-00000/rpointer* $rundir
ln -s /glade/scratch/nanr/archive/f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging.${mbr}/rest/2015-01-01-00000/f* $rundir/

#if [$mbr != '001']
#then
#./xmlchange EXEROOT='/glade/scratch/nanr/f.e21.FHIST_BGC.f09_f09_mg17.L83_cam6_nudging_SSP370.001/bld/'
#./xmlchange BUILD_COMPLETE=TRUE
#fi
