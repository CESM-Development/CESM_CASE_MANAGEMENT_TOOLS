#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-ssp245ext-2deg/
setenv DOUT_S_ROOT  /glade/scratch/$USER/archive/
setenv PROCROOT /glade/scratch/$USER/post-proc/

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
         set CASE = b.e21.BSSP245cmip6.f19_g17.CMIP6-SSP2-4.5.00${mbr}
else
         set CASE = b.e21.BSSP245cmip6.f19_g17.CMIP6-SSP2-4.5.0${mbr}
endif

mkdir -p /glade/scratch/$USER/timeseries
mkdir -p $PROCROOT/$CASE
cd $PROCROOT/$CASE

if ( ! -d "postprocess" ) then
   create_postprocess -caseroot=`pwd`
endif

cd postprocess

pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/scratch/$USER/timeseries/$CASE/
#pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/collections/cdg/timeseries-cmip6/$CASE
pp_config --set CASE=$CASE
pp_config --set DOUT_S_ROOT=$DOUT_S_ROOT/$CASE
pp_config --set ATM_GRID=1.9x2.5
pp_config --set LND_GRID=1.9x2.5
pp_config --set ICE_GRID=gx1v7
pp_config --set OCN_GRID=gx1v7
pp_config --set ICE_NX=320
pp_config --set ICE_NY=384

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
cp $CESM2_TOOLS_ROOT/pp/timeseries $PROCROOT/$CASE/postprocess

#qsub ./timeseries
end             # member loop

exit

