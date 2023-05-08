#!/bin/bash -l

echo ===== Start of v2.LR.LE_mixedbundle.sh =====
date
echo =======================================

export SLURM_NNODES=101

# Loop over members
for n in \
0101 0141 0151 0161 0201 0211 0251 0291 0301 0320 0480
do

  echo === Starting member ${n} ===

  if [[ ${n} == 0320 || ${n} == 0480 ]]
  then
     if [[ ${n} == 0480 ]]
     then
	echo "0480"
     fi

     if [[ ${n} == 0320 ]]
     then
	echo "0320"
     fi
     echo "do some stuff"
  else
     echo "do other stuff"
      if [[ ${n} == 0211 ]]
      then
      		  echo "0211"
      else
      		  echo "everyone else"
      fi
  fi

done

