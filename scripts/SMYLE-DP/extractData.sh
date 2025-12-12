#!/bin/bash


# Years, months, variables
#years=$(seq 1990 2023)
#months=$(seq -w 01 10)   # pads with zero: 01–10
#vars="rest rof lnd"
years=$(seq 1990 1990)
months=$(seq -w 01 03)   # pads with zero: 01–10
vars="rest rof lnd"

# Base HPSS path (without year)
hpss_base="/home/c/ccsm/E3SMv2.1-SMYLEsmbb/v21.LR.BSMYLEsmbb"

for Y in $years; do
  for M in $months; do
    for VAR in $vars; do

      hpss_dir="${hpss_base}.${Y}-11.001"
      archive_path="archive.0${M}/${VAR}/*"
      case_name="v21.LR.BSMYLEsmbb.${Y}-11.001"

      session_name="zst_${Y}_${M}_${VAR}"

      echo "Starting screen session: $session_name"
      echo "  zstash extract --hpss=${hpss_dir} \"${archive_path}\""

      screen -dmS $session_name \
        source /global/common/software/e3sm/anaconda_envs/load_latest_e3sm_unified_pm-cpu.sh
        mkdir $SCRATCH/archive/$case_name
        cd $SCRATCH/archive/$case_name
        bash -c "zstash extract --hpss=${hpss_dir} \"${archive_path}\" ; echo 'DONE: ${session_name}'"
    done
  done
done

