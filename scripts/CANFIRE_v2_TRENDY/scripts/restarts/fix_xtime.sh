#!/bin/bash

#module load e4s
#spack env activate gcc
#spack load nco
#module load cudatoolkit/11.5
#module load python

mon=08

for year in {2019..2019}; do
  case=v21.LR.SMYLE_IC.${year}-${mon}.01
  poprfout=v21.LR.SMYLE_IC.${year}-${mon}.01.mpaso.rst.$year-${mon}-01_00000.nc
  icerfout=v21.LR.SMYLE_IC.${year}-${mon}.01.mpassi.rst.$year-${mon}-01_00000.nc
  icdir=/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init/${case}/${year}-${mon}-01
  echo $case
  echo $icdir
  mv $icdir/${poprfout} $icdir/${poprfout}.xtime.nc
  mv $icdir/${icerfout} $icdir/${icerfout}.xtime.nc
  ncrename -v xtime,xtime.orig $icdir/${poprfout}.xtime.nc $icdir/${poprfout}
  ncrename -v xtime,xtime.orig $icdir/${icerfout}.xtime.nc $icdir/${icerfout}
done

