#!/bin/bash
###!/bin/bash -fe

# CIME in E3SMv3.1 needs Python >= 3.9 (system python3 is 3.6)
module load cray-python/3.11.7

# E3SM Water Cycle v2 run_e3sm script template.
#
# E3SMv3.1 + CMIP6 version of run.v21.LR.BSMYLEsmbb_CMIP7-05.sh
# (CMIP6 control for run.v31.LR.BSMYLEsmbb_CMIP7-05.sh: identical except the
#  EAM compset modifier is %CMIP6 instead of %CMIP7.)
# Same ensemble design (start date, 20 members, 28 months, hybrid start from
# the v2.1 SMYLE ICs, same output streams), but built with E3SMv3.1 and the
# native WCYCL20TR (CMIP6) compset, so CMIP6 forcing comes from the model's
# 20TR_eam_CMIP6_chemUCI-Linoz-mam5-vbs use case. See README.v31_CMIP6.
#
# Inspired by v1 run_e3sm script as well as SCREAM group simplified run script.
#
# Bash coding style inspired by:
# http://kfirlavi.herokuapp.com/blog/2012/11/14/defensive-bash-programming

#array=( 1 )
#array=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 )
array=( 1 2 3 4 5 6 7 8 9 10 )
for imbr in "${array[@]}"
do

main() {

echo ${imbr}

if [[ ${imbr} -lt "10" ]]
then
  mbr="00${imbr}"
  echo ${mbr}
else
  mbr="0${imbr}"
  echo ${mbr}
fi


# For debugging, uncomment libe below
#set -x

## Rerunning: 1989-2018
useyear=2000
usemonth=05


# --- Configuration flags ----

# Machine and project
MACHINE=pm-cpu
PROJECT="m5463"

# Simulation
#COMPSET="WCYCLSSP370" # SSP370 transient
# v3.1 20th-century transient with CMIP6 forcing (out of the box)
# (= WCYCL20TR, but with satellite-phenology land, ELM%SPBC, as in the
#  v2.1 smbb cases; the v2.1 SMYLE land restart has no BGC carbon/nutrient
#  pools, so the default ELM%CNPRDCTCBCTOP would start from bare land)
COMPSET="20TRSOI_EAM%CMIP6_ELM%SPBC_MPASSI_MPASO_MOSART_SGLC_SWAV"
# Same grid as the v2.1 SMYLE ICs (v3.1 default is ne30pg2_r05_IcoswISC30E3r5)
RESOLUTION="ne30pg2_EC30to60E2r2"
CASE_NAME="v31.LR.BSMYLEsmbb_CMIP6.${useyear}-${usemonth}.${mbr}"
if [[ ${imbr} -eq "1" ]]
then
  #MAIN_CASE_NAME="v21.LR.BSMYLE-MYTEST.${useyear}-${usemonth}.${mbr}"
  MAIN_CASE_NAME="v31.LR.BSMYLEsmbb_CMIP6.${useyear}-${usemonth}.${mbr}"
fi
CASE_GROUP="v31.LR"

# Code and compilation
CHECKOUT="20231020"
BRANCH="maint-3.1" # v3.1.0
CHERRY=( )
DEBUG_COMPILE=false

# Run options
MODEL_START_TYPE="hybrid"  # 'initial', 'continue', 'branch', 'hybrid'
START_DATE="${useyear}-${usemonth}-01"

GET_REFCASE=false
RUN_REFDIR="/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/v21.LR.SMYLE_IC.${useyear}-${usemonth}.01/"
RUN_REFCASE="v21.LR.SMYLE_IC.${useyear}-${usemonth}.01"
RUN_REFDATE="${useyear}-${usemonth}-01"   # same as MODEL_START_DATE for 'branch', can be different for 'hybrid'


# Additional options for 'branch' and 'hybrid'

# Set paths
#MY_PATH="/global/cfs/cdirs/ccsm1/people/nanr"
#CODE_ROOT="${MY_PATH}/e3sm_tags/E3SMv2.1/E3SM/"
MY_PATH="/global/cfs/cdirs/mp9/"
CODE_ROOT="${MY_PATH}/e3sm_tags/E3SMv3.1/"
MAIN_CASE_ROOT="/pscratch/sd/n/${USER}/CMIP-forcing/v31.LR.BSMYLEsmbb_CMIP6/${MAIN_CASE_NAME}"
CASE_ROOT="/pscratch/sd/n/${USER}/CMIP-forcing/v31.LR.BSMYLEsmbb_CMIP6/${MAIN_CASE_NAME}/"

# Sub-directories
#CASE_BUILD_DIR=${MAIN_CASE_ROOT}/build
# Shared build dir for all members (member 001 builds, others reuse e3sm.exe)
CASE_BUILD_DIR=/pscratch/sd/n/${USER}/CMIP-forcing/v31.LR.BSMYLEsmbb_CMIP6/exeroot/build
CASE_ARCHIVE_DIR=${MAIN_CASE_ROOT}/archive.${mbr}
#CASE_ARCHIVE_DIR=/global/cfs/cdirs/mp9/archive/v21.LR.SMYLE/${MAIN_CASE_NAME}/archive.${mbr}

# Define type of run
#  short tests: 'XS_2x5_ndays', 'XS_1x10_ndays', 'S_1x10_ndays', 
#               'M_1x10_ndays', 'M2_1x10_ndays', 'M80_1x10_ndays', 'L_1x10_ndays'
#  or 'production' for full simulation
run='production'
if [ "${run}" != "production" ]; then

  # Short test simulations
  tmp=($(echo $run | tr "_" " "))
  layout=${tmp[0]}
  units=${tmp[2]}
  resubmit=$(( ${tmp[1]%%x*} -1 ))
  length=${tmp[1]##*x}

  CASE_SCRIPTS_DIR=${CASE_ROOT}/tests/${run}/case_scripts.${mbr}
  CASE_RUN_DIR=${CASE_ROOT}/tests/${run}/run.${mbr}
  PELAYOUT=${layout}
  WALLTIME="2:00:00"
  STOP_OPTION=${units}
  STOP_N=${length}
  REST_OPTION=${STOP_OPTION}
  REST_N=${STOP_N}
  RESUBMIT=${resubmit}
  DO_SHORT_TERM_ARCHIVING=false

else

  # Production simulation
  CASE_SCRIPTS_DIR=${MAIN_CASE_ROOT}/case_scripts.${mbr}
  CASE_RUN_DIR=${MAIN_CASE_ROOT}/run.${mbr}
  #PELAYOUT="L"
  WALLTIME="16:00:00"
  STOP_OPTION="nmonths"
  STOP_N="28" # How often to stop the model, should be a multiple of REST_N
  REST_OPTION="nmonths"
  REST_N="28" # How often to write a restart file
  RESUBMIT="0" # Submissions after initial one
  DO_SHORT_TERM_ARCHIVING=true
fi

# Coupler history 
HIST_OPTION="nyears"
HIST_N="5"

# Leave empty (unless you understand what it does)
#OLD_EXECUTABLE=""
# Member 001 builds; other members reuse ${CASE_BUILD_DIR}/e3sm.exe
OLD_EXECUTABLE="/pscratch/sd/n/${USER}/CMIP-forcing/v31.LR.BSMYLEsmbb_CMIP6/exeroot/build/"
#OLD_EXECUTABLE="${MAIN_CASE_ROOT}/build"

# --- Toggle flags for what to do ----
do_fetch_code=false
do_create_newcase=true
do_case_setup=true
if [[ ${imbr} -eq "1" ]]
then
   do_case_build=true
else
   do_case_build=false
fi
do_case_submit=true
do_get_restarts=false

# --- Now, do the work ---

# Make directories created by this script world-readable
umask 022

# Fetch code from Github
fetch_code

# Create case
create_newcase

# Setup
case_setup

# Build
case_build

# Configure runtime options
runtime_options

# Copy script into case_script directory for provenance
copy_script

# Submit
case_submit

# All done
echo $'\n----- All done -----\n'

}

# =======================
# Custom user_nl settings
# =======================

user_nl() {

cat << EOF >> user_nl_eam
 !!                 h0, h1, h2, h3, h4, h5,h6
 nhtfrq          =   0,-24, -6, -6, -3,-24, 0
 mfilt           =   1,365,146,292,292, 73, 1
 avgflag_pertape = 'A','A','I','A','A','A','I'
 ! monthly (h0) A
 ! (v2.1 MPDT/MPDQ removed: MG2-only fields, not defined with v3.1 P3
 !  microphysics; the run aborts with 'FLDLST: MPDT in fincl(11) not found')
 fincl1 = 'extinct_sw_inp','extinct_lw_bnd7','extinct_lw_inp', 'TREFMNAV', 'TREFMXAV','IEFLX','ZMDT','ZMDQ','TTEND_CLUBB', 'RVMTEND_CLUBB', 'DCQ', 'DTCOND'
 ! daily (h1) A
 fincl2 = 'FLUT','PRECT','U200','V200','U850','V850','Z500','OMEGA500','UBOT','VBOT','TREFHT','TREFHTMN:M','TREFHTMX:X','QREFHT','TS','PS','TMQ','TUQ','TVQ','TOZ', 'FLDS','FLNS','FSDS', 'FSNS', 'SHFLX', 'LHFLX', 'TGCLDCWP', 'TGCLDIWP', 'TGCLDLWP', 'CLDTOT', 'T250', 'T200', 'T150', 'T100', 'T050', 'T025', 'T010', 'T005', 'T002', 'T001', 'TTOP', 'U250', 'U150', 'U100', 'U050', 'U025', 'U010', 'U005', 'U002', 'U001', 'UTOP', 'FSNT', 'FLNT','PRECC','PRECTMX:X','PSL','RHREFHT', 'U10', 'Z200', 'QRS', 'QRL', 'Q1000', 'Q850', 'Q700', 'Q500', 'Q200', 'Q100', 'Q050', 'Q010', 'QBOT:A', 'U1000', 'U700', 'U500', 'U200', 'V1000', 'V700', 'V500', 'V100', 'V050', 'V010', 'VBOT', 'T1000', 'T850', 'T700','T500','T010','TBOT','Z1000', 'Z850', 'Z700', 'Z500', 'Z200', 'Z100', 'Z050', 'Z010','TROPF_P','TROPF_T','TROPF_Z'
 ! 6hourly (h2) I
 fincl3 = 'PSL','T200','T500','U850','V850','UBOT','VBOT','TREFHT', 'Z700', 'TBOT:M','FLDS', 'FSDS', 'PRECT', 'PS', 'QREFHT', 'TS','TMQ','U10','Z200:I','Z500:I','TTQ:I','TUQ:I','TVQ:I','Q:I', 'T:I', 'U:I', 'V:I', 'Z3:I'
 ! 6hourly (h3) A
 fincl4 = 'FLUT','U200','U850','PRECT','OMEGA500'
 ! 3hourly (h4) A
 fincl5 = 'PRECT','PRECC','TUQ','TVQ','QFLX','SHFLX','U90M','V90M'
 ! monthly (h6) I
 fincl7 = 'O3', 'PS', 'TROP_P'

 ! CMIP6 forcing from the v3.1 20TR_eam_CMIP6_chemUCI-Linoz-mam5-vbs use
 ! case (solar, GHG, oxidants, Linoz v3, surface emissions), EXCEPT the
 ! elevated emissions below, which use the smoothed biomass-burning (smbb)
 ! files of E3SMv2.1-SMYLE (smbbM05/run.v21.LR.BSMYLEsmbb-05.sh):
 !   bc_a4, num_a1, num_a4, pom_a4, so4_a1 : same v2.1-SMYLE smoothed files
 !   SO2   : v3 smbb version of the v3 default file (keeps the stratvolc
 !           sector; v3 has no prescribed volcanic aerosol)
 !   SOAG0 : v3 smbb version (v3 VBS uses SOAG0, not the v2.1 SOAG)
 !   NO2 (aircraft), num_a2, so4_a2 : v3.1 defaults (no BB sector; num_a2
 !           and so4_a2 were also unsmoothed in v2.1-SMYLE)
 ! ext_frc_specifier replaces the whole default list, so all are listed.
 ext_frc_specifier = 'NO2         -> /global/cfs/cdirs/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/chem_gases/2degrees/emissions-cmip6_NO2_aircraft_vertical_1750-2015_1.9x2.5_c20170608.nc',
         'SO2         -> /global/cfs/cdirs/ccsm1/people/nanr/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/CMIP6_SSP370_ne30-smoothed/cmip6_mam4_so2_elev_1850-2014_c180205_kzm_1850_2014_volcano_smbb_c20260925.nc',
         'SOAG0       -> /global/cfs/cdirs/ccsm1/people/nanr/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/CMIP6_SSP370_ne30-smoothed/emissions-cmip6_e3sm_SOAG0_elev_1850-2014_1.9x2.5_c20230201_smbb_c20260925.nc',
         'bc_a4       -> /global/cfs/cdirs/ccsm1/people/nanr/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/CMIP6_SSP370_ne30-smoothed/cmip6_ssp370_mam4_smoothed_bc_a4_elev_1850-2100_c221016.nc',
         'num_a1      -> /global/cfs/cdirs/ccsm1/people/nanr/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/CMIP6_SSP370_ne30-smoothed/cmip6_ssp370_mam4_smoothed_num_a1_elev_1850-2100_c221016.nc',
         'num_a2      -> /global/cfs/cdirs/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/DECK_ne30/cmip6_mam4_num_a2_elev_1850-2014_c180205.nc',
         'num_a4      -> /global/cfs/cdirs/ccsm1/people/nanr/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/CMIP6_SSP370_ne30-smoothed/cmip6_ssp370_mam4_smoothed_num_a4_elev_1850-2100_c221016.nc',
         'pom_a4      -> /global/cfs/cdirs/ccsm1/people/nanr/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/CMIP6_SSP370_ne30-smoothed/cmip6_ssp370_mam4_smoothed_pom_a4_elev_1850-2100_c221016.nc',
         'so4_a1      -> /global/cfs/cdirs/ccsm1/people/nanr/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/CMIP6_SSP370_ne30-smoothed/cmip6_ssp370_mam4_smoothed_so4_a1_elev_1850-2100_c221016.nc',
         'so4_a2      -> /global/cfs/cdirs/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/DECK_ne30/cmip6_mam4_so4_a2_elev_1850-2014_c180205.nc'
 ext_frc_type      = 'INTERP_MISSING_MONTHS'

EOF

cat << EOF >> user_nl_elm
! Same land surface files as the v2.1 smbb cases and the v3.1 CMIP7 script
! (CMIP6 land use on ne30np4.pg2), so CMIP6 vs CMIP7 runs differ only in
! atmospheric forcing.
! Pointing to new simyr2015 file per Jim Benedict
 fsurdat = '/global/cfs/cdirs/e3sm/inputdata/lnd/clm2/surfdata_map/surfdata_ne30np4.pg2_SSP3_RCP70_simyr2015_c220420.nc'
 flanduse_timeseries = '/global/cfs/cdirs/e3sm/inputdata/lnd/clm2/surfdata_map/landuse.timeseries_ne30np4.pg2_hist_simyr1850-2015_c210113.nc'

 hist_dov2xy = .true.,.true.
 hist_fincl2 = 'H2OSNO', 'FSNO', 'QRUNOFF', 'QSNOMELT', 'FSNO_EFF', 'SNORDSL', 'SNOW', 'FSDS', 'FSR', 'FLDS', 'FIRE', 'FIRA'
 hist_mfilt = 1,365
 hist_nhtfrq = 0,-24
 hist_avgflag_pertape = 'A','A'

! Override - updated after EAM/ELM fixes
 check_finidat_fsurdat_consistency = .false.
 check_finidat_pct_consistency = .true.
 check_finidat_year_consistency = .true.

EOF

cat << EOF >> user_nl_mosart
 rtmhist_fincl2 = 'RIVER_DISCHARGE_OVER_LAND_LIQ'
 rtmhist_mfilt = 1,365
 rtmhist_ndens = 2
 rtmhist_nhtfrq = 0,-24
EOF

}

patch_mpas_streams() {

echo

}

# =====================================
# Customize MPAS stream files if needed
# =====================================

patch_mpas_streams() {

echo

}



######################################################
### Most users won't need to change anything below ###
######################################################

#-----------------------------------------------------
fetch_code() {

    if [ "${do_fetch_code,,}" != "true" ]; then
        echo $'\n----- Skipping fetch_code -----\n'
        return
    fi

    echo $'\n----- Starting fetch_code -----\n'
    local path=${CODE_ROOT}
    local repo=e3sm

    echo "Cloning $repo repository branch $BRANCH under $path"
    if [ -d "${path}" ]; then
        echo "ERROR: Directory already exists. Not overwriting"
        exit 20
    fi
    mkdir -p ${path}
    pushd ${path}

    # This will put repository, with all code
    git clone git@github.com:E3SM-Project/${repo}.git .
    
    # Setup git hooks
    rm -rf .git/hooks
    git clone git@github.com:E3SM-Project/E3SM-Hooks.git .git/hooks
    git config commit.template .git/hooks/commit.template

    # Check out desired branch
    git checkout ${BRANCH}

    # Custom addition
    if [ "${CHERRY}" != "" ]; then
        echo ----- WARNING: adding git cherry-pick -----
        for commit in "${CHERRY[@]}"
        do
            echo ${commit}
            git cherry-pick ${commit}
        done
        echo -------------------------------------------
    fi

    # Bring in all submodule components
    git submodule update --init --recursive

    popd
}

#-----------------------------------------------------
create_newcase() {

    if [ "${do_create_newcase,,}" != "true" ]; then
        echo $'\n----- Skipping create_newcase -----\n'
        return
    fi

    echo $'\n----- Starting create_newcase -----\n'

    ${CODE_ROOT}/cime/scripts/create_newcase \
        --case ${CASE_NAME} \
        --case-group ${CASE_GROUP} \
        --output-root ${CASE_ROOT} \
        --script-root ${CASE_SCRIPTS_DIR} \
        --handle-preexisting-dirs u \
        --compset ${COMPSET} \
        --res ${RESOLUTION} \
        --machine ${MACHINE} \
        --project ${PROJECT} \
        --walltime ${WALLTIME} 

    if [ $? != 0 ]; then
      echo $'\nNote: if create_newcase failed because sub-directory already exists:'
      echo $'  * delete old case_script sub-directory'
      echo $'  * or set do_newcase=false\n'
      exit 35
    fi

}

#-----------------------------------------------------
case_setup() {

    if [ "${do_case_setup,,}" != "true" ]; then
        echo $'\n----- Skipping case_setup -----\n'
        return
    fi

    echo $'\n----- Starting case_setup -----\n'
    pushd ${CASE_SCRIPTS_DIR}

    # Setup some CIME directories
    ./xmlchange EXEROOT=${CASE_BUILD_DIR}
    ./xmlchange RUNDIR=${CASE_RUN_DIR}

    # Short term archiving
    ./xmlchange DOUT_S=${DO_SHORT_TERM_ARCHIVING}
    ./xmlchange DOUT_S_ROOT=${CASE_ARCHIVE_DIR}

    # Build with COSP, except for a data atmosphere (datm)
    #if [ `./xmlquery --value COMP_ATM` == "datm"  ]; then 
      #echo $'\nThe specified configuration uses a data atmosphere, so cannot activate COSP simulator\n'
    #else
      #echo $'\nConfiguring E3SM to use the COSP simulator\n'
      ## ./xmlchange --id CAM_CONFIG_OPTS --append --val='-cosp'
    #fi

    # Extracts input_data_dir in case it is needed for user edits to the namelist later
    local input_data_dir=`./xmlquery DIN_LOC_ROOT --value`

    # Custom user_nl
    user_nl

    # Finally, run CIME case.setup
    ./case.setup --reset

    # Pin cray-libsci for intel (done after setup, because --reset regenerates
    # env_mach_specific.xml). v3.1 pins libsci only for gnu/nvidia/amdclang,
    # so intel picks up the Perlmutter default (26.03.0 since Nov 2026), whose
    # libsci_intel_mpi.so does not link with cray-mpich/9.0.1
    # (undefined MPI_Comm_f2c/MPI_Comm_c2f; MCT configure fails with
    # "linking to Fortran libraries from C fails"). 25.09.0 links fine.
    if ! grep -q 'cray-libsci/25.09.0</command><!-- intel pin' env_mach_specific.xml; then
        sed -i 's#^\( *\)<command name="load">intel/2025.3</command>#&\n\1<command name="load">cray-libsci/25.09.0</command><!-- intel pin -->#' env_mach_specific.xml
    fi
    grep -n -A1 'intel/2025.3' env_mach_specific.xml

    # Lastly - copy Initial conditions
    echo "Here is the RUNDIR ${CASE_RUN_DIR}"
    eamic="v21.LR.SMYLE_IC.${useyear}-${usemonth}.01.eam.i.${useyear}-${usemonth}-01-00000.nc"
    perteamic="v21.LR.SMYLE_IC.pert.eam.i.${useyear}-${usemonth}-01-00000.nc"
    ics="/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/v21.LR.SMYLE_IC.${useyear}-${usemonth}.01/"
    # v2.1 eam.i is L72; v3.1 EAM is L80. Atmosphere ICs come from the
    # vertically remapped copies made by make_eami_L80.sh (same file names).
    ics80="/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init_L80/v21.LR.SMYLE_IC.${useyear}-${usemonth}.01/"

    ls ${CASE_RUN_DIR}

    # pre-stage ICs (land/river/ocean/ice restarts from the v2.1 IC set)
    cp ${ics}/${useyear}-${usemonth}-01/rpointer.* ${CASE_RUN_DIR}/
    ln -s ${ics}/${useyear}-${usemonth}-01/v21.* ${CASE_RUN_DIR}/

    # atmosphere IC: L80 version, perturbed for members other than 001
    shortmbr=${mbr:1:3}
    if [[ ${imbr} -ne "1" ]] && [ -f ${ics80}/pert.${shortmbr}/${perteamic} ]; then
       eamsrc=${ics80}/pert.${shortmbr}/${perteamic}
    else
       if [[ ${imbr} -ne "1" ]]; then
          echo "WARNING: no perturbed IC ${ics80}/pert.${shortmbr}/${perteamic}; using unperturbed L80 IC"
       fi
       eamsrc=${ics80}/${useyear}-${usemonth}-01/${eamic}
    fi
    if [ ! -f ${eamsrc} ]; then
       echo "ERROR: L80 atmosphere IC ${eamsrc} not found. Run make_eami_L80.sh ${useyear} ${usemonth}"
       exit 410
    fi
    rm -f ${CASE_RUN_DIR}/${eamic}
    ln -s ${eamsrc} ${CASE_RUN_DIR}/${eamic}
    ls -l ${CASE_RUN_DIR}/${eamic}


    popd
}

#-----------------------------------------------------
case_build() {

    pushd ${CASE_SCRIPTS_DIR}

    #do_case_build = true
    if [ "${do_case_build,,}" != "true" ]; then

        echo $'\n----- case_build -----\n'

        if [ "${OLD_EXECUTABLE}" == "" ]; then
            # Ues previously built executable, make sure it exists
            if [ -x ${CASE_BUILD_DIR}/e3sm.exe ]; then
                echo 'Skipping build because $do_case_build = '${do_case_build}
            else
                echo 'ERROR: $do_case_build = '${do_case_build}' but no executable exists for this case.'
                #exit 297
            fi
        else
            # If absolute pathname exists and is executable, reuse pre-exiting executable
            if [ -x ${OLD_EXECUTABLE} ]; then
                echo 'Using $OLD_EXECUTABLE = '${OLD_EXECUTABLE}
                cp -fp ${OLD_EXECUTABLE} ${CASE_BUILD_DIR}/
            else
                echo 'ERROR: $OLD_EXECUTABLE = '$OLD_EXECUTABLE' does not exist or is not an executable file.'
                exit 297
            fi
        fi
        echo 'WARNING: Setting BUILD_COMPLETE = TRUE.  This is a little risky, but trusting the user.'
        ./xmlchange BUILD_COMPLETE=TRUE

    # do_case_build = true
    else

        echo $'\n----- Starting case_build -----\n'

        # Turn on debug compilation option if requested
        if [ "${DEBUG_COMPILE^^}" == "TRUE" ]; then
            ./xmlchange DEBUG=${DEBUG_COMPILE^^}
        fi

        # Run CIME case.build
        ./case.build

    fi

        # Some user_nl settings won't be updated to *_in files under the run directory
        # Call preview_namelists to make sure *_in and user_nl files are consistent.
        ./preview_namelists


    popd
}

#-----------------------------------------------------
runtime_options() {

    echo $'\n----- Starting runtime_options -----\n'
    pushd ${CASE_SCRIPTS_DIR}

    # Set simulation start date
    ./xmlchange RUN_STARTDATE=${START_DATE}

    # Segment length
    ./xmlchange STOP_OPTION=${STOP_OPTION,,},STOP_N=${STOP_N}

    # Restart frequency
    ./xmlchange REST_OPTION=${REST_OPTION,,},REST_N=${REST_N}

    # Coupler history
    ./xmlchange HIST_OPTION=${HIST_OPTION,,},HIST_N=${HIST_N}

    # Coupler budgets (always on)
    ./xmlchange BUDGETS=TRUE

    # Set resubmissions
    if (( RESUBMIT > 0 )); then
        ./xmlchange RESUBMIT=${RESUBMIT}
    fi

    # Run type
    # Start from default of user-specified initial conditions
    if [ "${MODEL_START_TYPE,,}" == "initial" ]; then
        ./xmlchange RUN_TYPE="startup"
        ./xmlchange CONTINUE_RUN="FALSE"

    # Continue existing run
    elif [ "${MODEL_START_TYPE,,}" == "continue" ]; then
        ./xmlchange CONTINUE_RUN="TRUE"

    elif [ "${MODEL_START_TYPE,,}" == "branch" ] || [ "${MODEL_START_TYPE,,}" == "hybrid" ]; then
        ./xmlchange RUN_TYPE=${MODEL_START_TYPE,,}
        ./xmlchange GET_REFCASE=${GET_REFCASE}
	./xmlchange RUN_REFDIR=${RUN_REFDIR}
        ./xmlchange RUN_REFCASE=${RUN_REFCASE}
        ./xmlchange RUN_REFDATE=${RUN_REFDATE}
        echo 'Warning: $MODEL_START_TYPE = '${MODEL_START_TYPE} 
	echo '$RUN_REFDIR = '${RUN_REFDIR}
	echo '$RUN_REFCASE = '${RUN_REFCASE}
	echo '$RUN_REFDATE = '${START_DATE}
 
    else
        echo 'ERROR: $MODEL_START_TYPE = '${MODEL_START_TYPE}' is unrecognized. Exiting.'
        exit 380
    fi

    # Patch mpas streams files
    patch_mpas_streams

    popd
}

#-----------------------------------------------------
case_submit() {

    if [ "${do_case_submit,,}" != "true" ]; then
        echo $'\n----- Skipping case_submit -----\n'
        return
    fi

    echo $'\n----- Starting case_submit -----\n'
    pushd ${CASE_SCRIPTS_DIR}
    
    # Run CIME case.submit
    ./case.submit

    popd
}

#-----------------------------------------------------
copy_script() {

    echo $'\n----- Saving run script for provenance -----\n'

    local script_provenance_dir=${CASE_SCRIPTS_DIR}/run_script_provenance
    mkdir -p ${script_provenance_dir}
    local this_script_name=`basename $0`
    local script_provenance_name=${this_script_name}.`date +%Y%m%d-%H%M%S`
    cp -vp ${this_script_name} ${script_provenance_dir}/${script_provenance_name}

}

#-----------------------------------------------------
# Silent versions of popd and pushd
pushd() {
    command pushd "$@" > /dev/null
}
popd() {
    command popd "$@" > /dev/null
}

# Now, actually run the script
#-----------------------------------------------------
main

done
