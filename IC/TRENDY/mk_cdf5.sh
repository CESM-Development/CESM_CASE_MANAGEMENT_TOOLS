#!/bin/bash

#module load e4s
#spack env activate gcc
#spack load nco
#module load cudatoolkit/11.5
#module load python

for year in {2017..2019}; do
for mon in {01..12}; do
  ifile1=/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/datm_TRENDY/clmforc.TRENDY_qianFilled.c2017.0.5d.Solr.${year}-${mon}.nc
  ifile2=/pscratch/sd/n/nanr/TRENDY/clmforc.TRENDY_qianFilled.c2017.0.5d.Solr.${year}-${mon}.nc
  #ifile1=/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/datm_TRENDY/clmforc.TRENDY_qianFilled.c2017.0.5d.TPQWL.${year}-${mon}.nc
  #ifile2=/pscratch/sd/n/nanr/TRENDY/clmforc.TRENDY_qianFilled.c2017.0.5d.TPQWL.${year}-${mon}.nc
  #ifile1=/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/datm_TRENDY/clmforc.TRENDY_qianFilled.c2017.0.5d.Prec.${year}-${mon}.nc
  #ifile2=/pscratch/sd/n/nanr/TRENDY/clmforc.TRENDY_qianFilled.c2017.0.5d.Prec.${year}-${mon}.nc
  echo $ifile1
  echo $ifile2
  #mv $ifile1 $ifile2
  nccopy -k cdf5 $ifile2 $ifile1
done
done

