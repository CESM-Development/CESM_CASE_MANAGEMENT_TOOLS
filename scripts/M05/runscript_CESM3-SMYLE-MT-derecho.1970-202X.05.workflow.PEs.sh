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
#tagdir='/glade/work/gmarques/cesm.sandboxes/cesm3_0_alpha09a/'
caseroot='/glade/work/nanr/CESM3-SMYLE/cases/'
EXEFILE='/glade/derecho/scratch/$USER/CESM3-SMYLE/EXEROOTHALF/bld/cesm.exe'

for useyear in $(seq 1972 1972)
do
usemonth=05

#main_case_root='b.e30_'$usetag'.'$compset'.'$resoln'.'${useyear}'-'${usemonth}'.001'
main_case_root=b.e30_${cesmtag:(-8)}.${compset}_SMYLE.${useresoln}.${useyear}-${usemonth}.001

REFCASE=b.e30.SMYLE_IC.ne30np4_L93_t233_wgx3.${useyear}-${usemonth}.01
REFPERT=b.e30.SMYLE_IC.pert.ne30np4_L93_t233_wgx3
REFROOT=/glade/campaign/cesm/development/espwg/CESM3-SMYLE/inputdata/cesm3_init/${REFCASE}/${useyear}-${usemonth}-01/
PERTROOT=/glade/campaign/cesm/development/espwg/CESM3-SMYLE/inputdata/cesm3_init/${REFCASE}/
EXEROOT=/glade/derecho/scratch/$USER/CESM3-SMYLE/EXEROOTHALF/bld/

for mbr in $(seq -f "%03g" 1 1)
do

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

## Create new case (use a special compset for ww)
./create_newcase \
  --compset HISTC_CAM70%MT_CLM60%BGC-CROP_CICE_MOM6_MOSART_DGLC%NOEVOLVE_WW3_SESP \
  --res $resolution --case $casedir --run-unsupported

cd $casedir

echo "creating $runname"

########################
## Set atm output frequency
########################
do_hr3=true
do_hr6=true
do_dy=true

## copy ICs from Cecile's directory (TEMPORARY)
do_ics=false

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
do_case_setup=true
do_case_build=true
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
## Create new case
########################
if [[ $do_create_newcase != true ]]; then
     echo $'\n----- Skipping create_newcase -----\n'
else
    path=${CASEROOT}
    if [ -d "${path}" ]; then
        echo "ERROR: CASE Directory already exists. Not overwriting"
        exit 20
    fi
    ${CODE_ROOT}/${cesmtag}/cime/scripts/create_newcase \
        --case ${CASEROOT}  \
        --compset ${compset} \
	--res ${resolution} \
        --run-unsupported  \
	--project ${project} 
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
fincl2 = 'PSL','U500','V500','T500','U010','TS'

!! daily single level (h1)
!fincl2 =
        !'ACTNI','ACTNL','ACTREI','ACTREL','AODVIS','BURDENBCdn','BURDENDUSTdn','BURDENPOMdn','BURDENSEASALTdn','BURDENSO4','BURDENSO4dn','BURDENSOAdn',
        !'CAPE','CDNUMC','CLDTOT','FCTI','FCTL','FLDS','FLDSC','FLNR','FLNS','FLNSC','FLNT','FLNTC','FLUT','FLUTC','FSDS','FSDSC','FSNR','FSNS','FSNSC',
        !'FSNT','FSNTOAC','LHFLX','LWCF','MSKtem','PBLH','PHIS','PRECC','PRECL','PRECSC','PRECSL','PRECT','PRECTMX','PS','PSL','QREFHT','RHREFHT','SHFLX',
        !'SOLIN','SOLLD','SOLSD','SWCF','TAUBLJX','TAUBLJY','TAUGWX','TAUGWY','TAUX','TAUY','TGCLDIWP','TGCLDLWP','TMQ','TREFHT','TREFHTMN','TREFHTMX',
        !'TS','TSMN','TSMX','U10','WSPDSRFAV','WSPDSRFMX','OMEGA1000','OMEGA850','OMEGA700','OMEGA500','OMEGA200','OMEGA100','OMEGA050','OMEGA010',
        !'Q1000','Q850','Q700','Q500','Q200','Q100','Q050','Q010','T1000','T850','T700','T500','T200','T100','T050','T010',
        !'U1000','U850','U700','U500','U200','U100','U050','U010','V1000','V850','V700','V500','V200','V100','V050','V010',
        !'Z1000','Z850','Z700','Z500','Z200','Z100','Z050','Z010','MSKtem','VTHzm','UVzm','UWzm','Uzm','Vzm','THzm','Wzm'
!
!!! 6hr (h2)
!fincl3 =
        !'Q950:I','Q900:I','Q850:I','Q700:I','Q500:I','Q200:I','T950:I','T900:I','T850:I','T700:I','T500:I','T200:I',
        !'U950:I','U900:I','U850:I','U700:I','U500:I','U200:I','V950:I','V900:I','V850:I','V700:I','V500:I','V200:I',
        !'FLUT:A','OMEGA500:A','PRECC:A','PRECSC:A','PRECSL:A','PRECT:A','PSL:I','U200:A',
        !'UBOT:I','VBOT:I','Z300:I','Z500:I','TMQ:I','uIVT:I','vIVT:I'
!
!!! 3hr (h3)
!fincl4 =
        !'CLDLOW:A','PRECC:A','UBOT:A','VBOT:A','PRECT:A'

srf_emis_specifier = 'bc_a4 -> /glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_bc_a4_anthro_surface_175001-201412_ne30pg3_c20191118.nc',
         'bc_a4    -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_bc_a4_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'num_a1   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_num_so4_a1_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'num_a1 -> /glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_num_so4_a1_anthro-ag-ship_surface_mol_175001-201412_ne30pg3_c20200103.nc',
         'num_a2 -> /glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_num_so4_a2_anthro-res_surface_mol_175001-201412_ne30pg3_c20200103.nc',
         'num_a4   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_num_bc_a4_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'num_a4 -> /glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_num_bc_a4_anthro_surface_175001-201412_ne30pg3_c20191118.nc',
         'num_a4 -> /glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_num_pom_a4_anthro_surface_175001-201412_ne30pg3_c20191118.nc',
         'num_a4   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_num_pom_a4_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'pom_a4 -> /glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_pom_a4_anthro_surface_175001-201412_ne30pg3_c20191118.nc',
         'pom_a4   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_pom_a4_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'DMS      -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370/emissions-cmip6-SSP_DMS_other_surface_mol_175001-210101_0.9x1.25_c20190222.nc',
         'DMS      -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_DMS_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'SO2 -> /glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_SO2_anthro-ag-ship-res_surface_mol_175001-201412_ne30pg3_c20200103.nc',
         'SO2 -> /glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_SO2_anthro-ene_surface_mol_175001-201412_ne30pg3_c20200103.nc',
         'SO2      -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_SO2_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'so4_a1 -> /glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_so4_a1_anthro-ag-ship_surface_mol_175001-201412_ne30pg3_c20200103.nc',
         'so4_a1   -> /glade/p/cesmdata/cseg/inputdata/atm/cam/chem/emis/emissions_ssp370-BB_smoothed/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_smoothed_so4_a1_bb_surface_mol_175001-210101_0.9x1.25_c20201016.nc',
         'so4_a2 -> /glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_so4_a2_anthro-res_surface_mol_175001-201412_ne30pg3_c20200103.nc',
         'SOAE -> 2.5592D0*/glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_BENZENE_anthro_surface_175001-201412_ne30pg3_c20191118.nc',
         'SOAE -> 2.5592D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_BENZENE_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc',
         'SOAE -> 0.5954D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_ISOP_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc',
         'SOAE -> 8.5371D0*/glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_IVOC_anthro_surface_175001-201412_ne30pg3_c20200103.nc',
         'SOAE -> 8.5371D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_IVOC_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc',
         'SOAE -> 5.1004D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE//emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_MTERP_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc',
         'SOAE -> 16.650D0*/glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_SVOC_anthro_surface_175001-201412_ne30pg3_c20200103.nc',
         'SOAE -> 16.650D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_SVOC_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc',
         'SOAE -> 8.2367D0*/glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_TOLUENE_anthro_surface_175001-201412_ne30pg3_c20191118.nc',
         'SOAE -> 8.2367D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE//emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_TOLUENE_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc',
         'SOAE -> 6.5013D0*/glade/campaign/cesm/cesmdata/inputdata/atm/cam/chem/emis/historical_ne30pg3/emissions-cmip6_XYLENES_anthro_surface_175001-201412_ne30pg3_c20191118.nc',
         'SOAE -> 6.5013D0*/glade/work/nanr/SMBB/SSP370_smoothed_BB-SOAE/emissions-cmip6-ScenarioMIP_IAMC-AIM-ssp370-1-1_XYLENES_smoothed_bb_surface_mol_175001-210101_0.9x1.25_c20190222-c250203.nc'

srf_emis_type = 'INTERP_MISSING_MONTHS'


EOF

########################
## user_nl_clm
########################

cp user_nl_clm user_nl_clm-OTB
cp $TOOLSROOT/user_nl_files/r1/user_nl_clm-ctsm5.3.0 ${CASEROOT}/user_nl_clm


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
#cp /glade/campaign/cesm/cesmdata/cseg/runs/cesm2_0/b.e30_alpha09a.B1850C_MTso.ne30_t233_wgx3.348/env_mach_pes.xml ${CASEROOT}
cp /glade/work/nanr/cesm_tags/CASE_tools/cesm3-smyle/env_mach_pes.xml-half ${CASEROOT}/env_mach_pes.xml

./case.setup --reset

./xmlchange JOB_WALLCLOCK_TIME=12:00:00 --subgroup case.run
./xmlchange RUN_TYPE=hybrid
./xmlchange GET_REFCASE=false
./xmlchange RUN_REFCASE=b.e30.SMYLE_IC.ne30np4_L93_t233_wgx3.${useyear}-${usemonth}.01
./xmlchange RUN_REFDATE=${useyear}-${usemonth}-01
./xmlchange RUN_STARTDATE=${useyear}-${usemonth}-01
./xmlchange DOUT_S_ROOT=/glade/derecho/scratch/nanr/CESM3-SMYLE/archive/$runname/
./xmlchange RUNDIR=$RUNDIR
./xmlchange CIME_OUTPUT_ROOT=/glade/derecho/scratch/nanr/CESM3-SMYLE/
#./xmlchange JOB_PRIORITY=premium
./xmlchange RESUBMIT=${resubmit},STOP_N=${stop_n},STOP_OPTION=${stop_option}
./xmlchange REST_OPTION=nyears,REST_N=${stop_n}

./xmlchange EXEROOT='/glade/derecho/scratch/nanr/CESM3-SMYLE/EXEROOTHALF/bld'
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

echo " Add cam.i.perturbation Restarts -------------"
   if [[ $mbr > 1 ]]; then
        set ifile = ${REFCASE}.cam.i.${useyear}-${usemonth}-01-00000.nc
        set ofile = ${REFCASE}.cam.i.${useyear}-${usemonth}-01-00000-original.nc
        mv $RUNDIR/$ifile $RUNDIR/$ofile
        if [[ $mbr < 10 ]]; then
                ln -s ${PERTROOT}/pert.0${mbr}/${REFPERT}.cam.i* $RUNDIR/$ifile
                echo ${PERTROOT}/pert.0${mbr}/${REFPERT}.cam.i* $RUNDIR/$ifile
        else
                ln -s ${PERTROOT}/pert.${mbr}/${REFPERT}.cam.i* $RUNDIR/$ifile
                echo ${PERTROOT}/pert.${mbr}/${REFPERT}.cam.i* $RUNDIR/$ifile
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
