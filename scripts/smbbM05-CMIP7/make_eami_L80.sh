#!/bin/bash
# Vertically remap v2.1 SMYLE eam.i initial conditions (L72) to the E3SMv3.1
# L80 grid, so they can start v3.1 EAM (-nlev 80).
#
# Usage:  ./make_eami_L80.sh YYYY MM      e.g.  ./make_eami_L80.sh 1990 05
#
# Remaps the unperturbed IC and every pert.NN IC for that start date. Output
# mirrors the input tree, with the same file names:
#   ${OUTROOT}/v21.LR.SMYLE_IC.YYYY-MM.01/YYYY-MM-01/v21.LR.SMYLE_IC.YYYY-MM.01.eam.i.YYYY-MM-01-00000.nc
#   ${OUTROOT}/v21.LR.SMYLE_IC.YYYY-MM.01/pert.NN/v21.LR.SMYLE_IC.pert.eam.i.YYYY-MM-01-00000.nc
#
# Method: ncremap vertical interpolation (log-pressure on the hybrid
# coordinate, using each file's own PS) onto hyai/hybi/hyam/hybm from the
# v3.1 default L80 IC. Both grids have a 0.1 hPa top. Points outside the
# source column use nearest-neighbor extrapolation (T below the lowest level
# uses NCO's 6.5 K/100 hPa lapse rate). PS, PHIS and surface fields are
# unchanged. Atmospheric chemistry/aerosols are not in the v2.1 file and
# cold-start in v3.1, exactly as before.

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 YYYY MM"; exit 1
fi
useyear=$1
usemonth=$2

INROOT=/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init
OUTROOT=/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/inputdata/e3sm_init_L80
L80_TEMPLATE=/global/cfs/cdirs/e3sm/inputdata/atm/cam/inic/homme/eami_mam4_Linoz_ne30np4_L80_c20231010.nc
VRT=${OUTROOT}/vrt_L80_from_eami_mam4_Linoz_ne30np4_L80_c20231010.nc

source /global/common/software/e3sm/anaconda_envs/load_latest_e3sm_unified_pm-cpu.sh > /dev/null 2>&1

umask 022
mkdir -p ${OUTROOT}

# Vertical-grid file. -C: do not pull in PS through lev:formula_terms,
# otherwise ncremap writes the template's PS into the output.
if [ ! -f ${VRT} ]; then
    ncks -O -C -v hyai,hybi,hyam,hybm,P0,lev,ilev ${L80_TEMPLATE} ${VRT}
fi

icdir=v21.LR.SMYLE_IC.${useyear}-${usemonth}.01
date=${useyear}-${usemonth}-01

remap() {   # in out
    if [ ! -f "$1" ]; then echo "MISSING input: $1"; return 1; fi
    mkdir -p $(dirname "$2")
    ncremap --vrt_fl=${VRT} --vrt_xtr=nrs_ngh -i "$1" -o "$2" > /dev/null
    echo "  $(basename $(dirname $2))/$(basename $2)  lev=$(ncdump -h $2 | awk '/^\tlev = /{print $3}')"
}

echo "Remapping ${icdir} to L80 -> ${OUTROOT}/${icdir}"
remap ${INROOT}/${icdir}/${date}/${icdir}.eam.i.${date}-00000.nc \
      ${OUTROOT}/${icdir}/${date}/${icdir}.eam.i.${date}-00000.nc

for p in ${INROOT}/${icdir}/pert.*; do
    pname=$(basename $p)
    remap ${p}/v21.LR.SMYLE_IC.pert.eam.i.${date}-00000.nc \
          ${OUTROOT}/${icdir}/${pname}/v21.LR.SMYLE_IC.pert.eam.i.${date}-00000.nc
done

echo "Done."
