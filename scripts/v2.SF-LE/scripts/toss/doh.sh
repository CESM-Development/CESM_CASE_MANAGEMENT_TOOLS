#!/bin/bash -fe

# E3SM Water Cycle v2 run_e3sm script template.
#
# Inspired by v1 run_e3sm script as well as SCREAM group simplified run script.
#
# Bash coding style inspired by:
# http://kfirlavi.herokuapp.com/blog/2012/11/14/defensive-bash-programming

#array=( 001 002 003 004 005 006 007 008 009 010 )
array=( 001 002 )
for mbr in "${array[@]}"
do

main() {

echo ${mbr}

# For debugging, uncomment libe below
#set -x

useyear=1959


# --- Configuration flags ----

CASE_NAME="v21.LR.BSMYLE.${useyear}-11.${mbr}"
if (${mbr} == "001") 
then
  MAIN_CASE_NAME="v21.LR.BSMYLE.${useyear}-11.${mbr}"
fi
