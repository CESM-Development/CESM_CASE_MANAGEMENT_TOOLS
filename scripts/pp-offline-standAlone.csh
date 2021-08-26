#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/pp-offline/
setenv DOUT_S_ROOT  /glade/scratch/$USER/archive/
setenv PPROOT /glade/scratch/$USER/post-proc/

module use /glade/work/bdobbins/Software/Modules
module load cesm_postprocessing

# ...
# case name counter
set smbr =  1
set embr =  1

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.B1PCTcmip6.f09_g17.rampUp.00${mbr}
else
        set CASE = b.e21.B1PCTcmip6.f09_g17.rampUp.0${mbr}
endif

mkdir -p $PPROOT/$CASE
cd $PPROOT/$CASE

if ( ! -d "postprocess" ) then
   create_postprocess -caseroot=`pwd`
endif

cd postprocess

cp $CESM2_TOOLS_ROOT/scripts/env_timeseries.xml $PPROOT/$CASE/postprocess

pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/scratch/$USER/timeseries/$CASE/
#pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/collections/cdg/timeseries-cmip6/$CASE
pp_config --set CASE=$CASE
pp_config --set DOUT_S_ROOT=$DOUT_S_ROOT/$CASE
pp_config --set ATM_GRID=0.9x1.25
pp_config --set LND_GRID=0.9x1.25
pp_config --set ICE_GRID=gx1v7
pp_config --set OCN_GRID=gx1v7
pp_config --set ICE_NX=320
pp_config --set ICE_NY=384


#pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/p/cesm/espwg/CESM2-SMYLE/timeseries/$CASE/
#qsub ./timeseries 

if ($mbr < 10) then
   set usembr = "00"${mbr}
else
   set usembr = "0"${mbr}
endif

echo $usembr

echo "Made it here"

# =========================
# change a few things
# =========================
#mv timeseries timeseries-OTB
cp $CESM2_TOOLS_ROOT/scripts/timeseries $PPROOT/$CASE/postprocess

#qsub ./timeseries

end             # member loop

exit

