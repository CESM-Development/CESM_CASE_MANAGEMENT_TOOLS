#!/bin/bash -fe
array=( 001 )
for mbr in "${array[@]}"
do

# For debugging, uncomment libe below
#set -x


echo ${mbr}

# --- Configuration flags ----

if [[ ${mbr} -lt 10 ]] 
then
   CASE_NAME="v21.LR.BSMYLE.00${mbr}"
   CASE_NAME="v21.LR.BSMYLE.${mbr}"
   echo "$CASE_NAME 1"
else
   CASE_NAME="v21.LR.BSMYLE.${mbr}"
   echo "$CASE_NAME 2"
fi
done


