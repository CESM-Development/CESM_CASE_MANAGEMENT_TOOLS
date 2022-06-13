#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-ENSO-BB/
setenv DOUT_S_ROOT  /glade/scratch/nanr/archive/
setenv CASEROOT /glade/scratch/nanr/post-proc/

module use /glade/work/bdobbins/Software/Modules
module load cesm_postprocessing

# ...
# case name counter
set smbr =  4
set embr =  20

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        #set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1251.020-ENSO-BB-lanina.00${mbr}
        #set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1301.015-ENSO-BB-el2BBcmp.00${mbr}
        #set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1231.018-ENSO-BB-el2BBcmp.00${mbr}
        #set CASE = b.e21.BSSP370smbb.f09_g17.LE2-1281.020-ENSO-BB-la5BBcmp.00${mbr}
        #set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1231.011-ENSO-BB-la4BBcmp.00${mbr}
        #set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1231.020-ENSO-BB-la3BBcmp.00${mbr}
        #set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1231.011-ENSO-BB-el4BBcmp.00${mbr}
        set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1251.016-ENSO-BB-el5BBcmp.00${mbr}
        #set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1231.015-ENSO-BB-el6BBcmp.00${mbr}
        #set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1231.012-ENSO-BB-la2BBcmp.00${mbr}
else
        #set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1251.020-ENSO-BB-lanina.0${mbr}
        #set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1301.015-ENSO-BB-el2BBcmp.0${mbr}
        #set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1231.018-ENSO-BB-el2BBcmp.0${mbr}
        set CASE = b.e21.BHISTsmbb.f09_g17.LE2-1251.016-ENSO-BB-el5BBcmp.0${mbr}
endif

mkdir -p $CASEROOT/$CASE
cd $CASEROOT/$CASE

if ( ! -d "postprocess" ) then
   create_postprocess -caseroot=`pwd`
endif

cd postprocess

#pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/scratch/nanr/timeseries/$CASE/
pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/collections/cdg/timeseries-cmip6/$CASE
pp_config --set CASE=$CASE
pp_config --set DOUT_S_ROOT=$DOUT_S_ROOT/$CASE
pp_config --set ATM_GRID=0.9x1.25
pp_config --set LND_GRID=0.9x1.25
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
mv timeseries timeseries-OTB
cp $CESM2_TOOLS_ROOT/pp/timeseries $CASEROOT/$CASE/postprocess

end             # member loop

exit

