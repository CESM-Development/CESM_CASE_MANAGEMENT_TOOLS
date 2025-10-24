#!/bin/bash

for n in \
0111 0121 0131 0141 0161 0171 0181 0191 \
0211 0221 0231 
do
  cd /global/cscratch1/sd/nanr/E3SMv2-AMIP/v2.LR.AMIP20TR_${n}/case_scripts
  ./xmlchange CONTINUE_RUN="TRUE"
done

echo === Submitting continuation job ===
date
cd /global/u2/n/nanr/CESM_tools/e3sm/v2/scripts/AMIP
sbatch v2.LR.AMIP_bundle.sh
echo ===================================
