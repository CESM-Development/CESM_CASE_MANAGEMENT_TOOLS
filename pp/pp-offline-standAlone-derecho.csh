#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm13-ASD-HR/
setenv DOUT_S_ROOT  /glade/derecho/scratch/jiangzhu/archive/
setenv CASEROOT /glade/derecho/scratch/nanr/post-proc/

# module use /glade/work/bdobbins/Software/Modules
# module load cesm_postprocessing_derecho

# ...
# case name counter
set CASE = b.e13.B1850C5.ne120_t12.icesm13_ihesp.PI.002

mkdir -p $CASEROOT/$CASE
cd $CASEROOT/$CASE

if ( ! -d "postprocess" ) then
   module use /glade/work/bdobbins/Software/Modules
   module load cesm_postprocessing_derecho
   create_postprocess -caseroot=`pwd`
endif

cd postprocess

cp $CESM2_TOOLS_ROOT/pp/env_timeseries.xml-HR $CASEROOT/$CASE/postprocess/env_timeseries.xml

pp_config --set DOUT_S_ROOT=$DOUT_S_ROOT/$CASE/
pp_config --set DOUT_S_ROOT=/glade/derecho/scratch/jiangzhu/archive/b.e13.B1850C5.ne120_t12.icesm13_ihesp.PI.002
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

