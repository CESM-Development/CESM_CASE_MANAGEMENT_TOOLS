#!/bin/bash -l

#------------------------------------------------------------------------------
# Batch system directives
#------------------------------------------------------------------------------
#SBATCH  --job-name=v2.LR.LE
#SBATCH  --account=mp9
#SBATCH  --nodes=1618
#SBATCH  --output=/global/cscratch1/sd/nanr/E3SMv2/v2.LR.LE.o%j
#SBATCH  --exclusive
#SBATCH  --time=48:00:00
#SBATCH  --constraint=knl
#SBATCH  --qos=regular
#SBATCH  --no-kill
#SBATCH  --requeue

echo ===== Start of v2.LR.LE_bundle.sh =====
date
echo =======================================

export SLURM_NNODES=101

# Loop over members
for n in \
0111 0121 0131 0141 0161 0171 0181 0191 \
0211 0221 0231 0241 0261 0271 0281 0291
do

  echo === Starting member ${n} ===

  cd /global/cscratch1/sd/nanr/E3SMv2/v2.LR.SSP370_${n}/case_scripts
  ./xmlchange run_exe="--kill-on-bad-exit=1 --job-name=${n} \${EXEROOT}/e3sm.exe "
  if [[ ${n} == 0111 || ${n} == 0121 || ${n} == 0131 || ${n} == 0181 || ${n} == 0191 || \
        ${n} == 0231 || ${n} == 0241 || ${n} == 0271 || ${n} == 0281 ]]
  then
      ./xmlchange STOP_N="4"
  else
      ./xmlchange STOP_N="10"
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

echo ===== End of v2.LR.LE_bundle.sh =====
date
echo =====================================

