#!/bin/bash 
###!/bin/bash -fe

# E3SM Water Cycle v2 run_e3sm script template.
#
# Inspired by v1 run_e3sm script as well as SCREAM group simplified run script.
#
# Bash coding style inspired by:
# http://kfirlavi.herokuapp.com/blog/2012/11/14/defensive-bash-programming

#array=( 001 002 003 004 005 006 007 008 009 010 )
array=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 )
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

useyear=1987
usemonth=11


# --- Configuration flags ----

# Machine and project
MACHINE=pm-cpu
PROJECT="m4417"

# Simulation
#COMPSET="WCYCLSSP370" # SSP370 transient
COMPSET="WCYCL20TR" # 20th century transient
RESOLUTION="ne30pg2_EC30to60E2r2"
CASE_NAME="v21.LR.BSMYLE.${useyear}-${usemonth}.${mbr}"
if [[ ${imbr} -eq "1" ]]
then
  #MAIN_CASE_NAME="v21.LR.BSMYLE-MYTEST.${useyear}-${usemonth}.${mbr}"
  MAIN_CASE_NAME="v21.LR.BSMYLE.${useyear}-${usemonth}.${mbr}"
fi
CASE_GROUP="v21.LR"

# Code and compilation
CHECKOUT="20231020"
BRANCH="maint-2.1" # master as of 2021-12-21
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
CODE_ROOT="${MY_PATH}/e3sm_tags/E3SMv2.1/"
MAIN_CASE_ROOT="/pscratch/sd/n/${USER}/v21.LR.SMYLE/${MAIN_CASE_NAME}"
CASE_ROOT="/pscratch/sd/n/${USER}/v21.LR.SMYLE/${MAIN_CASE_NAME}/"

# Sub-directories
#CASE_BUILD_DIR=${MAIN_CASE_ROOT}/build
CASE_BUILD_DIR=/pscratch/sd/n/nanr/v21.LR.SMYLE/exeroot/build
#CASE_ARCHIVE_DIR=${MAIN_CASE_ROOT}/archive.${mbr}
CASE_ARCHIVE_DIR=/global/cfs/cdirs/mp9/archive/v21.LR.SMYLE/${MAIN_CASE_NAME}/archive.${mbr}

CASE_SCRIPTS_DIR=${MAIN_CASE_ROOT}/case_scripts.${mbr}
CASE_RUN_DIR=${MAIN_CASE_ROOT}/run.${mbr}

# Make directories created by this script world-readable
umask 022

# st_archive
case_archive

# All done
echo $'\n----- All done -----\n'

}


#-----------------------------------------------------
case_archive() {

    echo $'\n----- Starting case_archive -----\n'
    echo ${CASE_SCRIPTS_DIR}
    pushd ${CASE_SCRIPTS_DIR}
    
    # Run CIME case.submit
    ./case.st_archive

    popd
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
