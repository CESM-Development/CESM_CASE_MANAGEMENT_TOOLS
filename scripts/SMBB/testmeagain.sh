#!/bin/bash -fe

# E3SM Water Cycle v2 run_e3sm script template.
#
# Inspired by v1 run_e3sm script as well as SCREAM group simplified run script.
#
# Bash coding style inspired by:
# http://kfirlavi.herokuapp.com/blog/2012/11/14/defensive-bash-programming

#array=( 0111 0121 0131 0141 0161 0171 0181 0191 0211 0221 0231 )
   array=( 0241 0261 0271 0281 0291 0101 0151 0201 0251 0301 )
refarray=( 1991 1991 1991 1991 1991 1990 1990 1990 1990 1990 )
#array=( 0111 0121 0131 0141 0161 0171 0181 0191 0211 0221 0231 0241 0261 0271 0281 0291 )
#array=( 0131 0141 0161 0171 0181 0191 0211 0221 0231 0241 0261 0271 0281 0291 )

set ctr=0

echo "garbage"

for iyr in "${array[@]}"
do


# For debugging, uncomment libe below
#set -x


# Year array YYYY:  

echo ${iyr}
echo ${refarray[$ctr]}
set refyear=${refarray[$ctr]}
echo "here is the ${refarray[$ctr]}"

# --- Configuration flags ----

# Machine and project
MACHINE=cori-knl
PROJECT="m4195"
#readonly YYYY="0141"
#readonly YYYY=${iyr}

# Simulation
COMPSET="WCYCL20TR" # 20th century transient
RESOLUTION="ne30pg2_EC30to60E2r2"
CASE_NAME="v2.LR.historical-smbb_${iyr}"
CASE_GROUP="v2.LR"

# Code and compilation
CHECKOUT="20220412"
BRANCH="maint-2.0" # master as of 2021-12-21
CHERRY=(  )
DEBUG_COMPILE=false

# Run options
MODEL_START_TYPE="hybrid"  # 'initial', 'continue', 'branch', 'hybrid'
START_DATE="${refarray[$ctr]}-01-01"

# Additional options for 'branch' and 'hybrid'
GET_REFCASE=TRUE
REFYEAR=${iyr}
RUN_REFDIR="/global/cscratch1/sd/nanr/archive/v2.LR.historical_${iyr}/archive/rest/${refarray[$ctr]}-01-01-00000"
echo $RUN_REFDIR
RUN_REFCASE="v2.LR.historical_${iyr}"
RUN_REFDATE="${refarray[$ctr]}-01-01"   # same as MODEL_START_DATE for 'branch', can be different for 'hybrid'
echo $RUN_REFDATE
ctr=$((ctr+1))

done
