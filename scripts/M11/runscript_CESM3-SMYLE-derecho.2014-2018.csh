#!/bin/bash

for useyear in $(seq 2015 2018)
do
#useyear=1992
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
#cd $casedir

#============= START =======

cd $tagdir/cime/scripts

## Create new case (use a special compset for ww)
./create_newcase \
  --compset HISTC_CAM70%LT_CLM60%BGC-CROP_CICE_MOM6_MOSART_DGLC%NOEVOLVE_WW3_SESP \
  --res $resoln --case $casedir --run-unsupported

#cd /glade/work/nanr/CESM3-SMYLE/b.e30_beta04.BLTHIST.ne30_t232_wgx3_SMYLE.001
#cd /glade/work/nanr/CESM3-SMYLE/b.${usetag}.${usecompset}.${resoln}.$mbr
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

&aircraft_emit_nl
 aircraft_datapath              = '/glade/p/cesmdata/cseg/inputdata/atm/cam/ggas'
 aircraft_specifier             = 'ac_CO2 -> emissions-cmip6_CO2_anthro_ac_ScenarioMIP_IAMC-AIM-ssp370_195001-205012_fv_0.9x1.25_c20201210.txt'
 aircraft_type          = 'SERIAL'
/

 ext_frc_specifier              = 'H2O    -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/elev/H2OemissionCH4oxidationx2_3D_L70_1849-2101_CMIP6ensAvg_SSP3-7.0_c190403.nc',
         'num_a1 -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_num_so4_a1_anthro-ene_vertical_mol_175001-210101_0.9x1.25_c20190222.nc',
         'num_a1 -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_num_a1_so4_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc',
         'num_a2 -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_num_a2_so4_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc',
         'SO2    -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_SO2_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc',
         'so4_a1 -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_so4_a1_anthro-ene_vertical_mol_175001-210101_0.9x1.25_c20190222.nc',
         'so4_a1 -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_so4_a1_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc',
         'so4_a2 -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_so4_a2_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc'
 ext_frc_type           = 'INTERP_MISSING_MONTHS'


 srf_emis_specifier             = 'bc_a4    -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_bc_a4_anthro_surface_mol_175001-210101_0.9x1.25_c20190222.nc',
         'bc_a4    -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_bc_a4_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'DMS      -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_DMS_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'DMS      -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-SSP_DMS_other_surface_mol_175001-210101_0.9x1.25_c20190222.nc',
         'num_a1   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_num_so4_a1_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'num_a1   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_num_so4_a1_anthro-ag-ship_surface_mol_175001-210101_0.9x1.25_c20200924.nc',
         'num_a2   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_num_so4_a2_anthro-res_surface_mol_175001-210101_0.9x1.25_c20200924.nc',
         'num_a4   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_num_bc_a4_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'num_a4   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_num_bc_a4_anthro_surface_mol_175001-210101_0.9x1.25_c20190222.nc',
         'num_a4   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_num_pom_a4_anthro_surface_mol_175001-210101_0.9x1.25_c20190222.nc',
         'num_a4   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_num_pom_a4_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'pom_a4   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_pom_a4_anthro_surface_mol_175001-210101_0.9x1.25_c20190222.nc',
         'pom_a4   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_pom_a4_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'SO2      -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_SO2_anthro-ag-ship-res_surface_mol_175001-210101_0.9x1.25_c20200924.nc',
         'SO2      -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_SO2_anthro-ene_surface_mol_175001-210101_0.9x1.25_c20190222.nc',
         'SO2      -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_SO2_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'so4_a1   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_so4_a1_anthro-ag-ship_surface_mol_175001-210101_0.9x1.25_c20200924.nc',
         'so4_a1   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_so4_a1_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'so4_a2   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_so4_a2_anthro-res_surface_mol_175001-210101_0.9x1.25_c20200924.nc',
         'SOAG     -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_SOAGx1.5_anthro_surface_mol_175001-210101_0.9x1.25_c20200403.nc',
         'SOAG     -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_SOAGx1.5_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'SOAG     -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp/emissions-cmip6-SOAGx1.5_biogenic_surface_mol_175001-210101_0.9x1.25_c20190329.nc'
 srf_emis_type          = 'INTERP_MISSING_MONTHS'

 tracer_cnst_datapath           = '/glade/p/cesmdata/cseg/inputdata/atm/cam/tracer_cnst'
 tracer_cnst_file               = 'tracer_cnst_halons_3D_L70_1849-2101_CMIP6ensAvg_SSP3-7.0_c190403.nc'
 tracer_cnst_filelist           = ''
 tracer_cnst_specifier          = 'O3','OH','NO3','HO2'
 tracer_cnst_type               = 'INTERP_MISSING_MONTHS'

&chem_surfvals_nl
 flbc_file              = '/glade/p/cesmdata/cseg/inputdata/atm/waccm/lb/LBC_1750-2500_CMIP6_SSP370_0p5degLat_GlobAnnAvg_c20201210.nc'
 flbc_list              = 'CO2','CH4','N2O','CFC11eq','CFC12'
 flbc_type              = 'SERIAL'
 scenario_ghg           = 'CHEM_LBC_FILE'
/
&prescribed_ozone_nl
 prescribed_ozone_datapath              = '/glade/p/cesmdata/cseg/inputdata/atm/cam/ozone_strataero'
 prescribed_ozone_file          = 'ozone_strataero_WACCM_L70_zm5day_18500101-21010201_CMIP6histEnsAvg_SSP370_c190403.nc'
 prescribed_ozone_name          = 'O3'
 prescribed_ozone_type          = 'SERIAL'
/
&prescribed_strataero_nl
 prescribed_strataero_datapath          = '/glade/p/cesmdata/cseg/inputdata/atm/cam/ozone_strataero'
 prescribed_strataero_file              = 'ozone_strataero_WACCM_L70_zm5day_18500101-21010201_CMIP6histEnsAvg_SSP370_c190403.nc'
 prescribed_strataero_type              = 'SERIAL'
 prescribed_strataero_use_chemtrop              =  .true.
/




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
