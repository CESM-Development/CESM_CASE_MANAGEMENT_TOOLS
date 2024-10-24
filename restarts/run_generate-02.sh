#!/bin/bash

#module load e4s
#spack env activate gcc
#spack load nco
#module load cudatoolkit/11.5
#module load python

for year in {2019..2019}; do
        export CYLC_TASK_CYCLE_POINT=$year-02-01
        PYTHONPATH=/global/cfs/cdirs/ccsm1/people/nanr/e3sm_tags/E3SMv2.1/E3SM/cime/CIME/Tools ./generate_cami_ensemble_offline-02.py 
done

