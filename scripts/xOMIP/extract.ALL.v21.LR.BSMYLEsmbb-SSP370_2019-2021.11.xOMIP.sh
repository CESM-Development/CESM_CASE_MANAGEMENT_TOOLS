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

useyear=2021
usemonth=11
#usemonth=05

#extract vars=PRECC,PRECL,TS,TREFHT,PSL,U,V)


# --- Configuration flags ----


if [[ ${imbr} -eq "1" ]]
then
  MAIN_CASE_NAME="v21.LR.BSMYLEsmbb.${useyear}-${usemonth}.${mbr}"
fi

MAIN_CASE_ROOT="/pscratch/sd/n/${USER}/v21.LR.BSMYLE_xOMIP/${MAIN_CASE_NAME}"

cd ${MAIN_CASE_ROOT}
ncrcat -v PRECC,PRECL,TS,TREFHT,PSL,U,V archive.${mbr}/atm/hist/v21.LR.BSMYLEsmbb.*-${usemonth}.${mbr}.eam.h0.* $SCRATCH/xfr/BSMYLEsmbb_xOMIP_forSasha.${useyear}-${usemonth}.${mbr}.nc

done
