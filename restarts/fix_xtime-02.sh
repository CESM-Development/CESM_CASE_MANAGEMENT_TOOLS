#!/bin/bash

#module load e4s
#spack env activate gcc
#spack load nco
#module load cudatoolkit/11.5
#module load python

for year in {2021..2023}; do
  case=v21.LR.SMYLE_IC.${year}-02.01
  poprfout=v21.LR.SMYLE_IC.${year}-02.01.mpaso.rst.$year-02-01_00000.nc
  icerfout=v21.LR.SMYLE_IC.${year}-02.01.mpassi.rst.$year-02-01_00000.nc
  icdir=/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/${case}/${year}-02-01
  echo $case
  echo $icdir
  # fix ocean
  mv $icdir/${poprfout} $icdir/${poprfout}.xtime.nc
  ncrename -v xtime,xtime.orig $icdir/${poprfout}.xtime.nc $icdir/${poprfout}
  # fix ice
  mv $icdir/${icerfout} $icdir/${icerfout}.xtime.nc
  ncrename -v xtime,xtime.orig $icdir/${icerfout}.xtime.nc $icdir/${icerfout}

done

