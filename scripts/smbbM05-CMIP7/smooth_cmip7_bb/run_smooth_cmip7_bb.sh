#!/bin/bash
#SBATCH -A m5463
#SBATCH -C cpu
#SBATCH -q shared
#SBATCH -c 4
#SBATCH --mem=32G
#SBATCH -t 08:00:00
#SBATCH -J smooth_cmip7_bb
#SBATCH -o smooth_cmip7_bb.%j.out
#
# Smooth the BB sector of the CMIP7 elevated emission files (same set as the
# CMIP6 smbb files) and verify each output. pom_a4 was done interactively.
# Existing outputs are skipped (the python script never overwrites).

set -e
cd /global/cfs/cdirs/mp9/tools/CESM_CASE_MANAGEMENT_TOOLS/scripts/smbbM05-CMIP7/smooth_cmip7_bb
source /global/common/software/e3sm/anaconda_envs/load_latest_e3sm_unified_pm-cpu.sh

C=/global/cfs/cdirs/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/CMIP7_2deg
NS=/global/cfs/cdirs/ccsm1/people/nanr/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/CMIP7_2deg-nostratvolc
O=/global/cfs/cdirs/ccsm1/people/nanr/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/CMIP7_2deg-smoothed
TAG=smbb_c20261124

# src | variables
JOBS=(
  "$C/cmip7_mam5_bc_a4_elev_1850-2023_1.9x2.5_c20250506.nc|BB"
  "$C/cmip7_mam5_so4_a1_elev_1850-2023_1.9x2.5_c20250506.nc|BB"
  "$C/cmip7_mam5_num_a1_elev_1850-2023_1.9x2.5_c20250506.nc|num_a1_SO4_ELEV_BB"
  "$C/cmip7_mam5_num_a4_elev_1850-2023_1.9x2.5_c20250506.nc|num_a4_BC_ELEV_BB num_a4_POM_ELEV_BB"
  "$C/cmip7_SOAG0_elev_1850-2023_1.9x2.5_c20250506.nc|BB"
  "$NS/cmip7_so2_elev_1850-2023_1.9x2.5_nostratvolc_c20251017.nc|BB"
  "$C/cmip7_so2_elev_1850-2023_1.9x2.5_stratvolc_c20251017.nc|BB"
)

fail=0
for j in "${JOBS[@]}"; do
    src=${j%%|*}; vars=${j#*|}
    dst=$O/$(basename ${src%.nc})_${TAG}.nc
    echo "=================== $(date) $(basename $src)"
    if [ -e "$dst" ]; then
        echo "exists, skipping smoothing: $dst"
    else
        python -I smooth_cmip7_bb.py "$src" "$dst" $vars
    fi
    if python -I verify_smooth.py "$src" "$dst" $vars 2>&1 | grep -v -i warning | tee /dev/stderr | grep -q "ALL CHECKS PASSED"; then
        echo "VERIFIED $(basename $dst)"
    else
        echo "VERIFY FAILED $(basename $dst)"; fail=1
    fi
done
ls -l $O
echo "=================== $(date) done, fail=$fail"
exit $fail
