#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/$USER/cesm_tags/CASE_tools/ihesp-tools/
setenv ARCHDIR1  /glade/scratch/$USER/DP-HR/inputdata/cesm2_init/
setenv CAMPAIGN  /glade/campaign/collections/cmip/CMIP6/iHESP/inputdata/HR-DP/cesm2_init

set syr = 2018
set eyr = 2018
set syr = 2008
set eyr = 2008

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 11 )


# case name counter

set CASE = b.e13.DP-HR_IC.ne120_t12.${year}-${mon}.01

if (! -e $CAMPAIGN/$CASE.tar) then
   cd $ARCHDIR1
   tar -cvf $CAMPAIGN/$CASE.tar ./$CASE/
   `pwd`
   cd $CAMPAIGN
   gzip $CASE.tar 
else
   echo "IC archived done"
endif

end             # mon loop
end             # year loop

exit

