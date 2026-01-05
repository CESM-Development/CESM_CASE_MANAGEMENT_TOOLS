#!/bin/bash

# Loop ranges
years=$(seq 1993 1993)
mbr=$(seq -w 01 10)
#vars="rest rof lnd"
vars="rest rof lnd"

# Base HPSS path (without year)
hpss_base="/home/c/ccsm/E3SMv2.1-SMYLEsmbb/v21.LR.BSMYLEsmbb"

for Y in $years; do
  for M in $mbr; do
    for VAR in $vars; do

      hpss_dir="${hpss_base}.${Y}-11.001"
      archive_path="archive.0${M}/${VAR}/*"
      case_name="v21.LR.BSMYLEsmbb.${Y}-11.001"

      outdir="$SCRATCH/archive/$case_name"
      logfile="$outdir/${Y}_${M}_${VAR}.log"

      session_name="zst_${Y}_${M}_${VAR}"

      # Create output directory if needed
      mkdir -p "$outdir"

      # ------------------------------
      # Skip if files already extracted
      # ------------------------------
      if compgen -G "$outdir/${archive_path}" > /dev/null; then
        echo "Skipping $session_name — files already downloaded."
        continue
      fi

      echo "Starting screen session: $session_name"
      echo "  zstash extract --hpss=${hpss_dir} \"${archive_path}\""
      echo "  Logging to: $logfile"

      # ------------------------------
      # Start the screen-run job safely
      # ------------------------------
      screen -dmS "$session_name" bash -c "
        source /global/common/software/e3sm/anaconda_envs/load_latest_e3sm_unified_pm-cpu.sh
        cd \"$outdir\"
        echo 'Running zstash extract for $session_name' | tee \"$logfile\"
        zstash extract --hpss=\"$hpss_dir\" \"$archive_path\" &>> \"$logfile\"
        echo \"DONE: $session_name\" | tee -a \"$logfile\"
      "

    done
  done
done

