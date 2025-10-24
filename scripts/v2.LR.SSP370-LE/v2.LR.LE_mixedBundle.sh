#!/bin/bash -l

#------------------------------------------------------------------------------
# Batch system directives
#------------------------------------------------------------------------------
#SBATCH  --job-name=v2.LR.LE
#SBATCH  --account=mp9
#SBATCH  --nodes=1114
###SBATCH  --nodes=1618
#SBATCH  --output=/global/cscratch1/sd/nanr/E3SMv2/v2.LR.LE.o%j
#SBATCH  --exclusive
#SBATCH  --time=48:00:00
#SBATCH  --constraint=knl
#SBATCH  --qos=regular
#SBATCH  --no-kill
#SBATCH  --requeue

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
      cd /global/project/projectdirs/ccsm1/people/nanr/cases/e3smv1-le/e3smv1.20TR_CMIP6.ne30_oECv3_ICG.LE-v1.0480.002/
     fi

     if [[ ${n} == 0320 ]]
     then
      cd /global/project/projectdirs/ccsm1/people/nanr/cases/e3smv1-le/e3smv1.20TR_CMIP6.ne30_oECv3_ICG.LE-v1.0320.003/
     fi

      ./xmlchange STOP_N=4
      ./xmlchange JOB_WALLCLOCK_TIME="48:00:00 --subgroup case.run"
      ./xmlchange JOB_WALLCLOCK_TIME="00:30:00 --subgroup case.st_archive"
      ./xmlchange JOB_QUEUE="debug --subgroup case.st_archive"
      ./xmlchange RESUBMIT=0
      ./xmlchange run_exe="--kill-on-bad-exit=1 --job-name=${n} \${EXEROOT}/e3sm.exe "

  else

      cd /global/cscratch1/sd/nanr/E3SMv2/v2.LR.SSP370_${n}/case_scripts
      ./xmlchange run_exe="--kill-on-bad-exit=1 --job-name=${n} \${EXEROOT}/e3sm.exe "
      if [[ ${n} == 0211 ]]
      then
     	    ./xmlchange STOP_N="3"
      else
            ./xmlchange STOP_N="10"
      fi
  fi

  ./case.submit --no-batch 2>&1 > ../log.o${SLURM_JOB_ID} &
  PID=$!
  echo $PID

  echo ============================

done

# Wait loop with external hook
while true
do

  sleep 60

  # Execute extra instructions
  cd /global/u2/n/nanr/CESM_tools/e3sm/v2/scripts/SSP
  . ./v2.LR.LE_extra.sh

  # List running background processes.
  # (Needed for the stop clause below to work)
  k=$((k+1))
  if (( k % 5 == 0 ))
  then
    echo ============================
    date
    jobs -l
    echo ----------------------------
    squeue --job=${SLURM_JOBID} --steps
    echo ============================
  fi

  # Stop when all processes are done
  n=`jobs -l | wc -l`
  if (( n == 0 ))
  then
     echo ============================
     date
     echo No running jobs left
     echo ============================
     break
  fi

done

# Wait for all members to complete
wait

# Post steps
cd /global/u2/n/nanr/CESM_tools/e3sm/v2/scripts/SSP
. ./v2.LR.LE_post.sh

# That's all folks!
sleep 10

echo ===== End of v2.LR.LE_mixedbundle.sh =====
date
echo =====================================

