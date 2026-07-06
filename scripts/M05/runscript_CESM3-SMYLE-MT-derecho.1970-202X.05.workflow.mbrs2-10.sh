#!/bin/bash

# ======================================================
# CMIP7 LTso TEMPLATE SCRIPT
# Modify indicated sections
# ====================================================== 

TOOLSROOT=/glade/work/nanr/cesm_tags/CASE_tools/cesm3-smyle/


########################
##  Case details
########################
cesmtag=cesm3_0_alpha09a
project=CESM0024
compset=BHISTC_MTso
resolution=ne30pg3_t233_wg37
useresoln=ne30_t233_wgx3



git_repo=git@github.com:NCAR/cesm_dev.git

tagdir='/glade/derecho/scratch/nanr/cesm_tags/cesm3_0_'.${usetag}.'/'
caseroot='/glade/work/nanr/CESM3-SMYLE/cases/'
EXEFILE='/glade/derecho/scratch/$USER/CESM3-SMYLE/EXEROOTBIG/bld/cesm.exe'

# 1980, 1982, 1988, 1997, 1999, 2007, 2015.   That's 3 big El Ninos, 3 big La Ninas, and 1 neutral year.

for useyear in $(seq 1998 1998)
do
usemonth=05

#main_case_root='b.e30_'$usetag'.'$compset'.'$resoln'.'${useyear}'-'${usemonth}'.001'
main_case_root=b.e30_${cesmtag:(-8)}.${compset}_SMYLE.${useresoln}.${useyear}-${usemonth}.001

REFCASE=b.e30.SMYLE_IC.ne30np4_L93_t233_wgx3.${useyear}-${usemonth}.01
REFPERT=b.e30.SMYLE_IC.pert.ne30np4_L93_t233_wgx3
REFROOT=/glade/campaign/cesm/development/espwg/CESM3-SMYLE/inputdata/cesm3_init/${REFCASE}/${useyear}-${usemonth}-01/
PERTROOT=/glade/campaign/cesm/development/espwg/CESM3-SMYLE/inputdata/cesm3_init/${REFCASE}/
EXEROOT=/glade/derecho/scratch/$USER/CESM3-SMYLE/EXEROOTBIG/bld/

#for mbr in $(seq -f "%03g" 3 3)
for imbr in $(seq 2 5)
do

mbr=$(printf "%03d" "$imbr")
echo "setting up member ${mbr}"

runname=b.e30_${cesmtag:(-8)}.${compset}_SMYLE.${useresoln}.${useyear}-${usemonth}.$mbr
casedir=$caseroot/$runname
rundir=/glade/derecho/scratch/nanr/CESM3-SMYLE/${main_case_root}/run.${mbr}/

echo $rundir


#============= START =======

#cd $tagdir/cime/scripts
#CODE_ROOT='/glade/work/gmarques/cesm.sandboxes/'
CODE_ROOT='/glade/derecho/scratch/nanr/cesm_tags/'
cd $CODE_ROOT/${cesmtag}/cime/scripts

path=${casedir}
if [ -d "${path}" ]; then
    echo "ERROR: CASE Directory already exists. Not overwriting"
    #exit 20
    exit 
fi

echo "creating $runname"
./create_newcase \
      --compset HISTC_CAM70%MT_CLM60%BGC-CROP_CICE_MOM6_MOSART_DGLC%NOEVOLVE_WW3_SESP \
      --res $resolution --case $casedir --run-unsupported

cd $casedir


########################
## Set atm output frequency
########################
do_hr3=true
do_hr6=true
do_dy=true

########################
## Set ice output format (CMOR ready)
########################
do_cice_cmip7=false

########################
## Set run instructions
########################
stop_n=24
rest_n=24
stop_option=nmonths
rest_option=nmonths
resubmit=0

########################
## Set flags to do stuff ----
########################
do_git_archive=false
do_download_code=false
do_create_newcase=false
do_big_pes=true
do_case_setup=true
do_case_build=false
do_case_submit=true
do_tseries=false
do_cupid=false
do_cmor=false
casedir=/glade/work/nanr/CESM3-SMYLE/cases/
#CODE_ROOT=$SCRATCH/cesm_tags/
CODE_ROOT='/glade/work/gmarques/cesm.sandboxes/'
CASEROOT=$casedir/$runname
#CASEROOT=$caseroot/$runname
RUNDIR=/glade/derecho/scratch/nanr/CESM3-SMYLE/${main_case_root}/run.${mbr}/

########################
## Clone the repository
########################
path=${CODE_ROOT}/${cesmtag}

if [[ $do_download_code != true || -d "${path}" ]]; then
     echo $'\n----- Skipping code download -----\n'
else
     mkdir -p ${CODE_ROOT}
     echo $'\n----- Downloading CESMROOT -----\n'

     cd ${CODE_ROOT}

     # clone the repo and get the cesm tag
     git clone https://github.com/ESCOMP/cesm $cesmtag -b $cesmtag
     cd $cesmtag

     # check out the components
     ./bin/git-fleximod update

     ### START ----- Remove when we are in production
     ###############################################
     ## Update the ccs_config to the workflow branch
     ###############################################
     cd ccs_config
     git checkout add_cmip7_workflow_amon_basic
     ### END ----- Remove when we are in production

fi

########################
## copy script to CASEROOT directory
########################
SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
SCRIPT_NAME="$(basename "$SCRIPT_PATH")"

#mkdir -p "${CASEROOT}/provenance_script"
#cp "$SCRIPT_PATH" "${CASEROOT}/provenance_script/$SCRIPT_NAME"


########################
## Set up 
########################
echo "======="
echo $CASEROOT
echo "======="
cd ${CASEROOT}
./case.setup
./xmlchange RUNDIR=$RUNDIR

########################
## namelists
########################
 
########################
## user_nl_cam
########################

cat <<EOF > user_nl_cam

!!      h0,  h1, h2, h3,  h4,  h5,  h6,  h7,  h8
nhtfrq = 0, -24, -6, -3,  -1,   1, -24,-120,-240
mfilt  = 1,   5, 20, 40, 120, 240, 365,  73, 365
ndens  = 2,   2,  2,  2,   2,   2,   1,   1,   1

!! monthly (h0)
fincl1 =
        'ADRAIN','ADSNOW','ANRAIN','ANSNOW','AQRAIN','AQSNOW','AREI','AREL','AWNC','AWNI','CCN3','CLDICE','CLDLIQ',
        'CLOUD','CME','CO2','CONCLD','DCQ','DTCOND','DTCORE','DTV','EVAPPREC','EVAPQZM',
        'EVAPTZM','FICE','FREQI','FREQL','FREQR','FREQS','H2O','ICIMR','ICWMR','IWC','MASS','NUMICE','NUMLIQ','NUMRAI',
        'NUMSNO','OMEGA','OMEGAT','PDELDRY','PTEQ','PTTEND','Q','QRAIN','QRL','QRS','QSNOW','RAINQM','REFF_AERO',
        'RELHUM','RELVAR','SNOWQM','STEND_CLUBB','T','TAQ','TOT_CLD_VISTAU','TTEND_TOT','TTGWORO','U','UTEND_CLUBB',
        'UTGWORO','UU','V','VD01','VQ','VT','VTEND_CLUBB','VU','VV','WSUB','Z3','ZM_CLUBB','ZMDQ','ZMDT','ZMMTT','ZMMU',
        'ACTREL','AEROD_v','AODABSdn','AODBCdn',
        'AODDUST','AODNIRstdn','AODPOMdn','AODSO4dn','AODSOAdn','AODSSdn','AODUVdn','AODUVstdn',
        'AODVIS','AODVISdn','AODVISstdn','AREA','bc_a1_SRF','bc_a4_SRF','BURDENBCdn','BURDENDUSTdn','BURDENPOMdn','BURDENSEASALTdn',
        'BURDENSO4dn','BURDENSOAdn','CAPE','CDNUMC','CLDHGH','CLDLOW','CLDMED','CLDTOT','dst_a1_SRF','dst_a2_SRF','dst_a3_SRF',
        'FCTL','FLDS','FLDSC','FLNR','FLNS','FLNSC','FLNT','FLNTC','FLUT','FLUTC','FREQZM','FSDS','FSDSC','FSNR','FSNS','FSNSC',
        'FSNT','FSNTC','FSNTOA','FSNTOAC','FSUTOA','ICEFRAC','LANDFRAC','LHFLX','LWCF','ncl_a1_SRF','ncl_a2_SRF','ncl_a3_SRF',
        'num_a1_SRF','num_a2_SRF','num_a3_SRF','num_a4_SRF','OCNFRAC','PBLH','PHIS','pom_a1_SRF','pom_a4_SRF','PRECC','PRECL','PRECSC',
        'PRECSL','PRECT','PS','PSL','QFLX','QREFHT','RHREFHT','SHFLX','SNOWHICE','SNOWHLND',
        'SO2_SRF','so4_a1_SRF','so4_a2_SRF','so4_a3_SRF','soa_a1_SRF','soa_a2_SRF','SOAG_SRF','SOLIN','SOLLD','SOLSD','SSAVIS','SWCF',
        'TAUBLJX','TAUBLJY','TAUGWX','TAUGWY','TAUX','TAUY','TGCLDCWP','TGCLDIWP','TGCLDLWP','TMCO2',
        'TMQ','TREFHT','TREFHTMN','TREFHTMX','TROP_P','TROP_T','TROP_Z','TS','TSMN','TSMX','U10','WSPDSRFAV','WSPDSRFMX'


!! daily single level (h1)
!fincl2 = 'PSL','U500','V500','T500','U010','TS'

!! daily single level (h1)
fincl2 =
        'ACTNI','ACTNL','ACTREI','ACTREL','AODVIS','BURDENBCdn','BURDENDUSTdn','BURDENPOMdn','BURDENSEASALTdn','BURDENSO4','BURDENSO4dn','BURDENSOAdn',
        'CAPE','CDNUMC','CLDTOT','FCTI','FCTL','FLDS','FLDSC','FLNR','FLNS','FLNSC','FLNT','FLNTC','FLUT','FLUTC','FSDS','FSDSC','FSNR','FSNS','FSNSC',
        'FSNT','FSNTOAC','LHFLX','LWCF','PBLH','PHIS','PRECC','PRECL','PRECSC','PRECSL','PRECT','PRECTMX','PS','PSL','QREFHT','RHREFHT','SHFLX',
        'SOLIN','SOLLD','SOLSD','SWCF','TAUBLJX','TAUBLJY','TAUGWX','TAUGWY','TAUX','TAUY','TGCLDIWP','TGCLDLWP','TMQ','TREFHT','TREFHTMN','TREFHTMX',
        'TS','TSMN','TSMX','U10','WSPDSRFAV','WSPDSRFMX','OMEGA850','OMEGA500',
        'Q1000','Q850','Q200','T1000','T850','T700','T500','T200','T010',
        'U850','U500','U200','U010','V850','V500','V200',
        'Z1000','Z700','Z500','Z200','Z100','Z050'
!
!!! 6hr (h2)
fincl3 =
        'Q850:I','Q200:I','T850:I','T700:I','T500:I','T200:I',
        'U850:I','U500:I','U200:I','V850:I','V500:I','V200:I',
        'FLUT:A','OMEGA500:A','PRECC:A','PRECSC:A','PRECSL:A','PRECT:A','PSL:I',
        'UBOT:I','VBOT:I','Z300:I','Z500:I','TMQ:I','uIVT:I','vIVT:I'
!
!!! 3hr (h3)
fincl4 =
        'CLDLOW:A','PRECC:A','UBOT:A','VBOT:A','PRECT:A'


!! Isla: adding in-line interpolation of the atmospheric output
interpolate_output = .true., .true., .true.
interpolate_nlat = 192, 192, 192
interpolate_nlon = 288, 288, 288

 ext_frc_specifier              = 'H2O    -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/elev/H2OemissionCH4oxidationx2_3D_L70_1849-2101_CMIP6ensAvg_SSP3-7.0_c190403.nc',
         'num_a1 -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_num_so4_a1_anthro-ene_vertical_mol_175001-210101_0.9x1.25_c20190222.nc',
         'num_a1 -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_num_a1_so4_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc',
         'num_a2 -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_num_a2_so4_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc',
         'SO2    -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_SO2_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc',
         'so4_a1 -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_so4_a1_anthro-ene_vertical_mol_175001-210101_0.9x1.25_c20190222.nc',
         'so4_a1 -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_so4_a1_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc',
         'so4_a2 -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/CMIP6_emissions_1750_2015/emissions-cmip6_so4_a2_contvolcano_vertical_850-5000_0.9x1.25_c20170724.nc'
 ext_frc_type           = 'INTERP_MISSING_MONTHS'


 srf_emis_specifier       = 'bc_a4    -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_bc_a4_anthro_surface_mol_175001-210101_0.9x1.25_c20190222.nc',
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
         'SOAE  -> 2.5592D0*/glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_BENZENE_anthro_surface_mol_175001-210101_0.9x1.25_c20190222.nc',
         'SOAE -> 2.5592D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_BENZENE_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc',
         'SOAE -> 0.5954D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_ISOP_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc',
         'SOAE -> 8.5371D0*/glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_IVOC_anthro_surface_mol_175001-210101_0.9x1.25_c20190222.nc',
         'SOAE -> 8.5371D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_IVOC_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc',
         'SOAE -> 5.1004D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE//emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_MTERP_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc',
	 'SOAE -> 16.650D0*/glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_SVOC_anthro_surface_mol_175001-210101_0.9x1.25_c20190222.nc',
         'SOAE -> 16.650D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_SVOC_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc',
         'SOAE -> 8.2367D0*/glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_TOLUENE_anthro_surface_mol_175001-210101_0.9x1.25_c20190222.nc', 
	 'SOAE -> 8.2367D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_TOLUENE_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc',
	 'SOAE -> 6.5013D0*/glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_XYLENES_anthro_surface_mol_175001-210101_0.9x1.25_c20190222.nc',
         'SOAE -> 6.5013D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_XYLENES_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc'
srf_emis_type = 'INTERP_MISSING_MONTHS'

 tracer_cnst_datapath           = '/glade/campaign/cesm/cesmdata/inputdata/atm/cam/tracer_cnst'
 tracer_cnst_file               = 'tracer_cnst_halons_3D_L70_1849-2101_CMIP6ensAvg_SSP3-7.0_c190403.nc'
 tracer_cnst_filelist           = ''
 tracer_cnst_specifier          = 'O3','OH','NO3','HO2','HALONS'
 tracer_cnst_type               = 'INTERP_MISSING_MONTHS'


 xs_long_file           = '/glade/campaign/cesm/cesmdata/inputdata/atm/waccm/phot/temp_prs_GT200nm_c221005mm.nc'

&chem_surfvals_nl
 flbc_file              = '/glade/p/cesmdata/cseg/inputdata/atm/waccm/lb/LBC_1750-2500_CMIP6_SSP370_0p5degLat_GlobAnnAvg_c20201210.nc'
 flbc_list              = 'CO2','CH4','N2O','CFC11eq','CFC12'
 flbc_type              = 'SERIAL'
 scenario_ghg           = 'CHEM_LBC_FILE'
/


&ndep_stream_nl
 stream_ndep_data_filename      = '/glade/campaign/cesm/cesmdata/inputdata/lnd/clm2/ndepdata/fndep_clm_SSP370_b.e21.BWSSP370cmip6.f09_g17.CMIP6-SSP3-7.0-WACCM.002_1849-2101_monthly_0.9x1.25_c211216.nc',
 stream_ndep_mesh_filename      = '/glade/campaign/cesm/cesmdata/inputdata/share/meshes/fv0.9x1.25_141008_polemod_ESMFmesh.nc'
 stream_ndep_year_align         = 1850
 stream_ndep_year_first         = 1850
 stream_ndep_year_last          = 2101
/

&prescribed_ozone_nl
 prescribed_ozone_datapath      = '/glade/p/cesmdata/cseg/inputdata/atm/cam/ozone_strataero'
 prescribed_ozone_file          = 'ozone_strataero_WACCM_L70_zm5day_18500101-21010201_CMIP6histEnsAvg_SSP370_c190403.nc'
 prescribed_ozone_name          = 'O3'
 prescribed_ozone_type          = 'SERIAL'
/
&prescribed_strataero_nl
 prescribed_strataero_datapath  = '/glade/p/cesmdata/cseg/inputdata/atm/cam/ozone_strataero'
 prescribed_strataero_file      = 'ozone_strataero_WACCM_L70_zm5day_18500101-21010201_CMIP6histEnsAvg_SSP370_c190403.nc'
 prescribed_strataero_type      = 'SERIAL'
 prescribed_strataero_use_chemtrop              =  .true.
/





!! Turn off interactive DMS ocean emissions:
!! Simone: in CESM3 we use the online ocean DMS emissions. To revert those back to CMIP6 emissions, 
!! turn off DMS online emissions and add the DMS ocean / other emissions back in

&ocean_emis_nl
 bubble_mediated_transfer               = .false.
 csw_specifier          = 'NONE'
 csw_time_type          = 'SERIAL'
 ocean_salinity_file            = 'NONE'
/

EOF

########################
## user_nl_clm
## FAILES USING SMYLE-like flanduse_timeseries = '/glade/campaign/cesm/cesmdata/inputdata/lnd/clm2/surfdata_esmf/ctsm5.3.0/landuse.timeseries_ne30np4.pg3_SSP2-4.5_1850-2100_78pfts_c240908.nc'
########################

mv user_nl_clm user_nl_clm-OTB
cp $TOOLSROOT/user_nl_files/r1/user_nl_clm-ctsm5.3.0 ${CASEROOT}/user_nl_clm

########################
## For reference 
## CMIP7 forcing
## flanduse_timeseries = '/glade/campaign/cesm/cesmdata/inputdata/lnd/clm2/surfdata_esmf/ctsm5.4.0/landuse.timeseries_ne30np4.pg3_hist_1850-2023_78pfts_c251022.nc'
##

########################
## user_nl_cpl
########################

cat <<EOF> user_nl_cpl
histaux_l2x1yrg = .true.
EOF


########################
## user_nl_cice
########################
# start with the
if [[ $do_cice_cmip7 == true ]]; then
  cp /glade/work/dbailey/cesm3_0_alpha08o/components/cice/cime_config/usermods_dirs/cmip7/user_nl_cice ${CASEROOT}/
fi


########################
## user_nl_cice
########################

cat <<EOF>> user_nl_cice

r_snw = 0.75
restart_fsd = .true.
histfreq = "m", "x", "x", "x", "x"
EOF

########################
## user_nl_mom
########################

cat <<EOF> user_nl_mom
EOF

cd $CASEROOT
./preview_namelists

########################
## add to github repo
########################

if [[ $do_git_archive == true ]]; then
    cd ${CASEROOT}  
    cp $curdir
    ./xmlchange CASE_GIT_REPOSITORY=$git_repo

fi

########################
## build and submit
########################

cd ${CASEROOT}

########################
## use bigger PE layout
########################
if [[ $do_big_pes == true ]]; then
     cp /glade/campaign/cesm/cesmdata/cseg/runs/cesm2_0/b.e30_alpha09a.B1850C_MTso.ne30_t233_wgx3.348/env_mach_pes.xml ${CASEROOT}
     ./case.setup --reset
fi

./xmlchange JOB_WALLCLOCK_TIME=06:00:00 --subgroup case.run
./xmlchange RUN_TYPE=hybrid
./xmlchange GET_REFCASE=false
./xmlchange RUN_REFCASE=b.e30.SMYLE_IC.ne30np4_L93_t233_wgx3.${useyear}-${usemonth}.01
./xmlchange RUN_REFDATE=${useyear}-${usemonth}-01
./xmlchange RUN_STARTDATE=${useyear}-${usemonth}-01
./xmlchange DOUT_S_ROOT=/glade/derecho/scratch/nanr/CESM3-SMYLE/archive/$runname/
./xmlchange RUNDIR=$RUNDIR
./xmlchange CIME_OUTPUT_ROOT=/glade/derecho/scratch/nanr/CESM3-SMYLE/
#./xmlchange JOB_PRIORITY=premium
./xmlchange PROJECT=CESM0020
./xmlchange RESUBMIT=${resubmit},STOP_N=${stop_n},STOP_OPTION=${stop_option}
./xmlchange REST_OPTION=nyears,REST_N=${stop_n}

./xmlchange EXEROOT='/glade/derecho/scratch/nanr/CESM3-SMYLE/EXEROOTBIG/bld'
./xmlchange BUILD_COMPLETE=TRUE

# from https://github.com/NCAR/cesm_dev/issues/342
cp /glade/campaign/cesm/cesmdata/cseg/runs/cesm2_0/b.e30_alpha08o.B1850C_MTso.ne30_t232_wgx3.345/SourceMods/src.cam/* $CASEROOT/SourceMods/src.cam/


echo " Copy Restarts -------------"
if [[ ! -d $RUNDIR ]]; then
        echo 'mkdir ' $RUNDIR
        mkdir -p $RUNDIR
fi

   cp    ${REFROOT}/rpointer* $RUNDIR/
   ln -s ${REFROOT}/b.e30*    $RUNDIR/

echo " End restarts copy -----------"

echo " Add cam.i.perturbation Restarts ------------- for mbr=$mbr"
   if [[ $imbr -gt 1 ]]; then
        ifile=${REFCASE}.cam.i.${useyear}-${usemonth}-01-00000.nc
        ofile=${REFCASE}.cam.i.${useyear}-${usemonth}-01-00000-original.nc
        mv $RUNDIR/$ifile $RUNDIR/$ofile
        if [[ $imbr -lt 10 ]]; then
                ln -s ${PERTROOT}/pert.0${imbr}/${REFPERT}.cam.i* $RUNDIR/$ifile
                echo ${PERTROOT}/pert.0${imbr}/${REFPERT}.cam.i* $RUNDIR/$ifile
        else
                ln -s ${PERTROOT}/pert.${imbr}/${REFPERT}.cam.i* $RUNDIR/$ifile
                echo ${PERTROOT}/pert.${imbr}/${REFPERT}.cam.i* $RUNDIR/$ifile
	fi
   fi



if [[ $do_case_build == true ]]; then
   qcmd -A ${project} -- ./case.build
fi

if [[ $do_case_submit == true ]]; then
   ./case.submit
fi


done
done
