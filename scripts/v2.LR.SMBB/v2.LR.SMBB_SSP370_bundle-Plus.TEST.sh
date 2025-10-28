#!/bin/bash -l

echo ===== Start of v2.LR.SSP370_Plus.sh =====
date
echo =======================================

export SLURM_NNODES=101

# Loop over members
for n in \
0111 0121 0131 0141 0161 0171 0181 0191 \
0211 0221 0231 0480 0320
do

  echo === Starting member ${n} ===

  echo === Starting member ${n} ===
  if [ "$n" == "0480" ]; then
        #cd /global/cfs/cdirs/ccsm1/people/nanr/cases/e3smv1-le/e3smv1.20TR_CMIP6.ne30_oECv3_ICG.LE-v1.0480.002
        #./xmlchange run_exe="--kill-on-bad-exit=1 --job-name=${n} \${EXEROOT}/e3sm.exe "
        #./xmlchange STOP_N="5"
        #./case.submit --no-batch 2>&1 > ../log.o${SLURM_JOB_ID} &
        #PID=$!
        #echo $PID
        echo "0480.002"

  elif [ "$n" == "0320" ]; then
        #cd /global/cfs/cdirs/ccsm1/people/nanr/cases/e3smv1-le/e3smv1.20TR_CMIP6.ne30_oECv3_ICG.LE-v1.0320.003
  	#./xmlchange run_exe="--kill-on-bad-exit=1 --job-name=${n} \${EXEROOT}/e3sm.exe "
        #./xmlchange STOP_N="5"
        #./case.submit --no-batch 2>&1 > ../log.o${SLURM_JOB_ID} &
        #PID=$!
        #echo $PID
        echo "0320.003"

  else 
        echo "smbb"
  	#cd /global/cscratch1/sd/nanr/E3SMv2-SMBB/v2.LR.SSP370-smbb_${n}/case_scripts
  	#./xmlchange run_exe="--kill-on-bad-exit=1 --job-name=${n} \${EXEROOT}/e3sm.exe "
  	#./xmlchange STOP_N="10"
  	#./case.submit --no-batch 2>&1 > ../log.o${SLURM_JOB_ID} &
  	#PID=$!
  	#echo $PID
  fi

  echo ============================

done

