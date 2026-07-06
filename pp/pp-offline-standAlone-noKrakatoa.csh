#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-NoPinatubo/
setenv DOUT_S_ROOT  /glade/scratch/nanr/archive/
setenv CASEROOT /glade/scratch/nanr/post-proc/

module use /glade/work/bdobbins/Software/Modules
module load cesm_postprocessing

# ...
# case name counter
#set COMPSET=BHISTsmbb
#set YEAR =  1251
#set YEAR =  1231
#set smbr =  11
#set embr =  20

set COMPSET=BHISTcmip6
#set YEAR =  1231
#set YEAR =  1251
#set YEAR =  1281
set YEAR =  1301
set smbr =  2
set embr =  9

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.${COMPSET}.f09_g17.LE2-${YEAR}.00${mbr}-noKrakatoa.00${mbr}
else
        set CASE = b.e21.${COMPSET}.f09_g17.LE2-${YEAR}.0${mbr}-noKrakatoa.0${mbr}
endif

mkdir -p $CASEROOT/$CASE
cd $CASEROOT/$CASE

if ( ! -d "postprocess" ) then
   create_postprocess -caseroot=`pwd`
endif

cd postprocess

#pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/scratch/nanr/timeseries/$CASE/
pp_config --set TIMESERIES_OUTPUT_ROOTDIR=/glade/campaign/cgd/cesm/CESM2-LE/CESM2-SF/noKrakatoa/timeseries/$CASE
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
# there is a hard-coded CASE in the timeseries file, so we need to replace it as we go...
sed -i "s/b.e21.BHISTsmbb.f09_g17.LE2-1301.012-noKrakatoa.012/$CASE/g" $CASEROOT/$CASE/postprocess/timeseries
sed -i "s/tSP/pp.nK$YEAR-$mbr/g" $CASEROOT/$CASE/postprocess/timeseries
qsub timeseries

end             # member loop

exit

