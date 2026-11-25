#!/bin/bash
#SBATCH -A m5463
#SBATCH -C cpu
#SBATCH -q shared
#SBATCH -c 4
#SBATCH --mem=48G
#SBATCH -t 04:00:00
#SBATCH -J so2_nostratvolc
#SBATCH -o so2_nostratvolc.%j.out
#
# Make a copy of the CMIP7 elevated SO2 emission file WITHOUT the
# 'stratvolc' sector, for use with E3SMv2.1 (which already prescribes
# stratospheric volcanic aerosol through prescribed_volcaero).
#
# Input : 52 GB netCDF-4 (sectors BB ENE_ELEV IND_ELEV contvolc stratvolc)
# Output: ~41 GB CDF5     (sectors BB ENE_ELEV IND_ELEV contvolc)
#
# Run once:   sbatch make_so2_nostratvolc.sh
# NCO holds a whole variable (~10 GB) in memory, so don't run on a login node.

set -e

IN=/global/cfs/cdirs/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/CMIP7_2deg/cmip7_so2_elev_1850-2023_1.9x2.5_stratvolc_c20251017.nc
OUTDIR=/global/cfs/cdirs/ccsm1/people/nanr/e3sm/inputdata/atm/cam/chem/trop_mozart_aero/emis/CMIP7_2deg-nostratvolc
OUT=${OUTDIR}/cmip7_so2_elev_1850-2023_1.9x2.5_nostratvolc_c20251017.nc

if [ -e "${OUT}" ]; then
    echo "ERROR: ${OUT} already exists. Not overwriting."
    exit 1
fi

source /global/common/software/e3sm/anaconda_envs/load_latest_e3sm_unified_pm-cpu.sh

mkdir -p ${OUTDIR}
# -5 : write CDF5 so v2.1's PIO (pnetcdf) can read it in parallel
# -x -v stratvolc : drop the stratospheric volcanic sector only
ncks -O -5 -x -v stratvolc ${IN} ${OUT}.tmp
ncatted -O -h -a history_nostratvolc,global,c,c,"$(date): removed stratvolc sector from $(basename ${IN}) with ncks for E3SMv2.1 (prescribed_volcaero already used)" ${OUT}.tmp
mv ${OUT}.tmp ${OUT}
chmod 644 ${OUT}

ncdump -h ${OUT} | grep -E "^\s+float"
ls -l ${OUT}
