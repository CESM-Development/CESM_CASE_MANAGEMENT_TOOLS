#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-PPE-CAM/
setenv DOUT_S_ROOT  /glade/scratch/nanr/archive/
setenv CASEROOT /glade/scratch/nanr/post-proc/

module use /glade/work/bdobbins/Software/Modules
module load cesm_postprocessing

# ...
#set CASE = PPE_220_ensemble_1850.220
#set CASE = PPE_220_ensemble_4xCO2.220
#set CASE = PPE_220_ensemble_HIST-mbr3.220
#set CASE = PPE_220_ensemble_HIST-mbr1.220
set CASE = PPE_220_ensemble_HIST-mbr2.220

mkdir -p $CASEROOT/$CASE
cd $CASEROOT/$CASE

if ( ! -d "postprocess" ) then
   create_postprocess -caseroot=`pwd`
endif

cd postprocess

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


echo "Made it here"

# =========================
# change a few things
# =========================
mv timeseries timeseries-OTB
cp $CESM2_TOOLS_ROOT/pp/timeseries $CASEROOT/$CASE/postprocess

exit

