#!/bin/csh -f
### set env variables

## Tag includes sfwf SourceMods!
setenv INPATH $SCRATCH/archive/
setenv OUTPATH $SCRATCH/genTS_timeseries/
setenv CASENAME b.e21.BSSP370cmip6.f09_g17.subCESMulator.001


module load apptainer
apptainer run --bind /glade/derecho --cleanenv docker://agentoxygen/gents:latest run_gents --model CESM3 $MYPATH/$CASENAME/atm/ -o $OUTPATH/$CASENAME/atm/
