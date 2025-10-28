#!/bin/bash -l

#------------------------------------------------------------------------------
# Batch system directives
#------------------------------------------------------------------------------
#SBATCH  --job-name=v2.LR.hist
#SBATCH  --account=m4195
#SBATCH  --nodes=1113
#SBATCH  --output=/global/cscratch1/sd/nanr/E3SMv2-SMBB/v2.LR.hist.o%j
#SBATCH  --exclusive
#SBATCH  --time=48:00:00
#SBATCH  --constraint=knl
#SBATCH  --qos=regular
#SBATCH  --no-kill
#SBATCH  --requeue

echo ===== Start of v2.LR.SMBB_bundle.sh =====
date
echo =======================================

export SLURM_NNODES=101

# Loop over members
for n in \
0101 0151 0201 0241 0251 0261 0271 0281 0291 \
0301 9999
do

  echo === Starting member ${n} ===
  if [ "$n" == "9999" ]
  then
       cd /global/cfs/cdirs/ccsm1/people/nanr/cases/e3smv2/v2.1.LR.1pctCO2_EXTEND.001
       ./xmlchange run_exe="--kill-on-bad-exit=1 --job-name=${n} \${EXEROOT}/e3sm.exe "
       ./xmlchange STOP_N="10"
       ./case.submit --no-batch 2>&1 > ../log.o${SLURM_JOB_ID} &
       PID=$!
       echo $PID
       echo "1PCT-EXTND"
  else
      cd /global/cscratch1/sd/nanr/E3SMv2-SMBB/v2.LR.historical-smbb_${n}/case_scripts
      ./xmlchange run_exe="--kill-on-bad-exit=1 --job-name=${n} \${EXEROOT}/e3sm.exe "
      if (${n} == 0101 || ${n} == 0151 || ${n} == 0201 || ${n} == 0251 || ${n} == 0301 ) then
        ./xmlchange STOP_N="5"
      else
        ./xmlchange STOP_N="4"
      fi

      #./xmlchange STOP_N="10"
      ./case.submit --no-batch 2>&1 > ../log.o${SLURM_JOB_ID} &
      PID=$!
      echo $PID

      echo ============================

   fi

done

# Wait loop with external hook
while true
do

  sleep 60

  # Execute extra instructions
  cd /global/u2/n/nanr/CESM_tools/e3sm/v2/scripts/SMBB
  . ./v2.LR.SMBB_extra.sh

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
cd /global/u2/n/nanr/CESM_tools/e3sm/v2/scripts/SMBB
. ./v2.LR.SMBB_post.sh

# That's all folks!
sleep 10

echo ===== End of v2.LR.SMBB_bundle.sh =====
date
echo =====================================

