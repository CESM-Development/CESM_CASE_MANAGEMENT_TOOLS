#!/bin/bash
#!/bin/bash

INDIR="/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/datm_TRENDY/"
OUTDIR="/global/cfs/cdirs/mp9/E3SMv2.1-SMYLE/datm_TRENDY_climo1999-2020/"
OUT="Solr_January_1999_2020_mean.nc"
#VARS="FSDS,FSDSVIS,FSDSNIR"
VARS="FSDS"

FILES=""
for yr in $(seq 1999 2020); do
    FILES="$FILES $INDIR/clmforc.TRENDY_qianFilled.c2017.0.5d.Solr.${yr}-01.nc"
done

# Average selected variables
ncea -v $VARS $FILES $OUTDIR/$OUT

