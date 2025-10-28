#!/bin/bash -fe
#array=( 001 002 003 004 005 006 007 008 009 010 )
array=( 1 2 3 4 5 6 7 8 9 10 )
for mbr in "${array[@]}"
do

# For debugging, uncomment libe below
#set -x


echo ${mbr}

smbr=${mbr:1:3}
echo $smbr

if [[ ${mbr} -lt "10" ]]
then
  usembr="00${mbr}"
  echo ${usembr}
  MAIN_CASE_NAME="v21.LR.BSMYLE.${useyear}-11.${mbr}"
else
  usembr="0${mbr}"
  echo ${usembr}
fi


# --- Configuration flags ----

#CASE_NAME="v21.LR.BSMYLE.${useyear}-11.${mbr}"
#if (${mbr} == "001")
#then
  #MAIN_CASE_NAME="v21.LR.BSMYLE.${useyear}-11.${mbr}"
#fi

if [[ ${mbr} -eq "001" ]] 
then
   CASE_NAME="v21.LR.BSMYLE.00${mbr}"
   CASE_NAME="v21.LR.BSMYLE.${mbr}"
   echo "$CASE_NAME 1"
else
   CASE_NAME="v21.LR.BSMYLE.${mbr}"
   echo "$CASE_NAME 2"
fi
done


