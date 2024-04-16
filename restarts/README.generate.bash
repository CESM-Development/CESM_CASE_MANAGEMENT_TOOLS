export CYLC_TASK_CYCLE_POINT="1959-11-01"

### use bash

module load e4s
spack env activate gcc
spack load nco
module load cudatoolkit/11.5
module load python

module load python/3.9-anaconda-2021.11

## Edit start years to set up
Step 1:  ./create-v2.SMYLE.IC_RESTARTS.csh
Step 2:  ./run_generate.sh
Step 3:  ./fix_xtime.sh			(change xtime to xtime.orig in mpaso.rst files)
Step 4:  ./fix_ncol_d.sh		(change ncol_d to ncol in eam.i files)


export CYLC_TASK_CYCLE_POINT=1970-11-01
PYTHONPATH=/global/cfs/cdirs/ccsm1/people/nanr/e3sm_tags/E3SMv2.1/E3SM/cime/CIME/Tools ./generate_cami_ensemble_offline.py 


## Don't have to do this anymore, now that I've fixed the code:
# PYTHONPATH=/global/cfs/cdirs/ccsm1/people/nanr/e3sm_tags/E3SMv2.1/E3SM/cime/CIME/Tools ./generate_cami_ensemble_offline.py 
