#!/bin/bash

for useyear in $(seq 2013 2013)
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

echo $rundir

#============= START =======

cd $casedir

## Namelist settings
mv user_nl_cam user_nl_cam-2013-11_2014-12-01
cat <<EOF > user_nl_cam

solar_irrad_data_file = '/glade/campaign/cesm/development/cross-wg/inputdata/SolarForcingCMIP7piControl_c20250103.nc'
micro_mg_dcs = 600.D-6
clubb_c8 = 4.6
cldfrc_dp1 = 0.05
bnd_topo = '/glade/campaign/cgd/amp/pel/topo/cesm3/ne30pg3_gmted2010_modis_bedmachine_nc3000_Laplace0050_noleak_20250325.nc'

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
 tracer_cnst_specifier          = 'O3','OH','NO3','HO2','HALONS'
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

&upper_bc_file_opts
 ubc_file_cycle_yr              = 2014
 ubc_file_input_type            = 'CYCLICAL'
 ubc_file_path          = '/glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/ubc/b.e21.BWHIST.f09_g17.CMIP6-historical-WACCM.ensAvg123.cam.h0zm.H2O.1849-2014_c240604.nc'
/


EOF

./xmlchange CONTINUE_RUN=TRUE
./xmlchange STOP_N=11
./xmlchange REST_N=11

./case.submit

done
done
