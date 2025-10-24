#!/bin/bash -l

#------------------------------------------------------------------------------
# Batch system directives
#------------------------------------------------------------------------------
echo ===== Start of v2.LR.SMBB_bundle.sh =====
date
echo =======================================

export SLURM_NNODES=101

# Loop over members
# for n in \
# 0111 0121 0131 0141 0161 0171 0181 0191 \
# 0211 0221 0231 
for n in \
0241 0261 0271 0281 0291 0101 0151 0201 \
0251 0301 9999 
do

  echo === Starting member ${n} ===

  echo $n

  if [ "$n" == "9999" ] 
  then
  echo "garbage"

  fi
  echo ============================

done

