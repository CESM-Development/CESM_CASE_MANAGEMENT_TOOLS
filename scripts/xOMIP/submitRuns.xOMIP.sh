#!/bin/bash
# Recursively rename NetCDF files by pattern substitution.

# Base directory to search
#BASE_DIR="/pscratch/sd/n/nanr/v21.LR.BSMYLE_xOMIP/v21.LR.BSMYLE_xOMIP.2019-11.001/"
BASE_DIR="/pscratch/sd/n/nanr/v21.LR.BSMYLE_xOMIP/v21.LR.BSMYLE_xOMIP.2019-05.001/"

array=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 )
for imbr in "${array[@]}"
do

if [[ ${imbr} -lt "10" ]]
then
  mbr="00${imbr}"
  echo ${mbr}
else
  mbr="0${imbr}"
  echo ${mbr}
fi


cd ${BASE_DIR}/case_scripts.$mbr
./case.submit

done
