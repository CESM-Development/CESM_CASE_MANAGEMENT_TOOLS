#!/bin/bash

# CESM3 CMIP7 run_cesm3 script template.
#
# Inspired by E3SM Water Cycle Group run_e3sm script.

main() {

# Year array YYYY:

echo ${iyr}
ctr=$((ctr+1))

# --- Configuration flags ----
curdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm3/'
srcdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm3/'
compset='B1850C_LTso'
usetag='e30_beta06'
resoln='ne30pg3_t232_wg37'
useresoln='ne30_t232_wgx3'
tagdir='/glade/work/hannay/cesm_tags/cesm3_0_beta06/'
caseroot='/glade/campaign/cesm/cesmdata/cseg/runs/cesm2_0/'

#main_case_root='b.'$usetag'.'$compset'.'$resoln'.001'

# Run options
START_DATE="1850-01-01"
REFDATE="0077-01-01"
REFDIR="/glade/derecho/scratch/nanr/archive/"
REFCASE="myRun"
RUNTYPE="hybrid"
GETREFCASE=TRUE
PROJECT="P93300313"

STOP_OPTION=nyears
REST_OPTION=nyears
STOP_N=5
REST_N=5
RESUBMIT=10

# --- Toggle flags for what to do ----
do_fetch_code=true
do_create_newcase=true
do_case_setup=true
do_case_build=false
do_case_submit=false

for mbr in $(seq -f "%03g" 183 183)
do

echo "setting up member ${mbr}"

casename='b.'$usetag'.'$compset'.'$useresoln'.'$mbr
casedir=$caseroot/$casename
rundir=/glade/derecho/scratch/nanr/$casename/run/

echo $rundir
mkdir -p $rundir

#============= START =======

cd $tagdir/cime/scripts

## Create new case (use a special compset for ww)
./create_newcase --compset $compset --res $resoln --case $casedir --run-unsupported

cd $casedir

## Namelist settings  ========

## SourceMods
cp $curdir/SourceMods-166/src.cam/* SourceMods/src.cam
cp $curdir/SourceMods-166/src.clm/* SourceMods/src.clm
cp $curdir/SourceMods-166/src.drv/* SourceMods/src.drv


# ============== END =========

./xmlchange RUN_REFCASE=b.e30_alpha06e.B1850C_LTso.ne30_t232_wgx3.156
./xmlchange RUN_REFDATE=${REFDATE}
./xmlchange RUN_STARTDATE=${START_DATE}
./xmlchange RUN_TYPE=${RUNTYPE}
./xmlchange RUN_REFDIR=cesm2_init
./xmlchange GET_REFCASE=${GETREFCASE}
 
./xmlchange JOB_PRIORITY=regular
./xmlchange PROJECT=CESM0024,RESUBMIT=10,STOP_N=4,STOP_OPTION=nyears
./xmlchange JOB_WALLCLOCK_TIME=12:00:00  --subgroup case.run


### NAMELIST FILES ===========================================================================
cp user_nl_cam user_nl_cam-OTB

cat <<EOF>> user_nl_cam
mfilt               =       0,       5,     20,      40,      12,      120,      1,   1
nhtfrq              =       0,     -24,    -24,      -3,       0,       -2,      0,  -8760
ndens               =       2,       2,      2,       2,       2,        1,      2,   1
interpolate_output  =  .true.,  .true., .true.,  .true., .false.,   .true.,     .true.
interpolate_nlat    =     192,     192,    192,     192,      192,     192,      192
interpolate_nlon    =     288,     288,    288,     288,      288,     288,      288

empty_htapes = .true.

fincl1 = 'ACTNI', 'ACTNL', 'ACTREI', 'ACTREL', 'AODDUST', 'AODDUSTdn','AODVIS', 'AODVISdn','BURDENBC',
'BURDENDUST', 'BURDENPOM', 'BURDENSEASALT',
'BURDENSO4', 'BURDENSOA', 'CAPE', 'CCN3', 'CDNUMC', 'CH4', 'CLDHGH', 'CLDICE', 'CLDLIQ', 'CLDLOW',
'CLDMED', 'CLDTOT', 'CLOUD', 'CMFMC_DP',
'CT_H2O', 'DCQ', 'DQCORE', 'DTCOND', 'DTCORE', 'DTV', 'EVAPPREC', 'EVAPSNOW', 'FCTI', 'FCTL', 'FICE', 'FLDS', 'FLNS', 'FLNSC', 'FLNT', 'FLNTC', 'FLUT',
'FREQZM', 'FSDS', 'FSDSC', 'FSNS', 'FSNSC', 'FSNT', 'FSNTC', 'FSNTOA', 'ICEFRAC', 'LANDFRAC', 'LHFLX', 'LWCF', 'MPDICE', 'MPDLIQ', 'MPDQ', 'MPDT',
'OCNFRAC', 'OMEGA', 'OMEGA500', 'PBLH', 'PHIS', 'PINT', 'PMID', 'PRECC', 'PRECL', 'PRECSC', 'PRECSL', 'PRECT', 'PS', 'PSL', 'PTEQ', 'PTTEND', 'Q',
'QFLX', 'QRL', 'QRS', 'QTGW', 'RCMTEND_CLUBB', 'RELHUM', 'RVMTEND_CLUBB', 'SHFLX', 'SOLIN', 'SST',
'STEND_CLUBB', 'SWCF', 'T', 'TAUX', 'TAUY', 'TFIX', 'TGCLDIWP', 'TGCLDLWP', 'TMQ', 'TREFHT', 'TS', 'TTGW', 'U', 'U10', 'UBOT', 'UTGWORO', 'UTGW_TOTAL',
'V', 'VBOT', 'VTGWORO', 'VTGW_TOTAL', 'WPRTP_CLUBB', 'WPTHLP_CLUBB', 'Z3', 'ZMDQ', 'ZMDT', 'N2O', 'CO2','CFC11','CFC12', 'AODVISdn','CCN3', 'CDNUMC', 'H2O', 'NUMICE', 'NUMLIQ','OMEGA500', 'AQSO4_H2O2','AQSO4_O3', 'bc_a1', 'bc_a4', 'dst_a1', 'dst_a2', 'dst_a3', 'ncl_a1',
'ncl_a1', 'ncl_a2', 'ncl_a3', 'pom_a1', 'pom_a4', 'so4_a1', 'so4_a2', 'so4_a3', 'soa_a2' ,
'soa_a1', 'num_a1', 'num_a2', 'num_a3', 'num_a4',
'bc_a1SFWET', 'bc_a4SFWET', 'dst_a1SFWET', 'dst_a2SFWET', 'dst_a3SFWET', 'ncl_a1SFWET',
'ncl_a2SFWET', 'ncl_a3SFWET', 'pom_a1SFWET', 'pom_a4SFWET', 'so4_a1SFWET', 'so4_a2SFWET', 'so4_a3SFWET', 'soa_a1SFWET',
'soa_a2SFWET', 'bc_c1SFWET', 'bc_c4SFWET', 'dst_c1SFWET', 'dst_c2SFWET', 'dst_c3SFWET', 'ncl_c1SFWET', 'ncl_c2SFWET',
'ncl_c3SFWET', 'pom_c1SFWET', 'pom_c4SFWET', 'so4_c1SFWET', 'so4_c2SFWET', 'so4_c3SFWET', 'soa_c1SFWET', 'soa_c2SFWET',
'bc_a1DDF', 'bc_a4DDF', 'dst_a1DDF', 'dst_a2DDF', 'dst_a3DDF', 'ncl_a1DDF', 'ncl_a2DDF', 'ncl_a3DDF',
'pom_a1DDF', 'pom_a4DDF', 'so4_a1DDF', 'so4_a2DDF', 'so4_a3DDF', 'soa_a1DDF', 'soa_a2DDF',
'so4_a1_CLXF', 'so4_a2_CLXF', 'SFbc_a4', 'SFpom_a4', 'SFso4_a1', 'SFso4_a2',
'so4_a1_sfgaex1', 'so4_a2_sfgaex1', 'so4_a3_sfgaex1', 'soa_a1_sfgaex1', 'soa_a2_sfgaex1',
'SFdst_a1','SFdst_a2', 'SFdst_a3', 'SFncl_a1', 'SFncl_a2', 'SFncl_a3',
'num_a2_sfnnuc1', 'SFSO2', 'OCN_FLUX_DMS', 'SAD_SULFC', 'SAD_TROP', 'SAD_AERO',
'AODVISstdn', 'REFF_AERO', 'so4_a1', 'so4_a2', 'SAD_AERO', 'PS', 'TROP_P', 'FSNTOAC',
'CME', 'CMEIOUT'

fincl3 = 'PRECT', 'PRECC', 'FLUT', 'U850', 'U200', 'V850', 'V200', 'OMEGA500', 'TS', 'SST', 'PSL', 'Z500'

fincl4 =  'PRECC','PRECL'

fincl5 = 'Uzm','Vzm','Wzm','THzm', 'VTHzm','WTHzm','UVzm','UWzm'
phys_grid_ctem_nfreq=-6
phys_grid_ctem_zm_nbas=120
phys_grid_ctem_za_nlat=90

solar_irrad_data_file= '/glade/campaign/cesm/development/cross-wg/inputdata/SolarForcingCMIP7piControl_c20250103.nc'
bnd_topo = '/glade/campaign/cgd/amp/pel/topo/cesm3/ne30pg3_gmted2010_modis_bedmachine_nc3000_Laplace0050_noleak_20250325.nc'

micro_mg_dcs= 600.D-6
cldfrc_dp1 =  0.05
clubb_c8 = 4.6

 ext_frc_cycle_yr               =  1850
 ext_frc_specifier              = 'num_a1 -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_num_so4_a1_anthro-ene_vertical_1750-2015_ne30pg3_c20250711.nc',
         'num_a1 -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_num_a1_so4_contvolcano_vertical_850-5000_ne30pg3_c20250711.nc',
         'num_a2 -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_num_a2_so4_contvolcano_vertical_850-5000_ne30pg3_c20250711.nc',
         'SO2    -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_SO2_contvolcano_vertical_850-5000_ne30pg3_c20250711.nc',
         'so4_a1 -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_so4_a1_anthro-ene_vertical_1750-2015_ne30pg3_c20250711.nc',
         'so4_a1 -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_so4_a1_contvolcano_vertical_850-5000_ne30pg3_c20250711.nc',
         'so4_a2 -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_so4_a2_contvolcano_vertical_850-5000_ne30pg3_c20250711.nc'
 ext_frc_type           = 'CYCLICAL'

 srf_emis_cycle_yr              = 1850
 srf_emis_specifier             = 'bc_a4    -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_bc_a4_anthro_surface_1750-2015_ne30pg3_c20250711.nc',
         'bc_a4    -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_bc_a4_bb_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'DMS      -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_DMS_bb_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'num_a1   -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_num_so4_a1_bb_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'num_a1   -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_num_so4_a1_anthro-ag-ship_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'num_a2   -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_num_so4_a2_anthro-res_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'num_a4   -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_num_bc_a4_bb_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'num_a4   -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_num_bc_a4_anthro_surface_1750-2015_ne30pg3_c20250711.nc',
         'num_a4   -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_num_pom_a4_anthro_surface_1750-2015_ne30pg3_c20250711.nc',
         'num_a4   -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_num_pom_a4_bb_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'pom_a4   -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_pom_a4_anthro_surface_1750-2015_ne30pg3_c20250711.nc',
         'pom_a4   -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_pom_a4_bb_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'SO2      -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_SO2_anthro-ag-ship-res_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'SO2      -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_SO2_anthro-ene_surface_1750-2015_ne30pg3_c20250711.nc',
         'SO2      -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_SO2_bb_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'so4_a1   -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_so4_a1_anthro-ag-ship_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'so4_a1   -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_so4_a1_bb_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'so4_a2   -> /glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_so4_a2_anthro-res_surface_mol_175001-210101_ne30pg3_c20250711.nc',
         'SOAE -> 2.5592D0*/glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_BENZENE_anthro_surface_1750-2015_ne30pg3_c20250711.nc',
         'SOAE -> 2.5592D0*/glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_BENZENE_bb_surface_1750-2015_ne30pg3_c20250711.nc',
         'SOAE -> 0.5954D0*/glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_ISOP_bb_surface_1750-2015_ne30pg3_c20250711.nc',
         'SOAE -> 8.5371D0*/glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_IVOC_anthro_surface_1750-2015_ne30pg3_c20250711.nc',
         'SOAE -> 8.5371D0*/glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_IVOC_bb_surface_1750-2015_ne30pg3_c20250711.nc',
         'SOAE -> 5.1004D0*/glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_MTERP_bb_surface_1750-2015_ne30pg3_c20250711.nc',
         'SOAE -> 16.650D0*/glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_SVOC_anthro_surface_1750-2015_ne30pg3_c20250711.nc',
         'SOAE -> 16.650D0*/glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_SVOC_bb_surface_1750-2015_ne30pg3_c20250711.nc',
         'SOAE -> 8.2367D0*/glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_TOLUENE_anthro_surface_1750-2015_ne30pg3_c20250711.nc',
         'SOAE -> 8.2367D0*/glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_TOLUENE_bb_surface_1750-2015_ne30pg3_c20250711.nc',
         'SOAE -> 6.5013D0*/glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_XYLENES_anthro_surface_1750-2015_ne30pg3_c20250711.nc',
         'SOAE -> 6.5013D0*/glade/derecho/scratch/nanr/regrid/ne30/emissions-cmip6_XYLENES_bb_surface_1750-2015_ne30pg3_c20250711.nc'
 srf_emis_type          = 'CYCLICAL'

EOF


cp user_nl_clm user_nl_clm-OTB
cat <<EOF>> user_nl_clm
nfix_method = 'Bytnerowicz'
use_c13 = .true.
use_c14 = .true.
use_c13_timeseries = .true.
use_c14_bombspike = .true.
use_init_interp = .true.
do_grossunrep=.false.
reseed_dead_plants = .true.
paramfile = '/glade/campaign/cesm/development/amwg/inputdata_extra/ctsm5.3.012.Nfix_params.v13.c250221_upplim250.nc'
EOF

cp user_nl_cpl user_nl_cpl-OTB
cat <<EOF>> user_nl_cpl
histaux_l2x1yrg = .true.
EOF

cp user_nl_mom user_nl_mom-OTB
cat <<EOF>> user_nl_mom
MAXTRUNC = 2000
EOF

### END  ===========================================================================

./case.setup 
./preview_namelists
#./xmlchange CASE_GIT_REPOSITORY=git@github.com:NCAR/cesm_dev.git
## Error:  Writing nuopc_runconfig for components ['CPL', 'ATM', 'LND', 'ICE', 'OCN', 'ROF', 'GLC', 'WAV']
#  ERROR: Command: 'git -C /glade/campaign/cesm/cesmdata/cseg/runs/cesm2_0/b.e30_beta06.B1850C_LTso.ne30pg3_t232_wg37.001 ls-remote --heads git@github.com:NCAR/cesm_dev.git' failed with error '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#  @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
#  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#  IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
#  Someone could be eavesdropping on you right now (man-in-the-middle attack)!
#  It is also possible that a host key has just been changed.
#  The fingerprint for the RSA key sent by the remote host is
#  SHA256:uNiVztksCsDhcc0u9e8BujQXVUpKZIDTMczCvj3tD2s.


qcmd -A CESM0024 -- ./case.build

./case.submit

done
