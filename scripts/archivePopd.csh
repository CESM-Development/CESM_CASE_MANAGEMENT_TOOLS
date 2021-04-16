#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-sf/
setenv ARCHDIR  /glade/scratch/cesmsf/archive/
setenv LOGSDIR  /glade/campaign/cgd/ccr/nanr/CESM2-SF-TMP/logs
setenv RESTDIR  /glade/campaign/cgd/ccr/nanr/CESM2-SF-TMP/restarts
setenv POPDDIR  /glade/campaign/cgd/ccr/nanr/CESM2-SF-TMP/popd

set smbr =  6
set embr =  6

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-GHG-SSP370.00${mbr}
else
        set CASE = b.e21.B1850cmip6.f09_g17.CESM2-SF-GHG-SSP370.0${mbr}
endif

tar -cvf $LOGSDIR/$CASE.logs.tar $ARCHDIR/$CASE/logs
tar -cvf $POPDDIR/$CASE.pop.dd.tar $ARCHDIR/$CASE/ocn/hist/*.pop.d*

set srest = 2018
set erest = 2051
@ sr = $srest
@ er = $erest

#while ($sr <= $er) 
   #tar -cvf $RESTDIR/$CASE.${sr}-01-01-00000.tar $ARCHDIR/$CASE/rest/${sr}-01-01-00000/
   #@ sr += 3
#end

end             # member loop

exit

