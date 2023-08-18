#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/pp-offline/
setenv INPUT_DATA  /glade/derecho/scratch/jiangzhu/archive/
setenv CASEROOT /glade/derecho/scratch/nanr/post-proc/

# module use /glade/work/bdobbins/Software/Modules
# module load cesm_postprocessing_derecho

# ...
# case name counter
# set CASE = b.e13.B1850C5.ne120_t12.icesm13_ihesp.PI.002
set CASE = b.e13.B1850C5.ne120_t12.icesm13_ihesp.eocene_06x.002

mkdir -p $CASEROOT/$CASE
cd $CASEROOT/$CASE

if ( ! -d "postprocess" ) then
   module use /glade/work/bdobbins/Software/Modules
   module load cesm_postprocessing_derecho
   create_postprocess -caseroot=`pwd`
endif

cd postprocess

cp $CESM2_TOOLS_ROOT/derecho/HR/env_timeseries.xml $CASEROOT/$CASE/postprocess/
cp $CESM2_TOOLS_ROOT/derecho/HR/timeseries $CASEROOT/$CASE/postprocess/

# =========================
# change a few things
# =========================
pp_config --set DOUT_S_ROOT=$INPUT_DATA/$CASE/
pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/derecho/scratch/nanr/timeseries/$CASE/
pp_config --set CASE=$CASE
pp_config --set ATM_GRID=ne120np4
pp_config --set LND_GRID=ne120np4
pp_config --set ICE_GRID=tx0.1v2
pp_config --set OCN_GRID=tx0.1v2
pp_config --set ICE_NX=3600
pp_config --set ICE_NY=2400

echo "Made it here"

exit

