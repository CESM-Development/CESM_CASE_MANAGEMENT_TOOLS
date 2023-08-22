#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/ihesp-tools/
setenv DOUT_S_ROOT  /glade/derecho/scratch/nanr/archive/
setenv CASEROOT /glade/derecho/scratch/nanr/post-proc/

# module use /glade/work/bdobbins/Software/Modules
# module load cesm_postprocessing_derecho

# ...
# case name counter
set CASE = b.e13.BHISTC5.ne120_t12.cesm-ihesp-hires1.0.44-1920-2005.004
set CASE = b.e13.BHISTC5.ne120_t12.cesm-ihesp-hires1.0.44-1920-2005.005

mkdir -p $CASEROOT/$CASE
cd $CASEROOT/$CASE

if ( ! -d "postprocess" ) then
   module use /glade/work/bdobbins/Software/Modules
   module load cesm_postprocessing_derecho
   create_postprocess -caseroot=`pwd`
endif

cd postprocess

cp $CESM2_TOOLS_ROOT/pp/env_timeseries.xml-HR $CASEROOT/$CASE/postprocess/env_timeseries.xml
cp $CESM2_TOOLS_ROOT/pp/timeseries-derecho-HR $CASEROOT/$CASE/postprocess/timeseries

pp_config --set DOUT_S_ROOT=$DOUT_S_ROOT/$CASE/
pp_config --set DOUT_S_ROOT=/glade/derecho/scratch/nanr/archive/$CASE/
pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/derecho/scratch/nanr/timeseries/$CASE/
pp_config --set CASE=$CASE
pp_config --set DOUT_S_ROOT=$DOUT_S_ROOT/$CASE
pp_config --set ATM_GRID=ne120np4
pp_config --set LND_GRID=ne120np4
pp_config --set ICE_GRID=tx0.1v2
pp_config --set OCN_GRID=tx0.1v2
pp_config --set ICE_NX=3600
pp_config --set ICE_NY=2400



#pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/p/cesm/espwg/CESM2-SMYLE/timeseries/$CASE/
#qsub ./timeseries 

echo "Made it here"

# =========================
# change a few things
# =========================
#mv timeseries timeseries-OTB
#cp $CESM2_TOOLS_ROOT/pp/env_timeseries.xml-HR $CASEROOT/$CASE/postprocess/env_timeseries.xml

#qsub ./timeseries

exit

