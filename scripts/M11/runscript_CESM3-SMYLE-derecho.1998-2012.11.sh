#!/bin/bash

for useyear in $(seq 1998 2012)
do
usemonth=11

curdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm3-smyle/'
srcdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm3-smyle/'
usecompset='BHISTC_LTso_SMYLE'
usetag='e30_beta06'
resoln='ne30pg3_t232_wg37'
tagdir='/glade/work/nanr/cesm_tags/cesm3_sandbox/cesm3_0_beta06/'
caseroot='/glade/work/nanr/CESM3-SMYLE/'

main_case_root='b.'$usetag'.'$usecompset'.'$resoln'.'${useyear}'-'${usemonth}'.001'

for mbr in $(seq -f "%03g" 1 1)
do

echo "setting up member ${mbr}"

casename='b.'$usetag'.'$usecompset'.'$resoln'.'$useyear'-'$usemonth'.'$mbr
casedir=$caseroot/$casename
rundir=/glade/derecho/scratch/nanr/CESM3-SMYLE/${main_case_root}/run.${mbr}/

echo $rundir

#============= START =======

cd $tagdir/cime/scripts

## Create new case (use a special compset for ww)
./create_newcase \
  --compset HISTC_CAM70%LT_CLM60%BGC-CROP_CICE_MOM6_MOSART_DGLC%NOEVOLVE_WW3_SESP \
  --res $resoln --case $casedir --run-unsupported

cd $casedir


## Make sure you get rrtmgp and hycom1 (they may be coming out of the box)
#./xmlchange --append CAM_CONFIG_OPTS="-rad rrtmgp"
#./xmlchange MOM6_VERTICAL_GRID=hycom1

## Namelist settings
cat <<EOF > user_nl_cam

solar_irrad_data_file = '/glade/campaign/cesm/development/cross-wg/inputdata/SolarForcingCMIP7piControl_c20250103.nc'
micro_mg_dcs = 600.D-6
clubb_c8 = 4.6
cldfrc_dp1 = 0.05
bnd_topo = '/glade/campaign/cgd/amp/pel/topo/cesm3/ne30pg3_gmted2010_modis_bedmachine_nc3000_Laplace0050_noleak_20250325.nc'

EOF

# =========================
# add pertlim perturbation to
# micro members 2 .. N
# =========================

if [[ ${mbr} != "001" ]]
then
cat >> head.${mbr} << EOF
! micro-member perturbation
pertlim = ${mbr}.d-14

EOF

mv user_nl_cam tmp.cam
cat head.${mbr} tmp.cam  > user_nl_cam
rm tmp.cam head.${mbr}

fi
# =========================
# END - pertlim
# =========================


cat <<EOF > user_nl_clm
! Do this for isotopes
use_c13 = .true.
use_c14 = .true.
use_c13_timeseries = .true.
use_c14_bombspike = .true.
use_init_interp = .true.

! Turn off shifting cultivation
reseed_dead_plants = .true.
paramfile = '/glade/campaign/cesm/development/amwg/inputdata_extra/ctsm5.3.012.Nfix_params.v13.c250221_upplim250.nc'

EOF

cat <<EOF > user_nl_cpl
histaux_l2x1yrg = .true.
!aoflux_grid = 'xgrid'
EOF

cat <<EOF > user_nl_mom
MAXTRUNC = 2000
EOF

## SourceMods
cp $curdir/SourceMods/src.cam/* SourceMods/src.cam
cp $curdir/SourceMods/src.clm/* SourceMods/src.clm
cp $curdir/SourceMods/src.drv/* SourceMods/src.drv


# ============== END =========
#./xmlchange CLM_NAMELIST_OPTS=use_init_interp=.true.
#./xmlchange CCSM_BGC=CO2A
#./xmlchange DIN_LOC_ROOT_CLMFORC=/glade/p/cgd/tss/CTSM_datm_forcing_data

./xmlchange JOB_WALLCLOCK_TIME=12:00:00 --subgroup case.run
./xmlchange RUN_TYPE=hybrid
./xmlchange GET_REFCASE=FALSE
./xmlchange RUN_REFCASE=b.e30.SMYLE_IC.ne30pg3_t232_wg37.${useyear}-${usemonth}.01
./xmlchange RUN_REFDATE=${useyear}-${usemonth}-01
./xmlchange RUN_STARTDATE=${useyear}-${usemonth}-01
./xmlchange DOUT_S_ROOT=/glade/derecho/scratch/nanr/CESM3-SMYLE/archive/$casename/
./xmlchange CIME_OUTPUT_ROOT=/glade/derecho/scratch/nanr/CESM3-SMYLE/
./xmlchange RUNDIR=$rundir
 
./xmlchange PROJECT=CESM0020
./xmlchange STOP_N=24
./xmlchange REST_N=24
./xmlchange STOP_OPTION=nmonths
./xmlchange RESUBMIT=0

./case.setup 
./preview_namelists

./xmlchange EXEROOT='/glade/derecho/scratch/nanr/CESM3-SMYLE/exerootdir/bld'
./xmlchange BUILD_COMPLETE=TRUE
#./xmlchange JOB_PRIORITY=economy

mkdir -p $rundir

#echo "made it this far"
  
# cp /glade/derecho/scratch/slevis/archive/ctsm53019_f09_BNF_hist/rest/1997-11-01-00000/ctsm53019_f09_BNF_hist.*.r.1997-11-01-00000.nc $RUNDIR/
# cp /glade/derecho/scratch/slevis/archive/ctsm53019_f09_BNF_hist/rest/1997-11-01-00000/rpointer.lnd.1997-11-01-00000 $RUNDIR/
# cp /glade/derecho/scratch/slevis/archive/ctsm53019_f09_BNF_hist/rest/1997-11-01-00000/rpointer.rof.1997-11-01-00000 $RUNDIR/
  # Lastly - copy Initial conditions
    echo "Here is the RUNDIR ${rundir}"
    ics="/glade/campaign/cesm/development/espwg/CESM3_ERA5_IC/inputdata/cesm3_init/b.e30.SMYLE_IC.ne30pg3_t232_wg37.${useyear}-${usemonth}.01/"

    ls ${rundir}

    # pre-stage ICs
    cp ${ics}/${useyear}-${usemonth}-01/rpointer.* ${rundir}/
    cp ${ics}/${useyear}-${usemonth}-01/b.e30.* ${rundir}/

    cd $casedir
    #if [[ ${mbr} == "021" ]]
    #then
       #cd $casedir
       #qcmd -- ./case.build
    #fi
    ./case.submit

done
done
