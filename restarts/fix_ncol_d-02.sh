#!/bin/bash

#module load e4s
#spack env activate gcc
#spack load nco
#module load cudatoolkit/11.5
#module load python

for year in {2019..2019}; do
for pert in {01..20}; do
  case=v21.LR.SMYLE_IC.${year}-02.01
  eamfile=v21.LR.SMYLE_IC.pert.eam.i.$year-02-01-00000.nc
  icdir=/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/${case}/pert.${pert}
  echo $case
  echo $icdir
  ncrename -d ncol_d,ncol $icdir/${eamfile}
done
done

