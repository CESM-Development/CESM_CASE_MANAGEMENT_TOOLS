#!/bin/bash -l


echo ===== Start of v2.LR.SSP370_Plus.sh =====
date
echo =======================================

export SLURM_NNODES=101

# Loop over members
for n in \
0111 0121 0131 0141 0161 0171 0181 0191 \
0211 0221 0231 
do

  echo === Starting member ${n} ===
    #if [ "$n" == "0111"  || "$n" == "0121" || "$n" == "0191" || "$n" == "0221" ]; then
    if [ "$n" == "0111" ] | [ "$n" == "0121" ]; then
  	echo "first"
    else 
  	echo "second"
    fi
        echo "smbb"

done

