#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-AMOC-aixue/
setenv DOUT_S_ROOT  /glade/scratch/molina/archive/
setenv CASEROOT /glade/scratch/nanr/post-proc/

module use /glade/work/bdobbins/Software/Modules
module load cesm_postprocessing

# ...
set CASE = b.e21.B1PCTcmip6.f09_g17.rampUp.001

mkdir -p $CASEROOT/$CASE
cd $CASEROOT/$CASE

if ( ! -d "postprocess" ) then
   create_postprocess -caseroot=`pwd`
endif

cd postprocess

#cp $CESM2_TOOLS_ROOT/scripts/env_timeseries.xml $CASEROOT/$CASE/postprocess

pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/scratch/nanr/timeseries/$CASE/
#pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/collections/cdg/timeseries-cmip6/$CASE
pp_config --set CASE=$CASE
pp_config --set DOUT_S_ROOT=$DOUT_S_ROOT/$CASE
pp_config --set ATM_GRID=0.9x1.25
pp_config --set LND_GRID=0.9x1.25
pp_config --set ICE_GRID=gx1v7
pp_config --set OCN_GRID=gx1v7
pp_config --set ICE_NX=320
pp_config --set ICE_NY=384

# =========================
# change a few things
# =========================
#mv timeseries timeseries-OTB
cp $CESM2_TOOLS_ROOT/scripts/timeseries $CASEROOT/$CASE/postprocess

#qsub ./timeseries

exit

